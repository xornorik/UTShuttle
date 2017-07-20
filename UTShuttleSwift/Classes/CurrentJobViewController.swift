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
    
    var currentStopIndexPath:IndexPath?
    var rideDetails:[CurrentRideDetail]?
    var stops:[ScheduledRouteStop]?
    
    var tripId:String!
    var scheduleId:String!
    var fromStop:String!
    var toStop:String!
    
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
        
        currentStopIndexPath = IndexPath(item: 0, section: 0)
        nextStopButton.addTarget(self, action: #selector(nextStopButtonTapped), for: .touchUpInside)
        previousStopButton.addTarget(self, action: #selector(previousStopButtonTapped), for: .touchUpInside)
        
        tripNoLabel.text = tripId!
        fromLocationLabel.text = fromStop
        toLocationLabel.text = toStop
        
        getRideStops {
            self.getRideDetails()
        }
        goToCurrentStop()
        
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
                callback()
            }
            else
            {
                showError(title: "Alert", message: "Could not fetch ride stops")

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
        guard currentStopIndexPath?.item != nil else {return}
        let nextStopIndexPath = IndexPath(item: (currentStopIndexPath?.item)! + 1, section: 0)
        guard nextStopIndexPath.item < ((stops?.count)! - 1) else {return}
        
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
    
    func previousStopButtonTapped()
    {
        guard currentStopIndexPath?.item != nil else {return}
        let previousStopIndexPath = IndexPath(item: (currentStopIndexPath?.item)! - 1, section: 0)
        guard previousStopIndexPath.item >= 0 else {return}
        
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
        return (rideDetails!.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case tableView.numberOfRows(inSection: 0) - 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addGuestCell", for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let pickUplabel = cell.viewWithTag(100) as! UILabel
            let flightLabel = cell.viewWithTag(101) as! UILabel
            let timeLabel = cell.viewWithTag(102) as! UILabel
            let paxLabel = cell.viewWithTag(103) as! UILabel
            
            let rideDetail = rideDetails?[indexPath.row]
            pickUplabel.text = rideDetail?.pickupLocationName
            flightLabel.text = rideDetail?.flightNo
            timeLabel.text = rideDetail?.time
            paxLabel.text = rideDetail?.paxCount
            
            return cell
        }
        
    }
}
