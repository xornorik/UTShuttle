//
//  TripHistoryViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 24/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class TripHistoryViewController: UIViewController {
    
    @IBOutlet weak var tripHistoryTableView:UITableView!
    var datewiseTripHistoryElements = [DatewiseTripHistory]()
    var apiClient = APIClient.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tripHistoryTableView.rowHeight = UITableViewAutomaticDimension
        tripHistoryTableView.estimatedRowHeight = 50

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getTripHistory()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTripHistory()
    {
        guard let username = Defaults[.driverUsername] else {return}
        apiClient.getDriverTripHistory(username: username) { (success, error, datewiseTripHistoryElements) in
            
            if success
            {
                self.datewiseTripHistoryElements = datewiseTripHistoryElements
                self.tripHistoryTableView.reloadData()
                
                if datewiseTripHistoryElements.count == 0
                {
                    //[!] should this even be there?
                    showError(title: "Alert", message: "No trips!!, Complete a job to view trip history.") {
                        NavigationUtils.popViewController()
                    }
                }
            }
            else
            {
                showError(title: "Alert", message: error) {
                    NavigationUtils.popViewController()
                }
            }
        }
    }
}
extension TripHistoryViewController : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
       return datewiseTripHistoryElements.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datewiseTripHistoryElements[section].tripHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripHistoryCell", for: indexPath)
        let indexLabel = cell.viewWithTag(100) as! UILabel
        let rideIdlabel = cell.viewWithTag(101) as! UILabel
        let fromStopLabel = cell.viewWithTag(102) as! UILabel
        let toStopLabel = cell.viewWithTag(103) as! UILabel
        
        let tripHistory = datewiseTripHistoryElements[indexPath.section].tripHistory[indexPath.row]
        indexLabel.text = String(indexPath.row + 1)
        rideIdlabel.text = tripHistory.rideId
        fromStopLabel.text = tripHistory.pickUpStop
        toStopLabel.text = tripHistory.dropOffStop
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 20))
        headerView.backgroundColor = UIColor(hex: "3C3C3C")
        let dateLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 50, height: 10))
        dateLabel.center.y = headerView.centerY
        dateLabel.textColor = UIColor.white
        headerView.addSubview(dateLabel)
        dateLabel.text = datewiseTripHistoryElements[section].tripDate
        dateLabel.sizeToFit()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}
