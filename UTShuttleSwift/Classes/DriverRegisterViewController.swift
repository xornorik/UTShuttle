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
import ImagePicker

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
    var apiClient = APIClient.shared

    var firstName = ""
    var lastname = ""
    var email = ""
    var mobile = ""
    var licenseNo = ""
    var licenseExp = ""
    var username = ""
    var password = ""
    var retypePassword = ""
    
    var countryPicker = UIPickerView()
    var countries = [Country]()
    var selectedIndexPath:IndexPath?
    var isPickingCountry = false //just for keeping the keyboard active on a special instance
    var chosenCountry = Country(code: "US", name: "United States", phoneCode: "+1")
    
    var selectedPhoto:UIImage?

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
            self.nextButton.setTitle("CONTINUE", for: .normal)
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
        
        if validateForm()
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
                mobile = textField.text!
            default:
                print("Exhaustive")
            }
        case .step2:
            switch textField.tag {
            case 1000:
                licenseNo = textField.text!
            case 1001:
                licenseExp = textField.text!
            default:
                print("Exhaustive")
            }
        case .step3:
            switch textField.tag {
            case 1000:
                username = textField.text!
            case 1001:
                password = textField.text!
            case 1002:
                retypePassword = textField.text!
            default:
                print("Exhaustive")
            }
        }
    }
    
    func storeDetails()
    {
        switch rStatus {
        case .step1:
            Defaults[.driverFirstName] = firstName
            Defaults[.driverLastName] = lastname
            Defaults[.driverEmail] = email
            Defaults[.driverMobile] =  mobile
            Defaults[.driverCountryCode] = chosenCountry.phoneCode
        case .step2:
            Defaults[.driverLicense] = licenseNo
            Defaults[.driverLicenseExp] = licenseExp
        case .step3:
            Defaults[.driverUsername] = username
            Defaults[.driverPassword] = password
        }
    }
    
    func registerDriver()
    {
        let payload:[String:Any] = [
                "RowIndex": 0,
                "UniqueId": "",
                "DeviceId": Defaults[.deviceId]!,
                "UserName": Defaults[.driverUsername]!,
                "FirstName": Defaults[.driverFirstName]!,
                "LastName": Defaults[.driverLastName]!,
                "Email": Defaults[.driverEmail]!,
                "Mobile": format(phoneNumber: Defaults[.driverMobile]!)!,
                "Password": Defaults[.driverPassword]!,
                "DateofBirth": "",
                "Address_1": "",
                "Address_2": "",
                "ZipCode": "",
                "CityId": 0,
                "StateId": 0,
                "CityName": "",
                "StateName": "",
                "Phone": format(phoneNumber: Defaults[.driverMobile]!)!,
                "CountryCode": Defaults[.driverCountryCode]!,
                "DriverLicenceNumber": Defaults[.driverLicense]!,
                "DriverLicenceExpiryDate": Defaults[.driverLicenseExp]!,
                "DotPermitNumber": "",
                "DotPermitExpiryDate": "",
                "ImageSize": Defaults[.driverProfilePhotoSize]!,
                "Extension": ".jpg"
            ]
        
    }
    
    func format(phoneNumber sourcePhoneNumber: String) -> String? {
        
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let length = numbersOnly.characters.count
        let hasLeadingOne = numbersOnly.hasPrefix("1")
        
        // Check for supported phone number length
        guard length == 7 || length == 10 || (length == 11 && hasLeadingOne) else {
            return nil
        }
        
        let hasAreaCode = (length >= 10)
        var sourceIndex = 0
        
        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            leadingOne = "1 "
            sourceIndex += 1
        }
        
        // Area code
        var areaCode = ""
        if hasAreaCode {
            let areaCodeLength = 3
            guard let areaCodeSubstring = numbersOnly.characters.substring(start: sourceIndex, offsetBy: areaCodeLength) else {
                return nil
            }
            areaCode = String(format: "(%@) ", areaCodeSubstring)
            sourceIndex += areaCodeLength
        }
        
        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return nil
        }
        sourceIndex += prefixLength
        
        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.characters.substring(start: sourceIndex, offsetBy: suffixLength) else {
            return nil
        }
        
        return leadingOne + areaCode + prefix + "-" + suffix
    }
    
    func validateForm() -> Bool
    {
        switch rStatus {
        case .step1:
            let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            
            guard firstName != "" else {showError(title: "Alert", message: "Please enter the first name."); return false}
            guard lastname != "" else {showError(title: "Alert", message: "Please enter the last name."); return false}
            guard email != "", emailTest.evaluate(with: email) else {showError(title: "Alert", message: "Please enter a valid email Id."); return false}
            guard mobile != "", mobile.characters.count < 10 else {showError(title: "Alert", message: "Please enter a valid phone number."); return false}
        case .step2:
            guard licenseNo != "" else {showError(title: "Alert", message: "Please enter a valid driving license number."); return false}
            guard licenseExp != "" else {showError(title: "Alert", message: "Please enter the expiry date of the driving license."); return false}
        case .step3:
            guard username != "" else {showError(title: "Alert", message: "Please enter a username."); return false}
            guard password != "", password.characters.count < 4 else {showError(title: "Alert", message: "Please enter a password with atleast 4 characters."); return false}
            guard password == retypePassword else {showError(title: "Alert", message: "Passwords do not match. Please try again."); return false}
        }
        return true
    }
    
    func countryPickerButtonTapped()
    {
        guard rStatus == .step1 else{return}
        isPickingCountry = true
        let phoneNoCell = self.registerTableView.cellForRow(at: selectedIndexPath!)//button.superview?.superview as? UITableViewCell
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
        isPickingCountry = false

        let phoneNoCell = self.registerTableView.cellForRow(at: selectedIndexPath!)//button.superview?.superview as? UITableViewCell
        let phoneNoTextField = phoneNoCell?.viewWithTag(1003) as! UITextField
        let countryPickerButton = phoneNoCell?.viewWithTag(102) as! UIButton
        phoneNoTextField.resignFirstResponder()
        phoneNoTextField.inputView = nil
        phoneNoTextField.inputAccessoryView = nil
        countryPickerButton.setTitle(chosenCountry.phoneCode, for: .normal)
        phoneNoTextField.becomeFirstResponder()

        phoneNoCell?.setNeedsDisplay()
    }
    
    func handleDatePicker(sender:UIDatePicker)
    {
        let dateCell = self.registerTableView.cellForRow(at: self.selectedIndexPath!)
        let dateTf = dateCell?.viewWithTag(1001) as! UITextField
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        dateTf.text = dateFormatter.string(from: sender.date)
        licenseExp = dateTf.text!
    }
    
    func dismissKeyboard()
    {
        self.view.endEditing(false)
    }
    
    func pickPhotoForUpload()
    {
        var config = Configuration()
        config.doneButtonTitle = "Done"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        config.allowMultiplePhotoSelection = false
        
        let imagePicker = ImagePickerController()
        imagePicker.configuration = config
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
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
            return 3
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
                tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
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
                tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
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
                tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
                tf.tag = 1002
                
                label.text = "Email ID"
                return cell

            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath)
                if let tf = cell.viewWithTag(100) as? UITextField {
                    tf.autocapitalizationType = .none
                    tf.placeholder = "(123) 456-789"
                    tf.keyboardType = .numberPad
                    tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
                    tf.tag = 1003
                    
                    if isPickingCountry {tf.becomeFirstResponder()}
                } else {
                    let tf = cell.viewWithTag(1003) as! UITextField
                    tf.text = mobile
                    tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
                    tf.becomeFirstResponder()
                }
                let label = cell.viewWithTag(101) as! UILabel
                let countryButton = cell.viewWithTag(102) as! UIButton
                let countryCodeLabel = cell.viewWithTag(103) as! UILabel
                                
                self.selectedIndexPath = indexPath
                
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
                let profilePhoto = cell.viewWithTag(101) as! UIImageView
                let uploadButton = cell.viewWithTag(100) as! UIButton
                
                if let img = Defaults[.driverProfilePhoto]
                {
                    let decodedData = Data(base64Encoded: img, options: .ignoreUnknownCharacters)!
                    profilePhoto.image = UIImage(data: decodedData)
                }
                else
                {
                    profilePhoto.image = UIImage(named: "imgUserProfilePlaceholder")
                }
                
                //ui code
                profilePhoto.cornerRadius = profilePhoto.frame.size.width/2
                profilePhoto.clipsToBounds = true
                profilePhoto.layer.borderColor = ColorPalette.UTSTealLight.cgColor
                profilePhoto.layer.borderWidth = 1
                
                uploadButton.addTarget(self, action: #selector(pickPhotoForUpload), for: .touchUpInside)
                
                cell.setNeedsLayout()
                cell.setNeedsDisplay()
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "9894541234325425"
                tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
                tf.tag = 1000
                
                label.text = "Driver License Number"
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "12-05-2019"
                tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
                
                //configure datepicker
                let minDate = (Calendar.current as NSCalendar).date(byAdding: .month, value: 6, to: Date(), options: []) //[!] Check with mgmt
                let pickerView = UIDatePicker()
                pickerView.datePickerMode = .date
                pickerView.addTarget(self, action: #selector(handleDatePicker), for: UIControlEvents.valueChanged)
                pickerView.minimumDate = minDate
                
                let toolBar = UIToolbar()
                toolBar.barStyle = UIBarStyle.default
                toolBar.tintColor = ColorPalette.UTSTeal
                toolBar.isTranslucent = true
                toolBar.sizeToFit()
                
                let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissKeyboard))
                let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
                toolBar.setItems([spaceButton, doneButton], animated: false)

                let df = DateFormatter()
                df.dateFormat = "dd-MM-yyyy"
                licenseExp = df.string(from: minDate!)
                
//                tf.text = df.string(from: pickerView.date)
                tf.tag = 1001
                tf.inputView = pickerView
                tf.inputAccessoryView = toolBar

                self.selectedIndexPath = indexPath
                
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
                
                tf.placeholder = "John Doe"
                tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
                tf.tag = 1000
                
                label.text = "Type your User Name"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "******"
                tf.isSecureTextEntry = true
                tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
                tf.tag = 1001
                
                label.text = "Type password"
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "******"
                tf.isSecureTextEntry = true
                tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
                tf.tag = 1002
                
                label.text = "Retype Password"
                return cell

            default:
                return UITableViewCell()
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if rStatus == .step2 && indexPath.row == 0
        {
            return 150
        }
        else
        {
            return 65
        }
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
        
        self.registerTableView.reloadRows(at: [self.selectedIndexPath!], with: .none)
        
    }
}
extension DriverRegisterViewController : ImagePickerDelegate
{
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        //do Nothing
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        self.selectedPhoto = images.first
        guard let photo = images.first else {return}
        let compressedImage = UIImageJPEGRepresentation(photo, 0.5)!
        let compressedImageData = NSData(data: compressedImage)
        
        let imgSize:Int = compressedImageData.length
        Defaults[.driverProfilePhotoSize] = Double(imgSize) / 1024
        if Double(imgSize)/(1024*1024) > 2
        {
            imagePicker.dismiss(animated: true, completion: { 
                showError(title: "Alert", message: "File size greater than 2MB")
            })
        }
        else
        {
            Defaults[.driverProfilePhoto] = compressedImage.base64EncodedString(options: .lineLength64Characters)
            self.registerTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}
