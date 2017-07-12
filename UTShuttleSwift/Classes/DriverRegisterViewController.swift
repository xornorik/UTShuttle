//
//  DriverRegisterViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 11/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import SwiftyJSON

enum RegistrationStatus {
    case step1
    case step2
    case step3
}

class DriverRegisterViewController: UIViewController {
    
    @IBOutlet weak var stepImageView:UIImageView!
    @IBOutlet weak var registerTableView:UITableView!
    @IBOutlet weak var nextButton:UIButton!
    
    var rStatus = RegistrationStatus.step1

    var firstName = ""
    var lastname = ""
    var email = ""
    var mobile = ""
    var licenseNo = ""
    var licenseExp = ""
    var username = ""
    var password = ""
    
    var countryPicker = UIPickerView()
    var countries = [Country]()
    var phoneCellIndexPath:IndexPath?
    var chosenCountry = Country(code: "US", name: "United States", phoneCode: "+1")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupVC()
        
        if rStatus == .step1 {setupCountryPicker()}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupVC()
    {
        if (self.navigationController?.isNavigationBarHidden)!
        {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }

        switch rStatus {
        case .step1:
            self.title = "Profile Information"
            self.stepImageView.image = UIImage(named: "imgRegStep1")
        case .step2:
            self.title = "Driver Information"
            self.stepImageView.image = UIImage(named: "imgRegStep2")
        case .step3:
            self.title = "Account Information"
            self.stepImageView.image = UIImage(named: "imgRegStep3")

        }
        
        nextButton.cornerRadius = 10
        self.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
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
    
    func nextButtonTapped()
    {
        switch rStatus {
        case .step1:
            storeDetails()
            NavigationUtils.goToDriverRegisterStep2()
        case .step2:
            storeDetails()
            NavigationUtils.goToDriverRegisterStep3()
        default:
            print("This should not happen")
        }
    }
    
    func textFieldDidChange(textField: UITextField)
    {
        switch rStatus {
        case .step1:
            switch textField.tag {
            case 1000:
                firstName = textField.text!
            case 1001:
                lastname = textField.text!
            case 1002:
                email = textField.text!
            case 1003:
                mobile = chosenCountry.phoneCode! + textField.text!
            default:
                print("Exhaustive")
            }
        case .step2:
            break
        case .step3:
            break
        }
    }
    
    func storeDetails()
    {
        switch rStatus {
        case .step1:
            Defaults[.driverFirstName] = firstName
            Defaults[.driverLastName] = lastname
            Defaults[.driverEmail] = email
            Defaults[.driverMobile] = mobile
        case .step2:
            Defaults[.driverLicense] = licenseNo
            Defaults[.driverLicenseExp] = licenseExp
        case .step3:
            Defaults[.driverUsername] = username
            Defaults[.driverPassword] = password
        }
    }
    
    func validate()
    {
    
    }
    
    func countryPickerButtonTapped()
    {
        guard rStatus == .step1 else{return}
        let phoneNoCell = self.registerTableView.cellForRow(at: phoneCellIndexPath!)//button.superview?.superview as? UITableViewCell
        let phoneNotextField = phoneNoCell?.viewWithTag(1003) as! UITextField
        
        if phoneNotextField.isFirstResponder
        {
            phoneNotextField.resignFirstResponder()
        }
        
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
        phoneNotextField.inputView = countryPicker
        phoneNotextField.inputAccessoryView = toolBar
        
        phoneNotextField.becomeFirstResponder()
        
    }
    
    func donePickingCountry()
    {
        let phoneNoCell = self.registerTableView.cellForRow(at: phoneCellIndexPath!)//button.superview?.superview as? UITableViewCell
        let phoneNoTextField = phoneNoCell?.viewWithTag(1003) as! UITextField
        let countryPickerButton = phoneNoCell?.viewWithTag(102) as! UIButton
        phoneNoTextField.resignFirstResponder()
        phoneNoTextField.inputView = nil
        phoneNoTextField.inputAccessoryView = nil
        countryPickerButton.setTitle(chosenCountry.phoneCode, for: .normal)
        phoneNoTextField.becomeFirstResponder()

        phoneNoCell?.setNeedsDisplay()
    }
    
}
extension DriverRegisterViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch rStatus
        {
        case .step1:
            return 4
        case .step2:
            return 2
        case .step3:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch rStatus {
        case .step1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "John"
                tf.autocapitalizationType = .words
                tf.keyboardType = .asciiCapable
                tf.tag = 1000


                label.text = "First Name"
                return cell

            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "Doe"
                tf.autocapitalizationType = .words
                tf.keyboardType = .asciiCapable
                tf.tag = 1001
                
                label.text = "Last Name"
                return cell

            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "johndoe@company.com"
                tf.autocapitalizationType = .none
                tf.keyboardType = .emailAddress
                tf.tag = 1002
                
                label.text = "Email ID"
                return cell

            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath)
                if let tf = cell.viewWithTag(100) as? UITextField {
                    tf.autocapitalizationType = .none
                    tf.keyboardType = .asciiCapable
                    tf.tag = 1003
                } else {
                    let tf = cell.viewWithTag(1003) as! UITextField
                    tf.becomeFirstResponder()
                }
                let label = cell.viewWithTag(101) as! UILabel
                let countryButton = cell.viewWithTag(102) as! UIButton
                let countryCodeLabel = cell.viewWithTag(103) as! UILabel
                                
                self.phoneCellIndexPath = indexPath
                
                countryCodeLabel.text = chosenCountry.phoneCode
                countryButton.setImage(chosenCountry.flag, for: .normal)
                countryButton.addTarget(self, action: #selector(countryPickerButtonTapped), for: .touchUpInside)

                
                label.text = "Phone Number"
                return cell

            default:
                return UITableViewCell()
            }
        case .step2:
            switch indexPath.row
            {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "989454"
                label.text = "Driver License Number"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "989454"
                label.text = "Driver License Expiry Date"
                return cell
            default:
                return UITableViewCell()
            }
        case .step3:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "989454"
                label.text = "Type your User Name"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "989454"
                label.text = "Type password"
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "989454"
                label.text = "Retype Password"
                return cell

            default:
                return UITableViewCell()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
extension DriverRegisterViewController : UIPickerViewDelegate, UIPickerViewDataSource
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
        self.chosenCountry = country
        
        self.registerTableView.reloadRows(at: [self.phoneCellIndexPath!], with: .none)
        
    }
    
}
