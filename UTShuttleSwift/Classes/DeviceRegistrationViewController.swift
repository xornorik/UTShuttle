//
//  DeviceRegistrationViewController.swift
//  UTShuttleSwift
//
//  Created by Apple Developer on 10/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class DeviceRegistrationViewController: UIViewController {
    
    @IBOutlet weak var nextButton:UIButton!
    @IBOutlet weak var textMessageButton:UIButton!
    @IBOutlet weak var uidTextField:UITextField!
    @IBOutlet weak var phoneNoTextField:UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setUpVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Helper Functions
    
    func setUpVC()
    {
        self.navigationController?.isNavigationBarHidden = true
        
        nextButton.cornerRadius = 10
        textMessageButton.cornerRadius = 10
        
    }
}
