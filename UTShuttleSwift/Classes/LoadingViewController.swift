//
//  LoadingViewController.swift
//  UTShuttleSwift
//
//  Created by Apple Developer on 07/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    @IBOutlet weak var loadingLabel:UILabel!
    
    var loadingTimer:Timer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadingLabel.alpha = 0 //start without showing loading
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        startAnimationLoop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Helper Functions
    
    
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
