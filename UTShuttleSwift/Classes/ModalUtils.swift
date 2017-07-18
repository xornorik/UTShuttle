//
//  ModalUtils.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 07/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import Alertift
import PKHUD

//Mark: Alert Functions

func showError(title: String, message: String, callback: (()->())? = nil) {
    
    Alertift.alert(title: title, message: message)
    .action(.default("OK")) { _ in
        callback?()
    }
    .show()
}

func showErrorWithRetry(title: String, message: String, callback: (()->())? = nil) {
    
    Alertift.alert(title: title, message: message)
        .action(.default("Retry")) { _ in
            callback?()
    }
    .show()
}

func showConfirm(title:String, message:String, callback: (()-> Void)!)
{
    Alertift.alert(title: title, message: message)
        .action(.default("Yes")) {  _ in
            callback()
        }
        .action(.cancel("No"))
        .show()
}

func showConfirmForModal(title:String, message:String,viewController:UIViewController ,callback: (()-> Void)!)
{
    Alertift.alert(title: title, message: message)
        .action(.default("Yes")) {  _ in
            callback()
        }
        .action(.cancel("No"))
        .show(on: viewController, completion: nil)
}

func showErrorForModal(title: String, message: String,viewController:UIViewController, callback: (()->())? = nil) {
    
    Alertift.alert(title: title, message: message)
        .action(.default("OK")) { _ in
            callback?()
        }
        .show(on: viewController, completion: nil)
}

// Mark: Activity Indicator Functions 

func showHUD()
{
    HUD.show(.labeledProgress(title: "", subtitle: "Loading"))
}

func isHUDVisible() -> Bool
{
    return HUD.isVisible
}

func hideHUD()
{
    HUD.hide()
}

func showSuccessHUD()
{
    HUD.flash(.success, delay: 0.3)
}

func showErrorHUD()
{
    HUD.flash(.error, delay: 0.3)
}



