//
//  NavigationUtils.swift
//  UTShuttleSwift
//
//  Created by Apple Developer on 08/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class NavigationUtils {
    
    
    
    static func presentVC(nextVC: UIViewController) {
        
        let currentNavController = UIApplication.topViewController()!.navigationController!
        
        nextVC.navigationItem.backBarButtonItem = nil
        nextVC.navigationItem.hidesBackButton = true
        
        currentNavController.present(nextVC, animated: true, completion: {})
    }
}
