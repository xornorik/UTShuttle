//
//  AppDelegate.swift
//  UTShuttleSwift
//
//  Created by Apple Developer on 06/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNC: UINavigationController?
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //setting Theme
        DefaultStyle.sharedInstance.apply()
        APIClient.shared.setup()
        
        //This will go to Loading page
        listenForReachability()
        LocationManager.shared.locationManager.requestAlwaysAuthorization()
        LocationManager.shared.startTracking()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        UIApplication.shared.setKeepAliveTimeout(600)
        {
            LocationManager.shared.stopTracking()
            LocationManager.shared.startTracking()
        }

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: Helper Functions
    
    func setupUI()
    {
        //check if logged in
        //show correct UI
        var rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "deviceRegistrationVC")
//        deviceRegistrationVC
        if Defaults[.deviceId] != nil
        {
            if Defaults[.isLoggedIn] ?? false
            {
                rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "dashboardVC")
            }
            else
            {
                rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "driverLoginVC")
            }
        }
        else
        {
            //device registration already instantiated
        }
        
        mainNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = self.mainNC
        
    }
    
    func listenForReachability()
    {
        self.reachabilityManager?.listener = { status in
            print("Network Status Changed: \(status)")
            switch status
            {
            case .notReachable:
                showError(title: "Oops", message: "We are experiencing a network connection issue. Please move to another location and try connecting again")
            case .reachable(_), .unknown:
                CommandClient.shared.startConnection()
                break
            }
        }
        
        self.reachabilityManager?.startListening()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        return .portrait;
    }


}

