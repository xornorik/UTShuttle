//
//  DriverLoginViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 10/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Alamofire

class DriverLoginViewController: UIViewController {
    
    @IBOutlet weak var userIdTF:UITextField!
    @IBOutlet weak var passwordTF:UITextField!
    @IBOutlet weak var checkBoxButton:UIButton!
    @IBOutlet weak var signUpButton:UIButton!
    @IBOutlet weak var loginButton:UIButton!
    
    var rememberMe = false
    let tcpClient = CommandClient.shared


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setupVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper Functions
    
    func setupVC()
    {
        loginButton.cornerRadius = 10
        
        //check if previous settings exist for remember me
        if let rememberMe = Defaults[.isLoginDetailsRemembered]
        {
            self.rememberMe = rememberMe
            if rememberMe
            {
                //add details from inApp persistence
                checkBoxButton.setImage(UIImage(named: "buttonCheckboxTrue"), for: .normal)
            }
            else
            {
                checkBoxButton.setImage(UIImage(named: "buttonCheckboxFalse"), for: .normal)
            }
        }
        else {
            Defaults[.isLoginDetailsRemembered] = false
        }
        
        //assigning selectors
        checkBoxButton.addTarget(self, action: #selector(toggleRememberMe), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    
    }
    
    func validateForm() -> Bool
    {
        guard userIdTF.text != "" else {showError(title: "Alert", message: "Please enter the user ID."); return false}
        guard passwordTF.text != "" else {showError(title: "Alert", message: "Please enter the password."); return false}
        
        return true
    }
    
    func toggleRememberMe()
    {
        if rememberMe
        {
            rememberMe = false
            Defaults[.isLoginDetailsRemembered] = false
            checkBoxButton.setImage(UIImage(named: "buttonCheckboxFalse"), for: .normal)
        }
        else
        {
            rememberMe = true
            Defaults[.isLoginDetailsRemembered] = true
            checkBoxButton.setImage(UIImage(named: "buttonCheckboxTrue"), for: .normal)

        }
    }
    
    func signUpTapped()
    {
        
    }
    
    func loginTapped()
    {
        if validateForm()
        {
            guard let deviceId = Defaults[.deviceId] else {return}
            //get lat and lon to pass - passing 0 for now
            
            tcpClient.driverAuth(userId: userIdTF.text!, password: passwordTF.text!, deviceId: deviceId, lat: "0", lon: "0", callback: { (success, error) in
                
                if success
                {
                    //go to Home Screen of app
                }
                else
                {
                    switch error
                    {
                    case .ConnectionError:
                        showError(title: "Connection Lost", message: "Connection to server has been lost")
                    case .InvalidVehicle:
                        showError(title: "Alert", message: "Invalid or Inactive Vehicle")
                    case .InvalidDriverCreds:
                        showError(title: "Alert", message: "Invalid Credentials")
                    case .DriverAlreadyLoggedIn:
                        showError(title: "Alert", message: "Driver Already Logged in")
                    case .InvalidDevice:
                        showError(title: "Alert", message: "Invalid or Inactive Device")
                    case .InvalidDriver:
                        showError(title: "Alert", message: "Invalid or Inactive Driver")
                    default:
                        break
                    }
                }
            })
        }
    }
    

}
