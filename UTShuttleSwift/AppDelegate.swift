//
//  AppDelegate.swift
//  UTShuttleSwift
//
//  Created by Apple Developer on 06/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNC: UINavigationController?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //setting Theme
        DefaultStyle.sharedInstance.apply()
//        CommandClient.shared.startConnection()
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
        guard let isLoggedIn = Defaults[.isLoggedIn] else {Defaults[.isLoggedIn] = false; return}
        print(Defaults[.isLoggedIn] ?? "NOT THERE - THIS FAILED")
        if isLoggedIn
        {
            rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC")
        }
        else
        {
            guard let isDeviceRegistered = Defaults[.isDeviceRegistered] else {Defaults[.isDeviceRegistered] = false; return}
            if isDeviceRegistered
            {
                rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginFlowVC")
            }
            // else register - already instantiated

        }
        
        
        mainNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = self.mainNC
        
    }


}

