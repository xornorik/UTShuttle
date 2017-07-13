//
//  DashboardViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 13/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var profilePhotoImageView:UIImageView!
    @IBOutlet weak var driverNameLabel:UILabel!
    @IBOutlet weak var driverVehicleLabel:UILabel!
    @IBOutlet weak var selectVehicleButton:UIButton!
    @IBOutlet weak var logOffButton:UIButton!
    @IBOutlet weak var versionLabel:UILabel!
    @IBOutlet weak var timeLogLabel:UILabel!
    @IBOutlet weak var menuTableView:UITableView!

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
        if (self.navigationController?.isNavigationBarHidden)!
        {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
extension DashboardViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath)
        let iconImage = cell.viewWithTag(100) as! UIImageView
        let mainLabel = cell.viewWithTag(101) as! UILabel
        let subLabel = cell.viewWithTag(102) as! UILabel
        
        switch indexPath.row {
        case 0:
            iconImage.image = UIImage(named: "")
            mainLabel.text = "My Jobs"
            subLabel.text = "Select or create job"
        case 1:
            iconImage.image = UIImage(named: "")
            mainLabel.text = "Routes"
            subLabel.text = "Create a new route"
        case 2:
            iconImage.image = UIImage(named: "")
            mainLabel.text = "Trip History"
            subLabel.text = "View past rides"
        case 3:
            iconImage.image = UIImage(named: "")
            mainLabel.text = "My Profile"
            subLabel.text = "Edit your profile information"
        default:
            print("Exhaustive")
        }
        return cell
    }
}
