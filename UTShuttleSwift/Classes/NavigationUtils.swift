//
//  NavigationUtils.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 08/07/17.
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
    
    static func goToDriverRegisterStep3()
    {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "driverRegisterVC") as! DriverRegisterViewController
        nextVC.rStatus = RegistrationStatus.step3
        self.pushToVC(nextVC: nextVC)
    }
    
    static func goToDashboard()
    {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dashboardVC")
        self.setCurrentVC(nextVC: nextVC)
    }
    
    static func presentVehicleSelection()
    {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vehicleVC")
        presentVC(nextVC: nextVC)
    }
    
    static func goToMyJobs()
    {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "jobsVC")
        self.pushToVC(nextVC: nextVC)
    }
    
    static func goToCurrentJob(tripId:String, scheduleId:String, fromStop:String, toStop:String)
    {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "currentJobVC") as! CurrentJobViewController
        nextVC.tripId = tripId
        nextVC.scheduleId = scheduleId
        nextVC.fromStop = fromStop
        nextVC.toStop = toStop
        self.pushToVC(nextVC: nextVC)
    }
    
    static func goToRoutes()
    {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "routesVC")
        pushToVC(nextVC: nextVC)
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
