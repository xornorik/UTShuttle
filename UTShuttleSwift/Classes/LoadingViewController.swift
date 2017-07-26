//
//  LoadingViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 07/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingLabel:UILabel!
    @IBOutlet weak var splashImageView:UIImageView!
    
    var loadingTimer:Timer!
    let tcpClient = CommandClient.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        loadingLabel.alpha = 0 //start without showing loading
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        startAnimationLoop()
        if permissionCheck()
        {
            if true // Do only if exists on keychain - otherwise take to login page
            {
                configureClient()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Helper Functions
    
    func permissionCheck() -> Bool
    {
        //write code for checking required permissions
        return true //for now
    }
    
    func startAnimationLoop()
    {
        if loadingTimer == nil
        {
            loadingTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(animateloadingLabel), userInfo: nil, repeats: true)
        }
    }
    
    func stopAnimationLoop()
    {
        if loadingTimer != nil
        {
            loadingTimer.invalidate()
            loadingTimer = nil
        }
    }
    
    func configureClient()
    {
        tcpClient.deviceAuth { (response) in
            
            switch response
            {
            case .Success:
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.splashImageView.alpha = 0
                }, completion: { (success) in
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.setupUI()
                })
            case .InvalidDevice:
//                showError(title: "Alert", message: "Your Device is Invalid. Please request for a new unique ID by entering your phone number.") { _ in
//                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
//                        self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//                        self.splashImageView.alpha = 0
//                    }, completion: { (success) in
//                        let delegate = UIApplication.shared.delegate as! AppDelegate
//                        delegate.setupUI()
//                    })
//                }
                UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                    self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    self.splashImageView.alpha = 0
                }, completion: { (success) in
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.setupUI()
                })

            case .LoggedOut:
                showError(title: "Alert", message: "You have been logged out. Please request for a new unique ID by entering your phone number.") { _ in
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                        self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        self.splashImageView.alpha = 0
                    }, completion: { (success) in
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        delegate.setupUI()
                    })
                }
            case .ConnectionError:
                //                        showError(title: "Connection Lost", message: "Connection to server has been lost")
                showErrorWithRetry(title: "Connection Lost", message: "Connection to server has been lost") { _ in
                    self.configureClient()
                }
                
            }
            
        }
        
    }
    
    func animateloadingLabel()
    {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.loadingLabel.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            
            // Fade in
            UIView.animate(withDuration: 1.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.loadingLabel.alpha = 1.0
            }, completion: nil)
        })
    }

}
