//
//  DeviceRegistrationViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 10/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON

class DeviceRegistrationViewController: UIViewController {
    
    @IBOutlet weak var nextButton:UIButton!
    @IBOutlet weak var textMessageButton:UIButton!
    @IBOutlet weak var uidTextField:UITextField!
    @IBOutlet weak var phoneNoTextField:CountryPickerTextField!
    @IBOutlet weak var countryPickerButton:UIButton!

    
    let tcpClient = CommandClient.shared
    var countryPicker = UIPickerView()
    var countries = [Country]()
    var countryCode = "+1"


    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpVC() //ideally should be in viewdidappear, but did this coz of loading screen animation
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        setupCountryPicker()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Helper Functions
    
    func setUpVC()
    {
        self.navigationController?.isNavigationBarHidden = true
        
        //corner radii
        nextButton.cornerRadius = 10
        textMessageButton.cornerRadius = 10
        
        //delegates
        phoneNoTextField.delegate = self
        
        //assigning selectors
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        textMessageButton.addTarget(self, action: #selector(textMessageButtonTapped), for: .touchUpInside)
        countryPickerButton.addTarget(self, action: #selector(countryPickerButtonTapped), for: .touchUpInside)
        
        //setting gesture recognizer for dismissing keyboard
        let tapGC = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGC)
        
    }
    
    func setupCountryPicker()
    {
        if let path = Bundle.main.path(forResource: "countryCodes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let json = JSON(data: data)
                if json != JSON.null {
                    for jsonObj in json.array!
                    {
                        let country = Country(code: jsonObj["code"].stringValue, name: jsonObj["name"].stringValue, phoneCode: jsonObj["dial_code"].stringValue)
                        self.countries.append(country)
                    }
                } else {
                    print("Could not get json from file, make sure that file contains valid json.")
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
    }
    
    func dismissKeyboard()
    {
        self.view.endEditing(false)
    }
    
    func donePickingCountry()
    {
        phoneNoTextField.resignFirstResponder()
        phoneNoTextField.inputView = nil
        phoneNoTextField.inputAccessoryView = nil
        countryPickerButton.setTitle(countryCode, for: .normal)
        phoneNoTextField.becomeFirstResponder()
    }
    
    func nextButtonTapped()
    {
        guard let uid = uidTextField.text, uid != "" else {showError(title: "Alert", message: "Please enter the unique ID."); return}
        tcpClient.deviceRegistration(uniqueId: uid) { (success, error) in
            
            if success
            {
                NavigationUtils.goToDriverLogin()
            }
            else
            {
                switch error{
                case .ConnectionError:
                    showError(title: "Connection Lost", message: "Connection to server has been lost")
                case .InvalidUniqueId:
                    showError(title: "Alert", message: "The unique ID entered by you is invalid. Please enter the correct ID or send a request for another ID.")
                case .MobileNoNotFound:
                    showError(title: "Alert", message: "This unique ID has already been used for another device. Please contact your manager.")
                case .Success:
                    break
                }
            }
        }
    }

    func textMessageButtonTapped()
    {
        guard let mobileNo = phoneNoTextField.text, mobileNo != "" else {showError(title: "Alert", message: "Please enter the mobile number."); return}
        
        tcpClient.receiveUID(mobileNo: countryCode + mobileNo) { (success) in
            
            if success
            {
                uidTextField.text = Defaults[.uniqueId]
                phoneNoTextField.resignFirstResponder()
                //[!] show alert?
            }
            else
            {
                showError(title: "Alert", message: "Your cell phone is not registered with us. Please contact your manager to get this number registered.")
            }
        }
    }
    
    func countryPickerButtonTapped()
    {
        
        countryPicker.delegate = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = ColorPalette.UTSTeal
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donePickingCountry))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        phoneNoTextField.inputView = countryPicker
        phoneNoTextField.inputAccessoryView = toolBar
        
        phoneNoTextField.becomeFirstResponder()

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
extension DeviceRegistrationViewController : UIPickerViewDelegate, UIPickerViewDataSource
{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var resultView: SwiftCountryView
        
        if view == nil {
            resultView = SwiftCountryView()
        } else {
            resultView = view as! SwiftCountryView
        }
        resultView.setup(countries[row], locale: Locale(identifier: "en_US_POSIX"))
        
        return resultView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let country = countries[row]
        countryCode = country.phoneCode!
        countryPickerButton.setTitle(countryCode, for: .normal)
    }

}
