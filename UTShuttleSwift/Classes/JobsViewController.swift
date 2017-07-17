//
//  JobsViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 14/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class JobsViewController: UIViewController {
    
    @IBOutlet weak var myJobsTableView:UITableView!
    @IBOutlet weak var availableJobsTableView:UITableView!
    @IBOutlet weak var myJobsTVHeight: NSLayoutConstraint!
    


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
    }
    
    func addJobTapped()
    {
        
    }

}
extension JobsViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == myJobsTableView
        {
            myJobsTVHeight.constant = (2 * 44)+30+54+5
            return 2
        }
        else
        {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == myJobsTableView
        {
            let cell = myJobsTableView.dequeueReusableCell(withIdentifier: "myJobCell", for: indexPath)
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
                return cell
            }
        }
    }
}
