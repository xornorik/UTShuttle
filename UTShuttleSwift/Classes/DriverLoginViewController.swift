//
//  DriverLoginViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 10/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class DriverLoginViewController: UIViewController {
    
    @IBOutlet weak var userIdTF:UITextField!
    @IBOutlet weak var passwordTF:UITextField!
    @IBOutlet weak var checkBoxButton:UIButton!
    @IBOutlet weak var signUpButton:UIButton!
    @IBOutlet weak var loginButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper Functions
    
    func setupVC()
    {
        loginButton.cornerRadius = 10
        
    }

}
