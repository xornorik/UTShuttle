//
//  NavigationUtils.swift
//  UTShuttleSwift
//
//  Created by Apple Developer on 08/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class NavigationUtils {
    
    
    static func goToDriverLogin()
    {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "driverLoginVC")
        self.setCurrentVC(nextVC: nextVC)
    }
    
    static func goToDriverRegisterStep1()
    {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "driverRegisterVC")
        self.pushToVC(nextVC: nextVC)
    }
    
    static func goToDriverRegisterStep2()
    {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "driverRegisterVC") as! DriverRegisterViewController
        nextVC.rStatus = RegistrationStatus.step2
        self.pushToVC(nextVC: nextVC)
    }
    
    static func goToDriverRegisterStep3(profilePhotoForUpload:UIImage?) //for passing the photo to final VC
    {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "driverRegisterVC") as! DriverRegisterViewController
        nextVC.rStatus = RegistrationStatus.step3
        nextVC.selectedPhoto = profilePhotoForUpload
        self.pushToVC(nextVC: nextVC)
    }
    
    static func presentVC(nextVC: UIViewController) {
        
        let currentNavController = UIApplication.topViewController()!.navigationController!
        
        nextVC.navigationItem.backBarButtonItem = nil
        nextVC.navigationItem.hidesBackButton = true
        
        currentNavController.present(nextVC, animated: true, completion: {})
    }
    
    static func pushToVC(nextVC: UIViewController) {
        
        let currentNavController = UIApplication.topViewController()!.navigationController!
        currentNavController.navigationBar.topItem?.title = " " // for clearing back button title
        
        currentNavController.pushViewController(nextVC, animated: true)
    }
    
    static func setCurrentVC(nextVC: UIViewController) {
        
        let currentNavController = UIApplication.topViewController()!.navigationController!
        
        nextVC.navigationItem.backBarButtonItem = nil
        nextVC.navigationItem.hidesBackButton = true
        
        currentNavController.popViewController(animated: false)
        currentNavController.setViewControllers([nextVC], animated: true)
        
    }
}
