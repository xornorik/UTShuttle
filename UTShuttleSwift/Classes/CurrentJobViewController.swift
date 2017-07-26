//
//  CurrentJobViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 16/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class CurrentJobViewController: UIViewController {
    
    @IBOutlet weak var tripNoLabel:UILabel!
    @IBOutlet weak var fromLocationLabel:UILabel!
    @IBOutlet weak var toLocationLabel:UILabel!
    @IBOutlet weak var timeLabel:UILabel!
    @IBOutlet weak var startJobButton:UIButton!
    @IBOutlet weak var previousStopButton:UIButton!
    @IBOutlet weak var currentStopLabel:UILabel!
    @IBOutlet weak var nextStopButton:UIButton!
    @IBOutlet weak var stopsCollectionView:UICollectionView!
    @IBOutlet weak var jobDetailsTableView:UITableView!

    var apiClient = APIClient.shared
    var tcpClient = CommandClient.shared
    
    var currentStopIndexPath:IndexPath?
    var rideDetails:[CurrentRideDetail]?
    var stops:[ScheduledRouteStop]?
    var currentStop:ScheduledRouteStop?
    
    var tripId:String!
    var scheduleId:String!
    var fromStop:String!
    var toStop:String!
    var scheduledTime:String!
    var isJobStarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupVC()
    {
        self.title = "Current Job"
        jobDetailsTableView.rowHeight = UITableViewAutomaticDimension
        jobDetailsTableView.estimatedRowHeight = 44
        
        tripNoLabel.text = tripId!
        fromLocationLabel.text = fromStop
        toLocationLabel.text = toStop
        timeLabel.text = scheduledTime
        if let _ = Defaults[.jobId]
        {
            isJobStarted = true
        }
        
        setUIBasedOnJobStatus()
        
        getRideStops {
            self.getRideDetails()
        }        
    }
    
    func setUIBasedOnJobStatus()
    {
         if isJobStarted //exisiting job incomplete
        {
            self.startJobButton.setTitle("COMPLETE TRIP", for: .normal)
            self.startJobButton.removeTarget(self, action: #selector(self.startjobTapped), for: .touchUpInside)
            self.startJobButton.addTarget(self, action: #selector(self.completeTripButtonTapped), for: .touchUpInside)
            self.nextStopButton.isHidden = false
            self.previousStopButton.isHidden = false
            nextStopButton.addTarget(self, action: #selector(nextStopButtonTapped), for: .touchUpInside)
            previousStopButton.addTarget(self, action: #selector(previousStopButtonTapped), for: .touchUpInside)
        }
        else
        {
            self.startJobButton.addTarget(self, action: #selector(self.startjobTapped), for: .touchUpInside)
            nextStopButton.isHidden = true
            previousStopButton.isHidden = true

        }

    }
    
    func syncTripDetails()
    {
        if let currentStopId = Defaults[.currentStopId]
        {
            if currentStopId == "0"
            {
                currentStop = stops?[0]
                currentStopIndexPath = IndexPath(row: 0, section: 0)
                currentStopLabel.text = currentStop?.stopName
                goToCurrentStop()
                
            }
            else
            {
                for (index,stop) in stops!.enumerated()
                {
                    if stop.stopId == currentStopId
                    {
                        currentStop = stop
                        currentStopIndexPath = IndexPath(item: index, section: 0)
                        currentStopLabel.text = currentStop?.stopName
                        goToCurrentStop()
                        break
                    }
                }
            }
        }
        else
        {
            currentStop = stops?[0]
            currentStopIndexPath = IndexPath(item: 0, section: 0)
            currentStopLabel.text = currentStop?.stopName
        }
    }
    
    func getRideDetails()
    {
        guard let username = Defaults[.driverUsername] else {return}
        guard tripId != nil else {return}
        apiClient.getCurrentRideDetails(username: username, rideId: Double(self.tripId)!) { (success, error, rideDetails) in
            
            if success
            {
                self.rideDetails = rideDetails
                self.jobDetailsTableView.reloadData()
            }
            else
            {
                showError(title: "Alert", message: "Could not fetch ride details")
            }
        }
    }
    
    func getRideStops(callback:@escaping ()->())
    {
        apiClient.getCurrentRideStops(scheduleId: Int(self.scheduleId)!) { (success, error, stops) in
            if success
            {
                self.stops = stops
                self.stopsCollectionView.reloadData()
                self.syncTripDetails()
                callback()
            }
            else
            {
                showError(title: "Alert", message: "Could not fetch ride stops")

            }
        }
    }
    
    func startjobTapped()
    {
        showConfirm(title: "Alert", message: "Are you sure you want to start the trip?") { 
            guard let deviceId = Defaults[.deviceId] else {return}
            guard let rideId = self.tripId else {return}
            self.tcpClient.startJob(deviceId: deviceId, rideId: rideId) { (success, error) in
                if success
                {
                    self.startJobButton.setTitle("COMPLETE TRIP", for: .normal)
                    self.startJobButton.removeTarget(self, action: #selector(self.startjobTapped), for: .touchUpInside)
                    self.startJobButton.addTarget(self, action: #selector(self.completeTripButtonTapped), for: .touchUpInside)
                    self.nextStopButton.isHidden = false
                    self.previousStopButton.isHidden = false
                    self.nextStopButton.addTarget(self, action: #selector(self.nextStopButtonTapped), for: .touchUpInside)
                    self.previousStopButton.addTarget(self, action: #selector(self.previousStopButtonTapped), for: .touchUpInside)
                    self.isJobStarted = true
                    self.jobDetailsTableView.reloadData()
                }
                else
                {
                    switch error
                    {
                    case .Fail:
                        showError(title: "Alert", message: "Action failed, Please try again")
                    case .DriverAlreadyOnJob:
                        showError(title: "Alert", message: "Please complete the current job before beginning another one.")
                    case .ConnectionError:
                        showError(title: "Connection Lost", message: "Connection to server has been lost")
                    case .Success:
                        print("Should not come here")
                    }
                }
            }
        }
    }
    
    func completeTripButtonTapped()
    {
        showConfirm(title: "Alert", message: "Are you sure you want to complete the trip?") { 
            guard let deviceId = Defaults[.deviceId] else {return}
            guard let rideId = self.tripId else {return}
            guard let lat = Defaults[.lastLatitude] else {return}
            guard let lon = Defaults[.lastLongitude] else {return}
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let deviceTime = dateFormatter.string(from: Date())
            
            self.tcpClient.completeTrip(deviceId: deviceId, rideId: rideId, deviceTime: deviceTime, lat: String(lat), lon: String(lon)) { (success) in
                
                if success
                {
                    Defaults[.jobId] = nil
                    Defaults[.currentStopId] = nil
                    NavigationUtils.popViewController()
                }
                else
                {
                    showError(title: "Alert", message: "Action Failed, Please try again.")
                }
            }

        }
    }
    
    func goToCurrentStop()
    {
        guard (stops?.count) != nil else {return}
        guard let currentStopIndexPath = self.currentStopIndexPath else {return}
        UIView.animate(withDuration: 0.1, animations: {
            self.stopsCollectionView.scrollToItem(at: currentStopIndexPath, at: .centeredHorizontally, animated: false)
        })
    }
    
    func nextStopButtonTapped()
    {
        guard let deviceId = Defaults[.deviceId] else {return}
        guard let currentStopIndex = currentStopIndexPath?.row else {return}
        guard currentStopIndex < (stops?.count)! else {return} //do nothing if it's the last stop
        let nextStop = stops?[currentStopIndex + 1]
        
        tcpClient.updateCurrentTrip(deviceId: deviceId, rideId: self.tripId, currentStopId: (nextStop?.stopId)!) { (success) in
            
            if success
            {
                guard currentStopIndexPath?.item != nil else {return}
                let nextStopIndexPath = IndexPath(item: (currentStopIndexPath?.item)! + 1, section: 0)
                guard nextStopIndexPath.item <= ((stops?.count)!) else {return}
                self.currentStopLabel.text = stops?[nextStopIndexPath.row].stopName
                
                UIView.animate(withDuration: 0.1, animations: {
                    self.stopsCollectionView.scrollToItem(at: nextStopIndexPath, at: .centeredHorizontally, animated: false)
                }) { (true) in
                    let cell = self.stopsCollectionView.cellForItem(at: self.currentStopIndexPath!) as! UTSNodeCollectionViewCell
                    cell.drawRightConnector(duration: 0.1) {
                        let nextCell = self.stopsCollectionView.cellForItem(at: nextStopIndexPath) as! UTSNodeCollectionViewCell
                        nextCell.drawLeftConnector(duration: 0.1, callback: {
                            nextCell.animateNodeColorChange(duration: 0.1, callback: {
                                self.currentStopIndexPath = nextStopIndexPath
                                self.stopsCollectionView.reloadItems(at: [self.currentStopIndexPath!,IndexPath(item: (self.currentStopIndexPath?.item)! - 1, section: 0)])
                            })
                        })
                    }
                }
            }
            else
            {
                showError(title: "Alert", message: "Action Failed, Please try again.")
            }
        }
    }
    
    func previousStopButtonTapped()
    {
        guard let deviceId = Defaults[.deviceId] else {return}
        guard let currentStopIndex = currentStopIndexPath?.row else {return}
        guard currentStopIndex != 0 else {return}         //do nothing if the current stop is the first stop
        let nextStop = stops?[currentStopIndex - 1]
        
        tcpClient.updateCurrentTrip(deviceId: deviceId, rideId: self.tripId, currentStopId: (nextStop?.stopId)!) { (success) in
            
           if success
           {
            guard currentStopIndexPath?.item != nil else {return}
            let previousStopIndexPath = IndexPath(item: (currentStopIndexPath?.item)! - 1, section: 0)
            guard previousStopIndexPath.item >= 0 else {return}
            self.currentStopLabel.text = stops?[previousStopIndexPath.row].stopName
            
            
            UIView.animate(withDuration: 0.1, animations: {
                self.stopsCollectionView.scrollToItem(at: previousStopIndexPath, at: .centeredHorizontally, animated: false)
            }) { (true) in
                let cell = self.stopsCollectionView.cellForItem(at: self.currentStopIndexPath!) as! UTSNodeCollectionViewCell
                cell.drawRightConnector(duration: 0.1) {
                    let nextCell = self.stopsCollectionView.cellForItem(at: previousStopIndexPath) as! UTSNodeCollectionViewCell
                    nextCell.drawLeftConnector(duration: 0.1, callback: {
                        nextCell.animateNodeColorChange(duration: 0.1, callback: {
                            self.currentStopIndexPath = previousStopIndexPath
                            self.stopsCollectionView.reloadItems(at: [self.currentStopIndexPath!,IndexPath(item: (self.currentStopIndexPath?.item)! + 1, section: 0)])
                        })
                    })
                }
            }

            }
            else
           {
            showError(title: "Alert", message: "Action Failed, Please try again.")
            }
        }
    }
    
    func loadPassengerButtontapped(sender:UIButton)
    {
        //have to show view first
        let cell = sender.superview?.superview?.superview?.superview as! UITableViewCell
        guard let indexPath = jobDetailsTableView.indexPath(for: cell) else {print("indexPath issue");return}
        guard let currentStop = currentStop else {print("current stop issue");return}
        guard let jobDetail = rideDetails?[indexPath.row] else {print("jobdetail issue");return}
        
        let popupView = PaxCounterView(jobDetail: jobDetail, currentStop: currentStop, rideId: self.tripId)
        popupView?.saveButtonCallback = self.getRideDetails
        popupView?.show()
    }
    
    
    func unloadPassengerButtontapped(sender:UIButton)
    {
        let cell = sender.superview?.superview?.superview?.superview as! UITableViewCell
        guard let indexPath = jobDetailsTableView.indexPath(for: cell) else {print("indexPath issue");return}
        guard let jobDetail = rideDetails?[indexPath.row] else {print("jobdetail issue");return}
        
        guard let deviceId = Defaults[.deviceId] else {return}
        guard let currentStop = currentStop else {return}
        guard let lat = Defaults[.lastLatitude] else {return}
        guard let lon = Defaults[.lastLongitude] else {return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let deviceTime = dateFormatter.string(from: Date())
        
        
        tcpClient.unloadPassenger(deviceId: deviceId, refId: jobDetail.refId!, rideId: self.tripId, stopId: currentStop.stopId!, deviceTime: deviceTime, lat: String(lat), lon: String(lon), sourceTypeId: jobDetail.sourceTypeId!, paxCount: jobDetail.paxCount!, paxDetailId: jobDetail.paxDetailId!) { (success) in
            
            if success
            {
                self.getRideDetails()

            }
            else
            {
                showError(title: "Alert", message: "Action Failed, Please try again.")
            }
        }
    }

}
extension CurrentJobViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stops?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nodeCell", for: indexPath) as! UTSNodeCollectionViewCell
        cell.name = (stops?[indexPath.item].stopName)!

        switch indexPath.item
        {
        case 0:
            if let currentStop = currentStopIndexPath?.item
            {
                if indexPath.item < currentStop
                {
                    cell.type = .firstPassed
                }
                else
                {
                    cell.type = .first
                }
                
            }
            else
            {
                cell.type = .first
            }
        case collectionView.numberOfItems(inSection: 0) - 1:
            cell.type = .last

        default:
            
            if let currentStop = currentStopIndexPath?.item
            {
                if indexPath.item < currentStop
                {
                    cell.type = .middlePassed
                }
                else if indexPath.item == currentStop
                {
                    cell.type = .middleReached
                }
                else
                {
                    cell.type = .middle
                }
            }
            else
            {
                cell.type = .middle
            }
        }
        cell.setupCell()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellCount = stops?.count ?? 0
        let cellWidth:CGFloat = 70
        let cellSpacing = 0
        
        let totalCellWidth = cellWidth * CGFloat(cellCount)
        let totalSpacingWidth = cellSpacing * (cellCount - 1)
        
        if totalCellWidth < collectionView.bounds.size.width
        {
            let leftInset = (collectionView.frame.size.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
            let rightInset = leftInset
        
            return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
        }
        else
        {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
}
extension CurrentJobViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard rideDetails != nil else {return 0}
        return (rideDetails!.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let pickUplabel = cell.viewWithTag(100) as! UILabel
        let flightLabel = cell.viewWithTag(101) as! UILabel
        let timeLabel = cell.viewWithTag(102) as! UILabel
        let paxLabel = cell.viewWithTag(103) as! UILabel
        let paxButton = cell.viewWithTag(104) as! UIButton
        
        let rideDetail = rideDetails?[indexPath.row]
        pickUplabel.text = rideDetail?.pickupLocationName
        flightLabel.text = rideDetail?.flightNo
        timeLabel.text = rideDetail?.time
        paxLabel.text = rideDetail?.paxCount
        
        if isJobStarted
        {
            paxButton.isHidden = false
            if rideDetail?.tripStatus == TripStatus.Board
            {
                paxButton.setTitle("BOARD", for: .normal)
                paxButton.removeTarget(self, action: #selector(unloadPassengerButtontapped(sender:)), for: .touchUpInside)
                paxButton.addTarget(self, action: #selector(loadPassengerButtontapped(sender:)), for: .touchUpInside)
            }
            else
            {
                paxButton.setTitle("UNLOAD", for: .normal)
                paxButton.removeTarget(self, action: #selector(loadPassengerButtontapped(sender:)), for: .touchUpInside)
                paxButton.addTarget(self, action: #selector(unloadPassengerButtontapped(sender:)), for: .touchUpInside)
            }
        }
        else
        {
            paxButton.isHidden = true
        }
        
        return cell

    }
}
