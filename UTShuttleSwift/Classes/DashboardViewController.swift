//
//  DashboardViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 13/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Kingfisher

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var profilePhotoImageView:RoundedImageView!
    @IBOutlet weak var driverNameLabel:UILabel!
    @IBOutlet weak var driverVehicleLabel:UILabel!
    @IBOutlet weak var selectVehicleButton:UIButton!
    @IBOutlet weak var logOffButton:UIButton!
    @IBOutlet weak var versionLabel:UILabel!
    @IBOutlet weak var timeLogLabel:UILabel!
    @IBOutlet weak var menuTableView:UITableView!
    
    let apiClient = APIClient.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.estimatedRowHeight = 68
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func viewWillLayoutSubviews() { //variable size
//        
//        //rounding the profile pic
//        self.profilePhotoImageView.makeCircle = true
//    }
    
    func setupVC()
    {
        if (self.navigationController?.isNavigationBarHidden)!
        {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        //setting up title View
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 133, height: 40))
        let imageView = UIImageView(image: UIImage(named: "logoUTShuttleLite"))
        imageView.frame = CGRect(x: 0, y: 0, width: titleView.width, height: titleView.height)
        titleView.addSubview(imageView)
        self.navigationItem.titleView = titleView
        
        //add border to profile pic
        self.profilePhotoImageView.layer.borderWidth = 3
        self.profilePhotoImageView.layer.borderColor = ColorPalette.UTSTealLight.cgColor
        
        versionLabel.text = "Version: " + DeviceDetails.appVersion()
        timeLogLabel.text = "Logged in at " + Defaults[.driverLoginTime]!
    }
    
    func getDriverDetails()
    {
       guard let username = Defaults[.driverUsername] else {return}
       apiClient.getDriverProfile(username: username) { (success, error) in
        
            if success
            {
                guard let imageUrl = Defaults[.driverProfilePhoto] else {return}
                let url = URL(string: imageUrl)
                self.profilePhotoImageView.kf.setImage(with: url, placeholder: UIImage(named: "imgUserProfilePlaceholder"), options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                    self.profilePhotoImageView.image = image
                })
                self.driverNameLabel.text = Defaults[.driverFirstName]! + " " + Defaults[.driverLastName]!
                
            }
            else
            {
                showErrorWithRetry(title: "Alert", message: "Unable to fetch driver details. Please try again.") { _ in
                    
                    self.getDriverDetails()
                }
            }
        
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
            iconImage.image = UIImage(named: "iconMyJobs")
            mainLabel.text = "My Jobs"
            subLabel.text = "Select or create job"
        case 1:
            iconImage.image = UIImage(named: "iconRoutes")
            mainLabel.text = "Routes"
            subLabel.text = "Create a new route"
        case 2:
            iconImage.image = UIImage(named: "iconTripHistory")
            mainLabel.text = "Trip History"
            subLabel.text = "View past rides"
        case 3:
            iconImage.image = UIImage(named: "iconMyProfile")
            mainLabel.text = "My Profile"
            subLabel.text = "Edit your profile information"
        default:
            print("Exhaustive")
        }
        return cell
    }
}
