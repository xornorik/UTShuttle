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
    let tcpClient = CommandClient.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.rowHeight = UITableViewAutomaticDimension
        menuTableView.estimatedRowHeight = 68
        
        setupVC()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setVehicleIfSelected()

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
        
        selectVehicleButton.addTarget(self, action: #selector(selectVehicleTapped), for: .touchUpInside)
        logOffButton.addTarget(self, action: #selector(logOffTapped), for: .touchUpInside)
        
        getDriverDetails()
    }
    
    func selectVehicleTapped()
    {
        NavigationUtils.presentVehicleSelection()
    }
    
    func setVehicleIfSelected()
    {
        if let vehicleNo = Defaults[.driverVehicleNo]
        {
            self.driverVehicleLabel.text = vehicleNo
            self.selectVehicleButton.setTitle("Change my Vehicle", for: .normal)
        }
        else
        {
            self.driverVehicleLabel.text = "????"
            self.selectVehicleButton.setTitle("Select Vehicle", for: .normal)
            
            showConfirm(title: "Alert", message: "", callback: { 
                NavigationUtils.presentVehicleSelection()
            })

        }
        
    }
    
    func getDriverDetails()
    {
       guard let username = Defaults[.driverUsername], username != "" else {return}
        print(username)
       apiClient.getDriverProfile(username: username) { (success, error) in
        
            if success
            {
                guard let imageUrl = Defaults[.driverProfilePhoto] else {return}
                let url = URL(string: imageUrl)
                self.profilePhotoImageView.kf.setImage(with: url, placeholder: UIImage(named: "imgUserProfilePlaceholder"), options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                    guard image != nil else {self.profilePhotoImageView.image = UIImage(named: "imgUserProfilePlaceholder");return}
                    self.profilePhotoImageView.image = image
                })
                print(Defaults[.driverFirstName]!)
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
    
    func logOffTapped()
    {
        guard let deviceId = Defaults[.deviceId] else {return}
        guard let userId = Defaults[.driverUsername] else {return}
        guard let lat = Defaults[.lastLatitude] else {return}
        guard let lon = Defaults[.lastLongitude] else {return}
        tcpClient.logoff(deviceId: deviceId, userId: userId, lat: String(lat), lon: String(lon)) { (success) in
            
            if success
            {
                logOff()
            }
            else
            {
                showConfirm(title: "Confirm", message: "Device is not connected. Do you still want to log off?", callback: { 
                    self.logOff()
                })
            }
        }
    }
    
    func logOff()
    {
        Defaults[.isLoggedIn] = false
        if !(Defaults[.isLoginDetailsRemembered] ?? true)
        {
            Defaults[.driverUsername] = nil
            Defaults[.driverPassword] = nil
        }
        Defaults[.lastLongitude] = nil
        Defaults[.lastLatitude] = nil
        Defaults[.driverFirstName] = nil
        Defaults[.driverLastName] = nil
        Defaults[.driverEmail] = nil
        Defaults[.driverMobile] = nil
        Defaults[.driverCountryCode] = nil
        Defaults[.driverLicense] = nil
        Defaults[.driverLicenseExp] = nil
        Defaults[.driverProfilePhoto] = nil
        Defaults[.driverProfilePhotoSize] = nil
        Defaults[.driverLoginTime] = nil
        Defaults[.driverVehicleNo] = nil
        Defaults[.driverVehicleId] = nil
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.setupUI()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row
        {
        case 0:
            NavigationUtils.goToMyJobs()
        case 1:
            NavigationUtils.goToRoutes()
        case 2:
            NavigationUtils.goToTripHistory()
        default:
            print("Not yet defined")
        }
    }
}
