//
//  DeviceRegistrationViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 10/07/17.
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
        
        phoneNoTextField.delegate = self
        
        //setting gesture recognizer for dismissing keyboard
        let tapGC = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGC)
    }
    
    func dismissKeyboard()
    {
        self.view.endEditing(false)
    }
}
extension DeviceRegistrationViewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneNoTextField
        {
            moveTFUp(textField: textField)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField == phoneNoTextField
        {
            moveTFDown(textField: textField)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func moveTFUp(textField:UITextField)
    {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.frame.origin.y -= 216
        }, completion: nil)
        
    }
    
    func moveTFDown(textField:UITextField)
    {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.frame.origin.y += 216
        }, completion: nil)
    }
}
