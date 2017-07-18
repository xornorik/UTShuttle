//
//  JobsViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 14/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class JobsViewController: UIViewController {
    
    @IBOutlet weak var myJobsTableView:UITableView!
    @IBOutlet weak var availableJobsTableView:UITableView!
    @IBOutlet weak var myJobsTVHeight: NSLayoutConstraint!
    @IBOutlet weak var datelabel:UILabel!
    
    var scheduledJobs = [ScheduledJob]()
    var rideDetails = [RideDetail]()
    
    let apiClient = APIClient.shared

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
        availableJobsTableView.rowHeight = UITableViewAutomaticDimension
        availableJobsTableView.estimatedRowHeight = 50
        
        self.title = "My Jobs"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "buttonAddJob"), style: .done, target: self, action: #selector(addJobTapped))
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE, dth MMM"
        datelabel.text = "Today, " + dateformatter.string(from: Date())

        
        getScheduledJobs()
        getRideDetails()
    }
    
    func addJobTapped()
    {
        
    }
    
    func getScheduledJobs()
    {
        guard let username = Defaults[.driverUsername] else {return}
        
        apiClient.getRouteSheduledJobList(username: username) { (success, error, scheduledJobs) in
            
            if success
            {
                self.scheduledJobs = scheduledJobs
                self.myJobsTableView.reloadData()
            }
            else
            {
//                showError(title: "Alert", message: "Could not Fetch Scheduled Jobs")
            }
            
        }
    }
    
    func getRideDetails()
    {
        guard let username = Defaults[.driverUsername] else {return}
        apiClient.getRideDetails(username: username) { (success, error, rideDetails) in
            
            if success
            {
                self.rideDetails = rideDetails
            }
            else
            {
//                showError(title: "Alert", message: "Could not Fetch ride details")
            }
        }
    }

}
extension JobsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == myJobsTableView
        {
            myJobsTVHeight.constant = CGFloat((scheduledJobs.count * 44)+30+54+5)
            return scheduledJobs.count
        }
        else
        {
            return rideDetails.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == myJobsTableView
        {
            let cell = myJobsTableView.dequeueReusableCell(withIdentifier: "myJobCell", for: indexPath)
            let indexLabel = cell.viewWithTag(100) as! UILabel
            let fromlabel = cell.viewWithTag(101) as! UILabel
            let toLabel = cell.viewWithTag(102) as! UILabel
            let timeLabel = cell.viewWithTag(103) as! UILabel
            
            let job = scheduledJobs[indexPath.row]
            
            indexLabel.text = String(indexPath.row + 1)
            fromlabel.text = job.fromStop
            toLabel.text = job.toStop
            timeLabel.text = job.time
            
            return cell
        }
        else
        {
            if indexPath.row == 0
            {
                let cell = availableJobsTableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
                return cell
            }
            else
            {
                let cell = availableJobsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                let pickupLabel = cell.viewWithTag(100) as! UILabel
                let flightLabel = cell.viewWithTag(101) as! UILabel
                let timeLabel = cell.viewWithTag(102) as! UILabel
                let paxLabel = cell.viewWithTag(103) as! UILabel
                
                let rideDetail = rideDetails[indexPath.row]
                
                pickupLabel.text = rideDetail.pickupLocation
                flightLabel.text = rideDetail.flightDetails
                timeLabel.text = rideDetail.time
                paxLabel.text = rideDetail.pax
                
                return cell
            }
        }
    }
}
