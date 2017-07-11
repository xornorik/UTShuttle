//
//  LoadingViewController.swift
//  UTShuttleSwift
//
//  Created by Apple Developer on 07/07/17.
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
            tcpClient.deviceAuth { (success) in
                if success
                {
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                        self.view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        self.splashImageView.alpha = 0
                    }, completion: { (success) in
                        let delegate = UIApplication.shared.delegate as! AppDelegate
                        delegate.setupUI()
                    })
                }
                else
                {
                    showError(title: "Connection Lost", message: "Connection to server has been lost")
                }
                
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
