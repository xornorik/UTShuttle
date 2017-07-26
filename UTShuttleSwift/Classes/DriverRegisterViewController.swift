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
    var countryCode = ""
    var mobile = ""
    var licenseNo = ""
    var licenseExp = ""
    var username = ""
    var password = ""
    var retypePassword = ""
    
    var selectedIndexPath:IndexPath? //used for terms and condition toggling
    var isAgreeToTermsAndConditions = false
    
    var selectedPhoto:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Setup Functions
    
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
    
    
    //MARK: UI Functions

    
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
            case .step3:
                storeDetails()
                registerDriver()
            }

        }
    }
    
    func toggleAgreeToTermsAndConditions()
    {
        guard let indexPath = self.selectedIndexPath else {return}
        if self.isAgreeToTermsAndConditions
        {
            self.isAgreeToTermsAndConditions = false
        }
        else
        {
            self.isAgreeToTermsAndConditions = true
        }
        self.registerTableView.reloadRows(at: [indexPath], with: .none)
        
    }
    
    //MARK: I/O Functions
    
    func storeDetails()
    {
        switch rStatus {
        case .step1:
            Defaults[.driverFirstName] = firstName
            Defaults[.driverLastName] = lastname
            Defaults[.driverEmail] = email
            Defaults[.driverMobile] =  mobile
            Defaults[.driverCountryCode] = countryCode
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
                "DeviceId": Defaults[.deviceId] ?? 0,
                "UserName": Defaults[.driverUsername] ?? "",
                "FirstName": Defaults[.driverFirstName] ?? "",
                "LastName": Defaults[.driverLastName] ?? "",
                "Email": Defaults[.driverEmail] ?? "",
                "Mobile": Defaults[.driverMobile] ?? "" ,
                "Password": Defaults[.driverPassword] ?? "",
                "DateofBirth": "",
                "Address_1": "",
                "Address_2": "",
                "ZipCode": "",
                "CityId": 0,
                "StateId": 0,
                "CityName": "",
                "StateName": "",
                "Phone": Defaults[.driverMobile] ?? "",
                "CountryCode": Defaults[.driverCountryCode] ?? "+1",
                "DriverLicenceNumber": Defaults[.driverLicense] ?? "",
                "DriverLicenceExpiryDate": Defaults[.driverLicenseExp] ?? "" ,
                "DotPermitNumber": "",
                "DotPermitExpiryDate": "",
                "ImageUser": Defaults[.driverProfilePhoto] ?? "",
                "ImageSize": Defaults[.driverProfilePhotoSize] ?? 0,
                "Extension": ".jpeg"
            ]
        apiClient.driverRegistration(payload: payload) { (success, error) in
            
            if success
            {
                Defaults[.driverProfilePhoto] = nil //clear base64 Image
                NavigationUtils.goToDriverLogin()
            }
            else
            {
                showError(title: "Alert", message: error)
            }
        }
    }
    

    
    //MARK: Validation Functions
    
    func validateForm() -> Bool
    {
        switch rStatus {
        case .step1:
            let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            
            guard firstName != "" else {showError(title: "Alert", message: "Please enter the first name."); return false}
            guard lastname != "" else {showError(title: "Alert", message: "Please enter the last name."); return false}
            guard email != "", emailTest.evaluate(with: email) else {showError(title: "Alert", message: "Please enter a valid email Id."); return false}
            guard mobile != "", mobile.characters.count <= 14 else {showError(title: "Alert", message: "Please enter a valid phone number."); return false}
        case .step2:
            guard licenseNo != "" else {showError(title: "Alert", message: "Please enter a valid driving license number."); return false}
            guard licenseExp != "" else {showError(title: "Alert", message: "Please enter the expiry date of the driving license."); return false}
        case .step3:
            guard username != "" else {showError(title: "Alert", message: "Please enter a username."); return false}
            guard password != "", password.characters.count > 4 else {showError(title: "Alert", message: "Please enter a password with atleast 4 characters."); return false}
            guard password == retypePassword else {showError(title: "Alert", message: "Passwords do not match. Please try again."); return false}
            if !isAgreeToTermsAndConditions {showError(title: "Alert", message: "Please agree to the terms and conditions before proceeding."); return false}
        }
        return true
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
    
    // MARK: Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            let padding:CGFloat = 20
            registerTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight + padding, 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            self.registerTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
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
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath) as! UTSFormTableViewCell
                cell.setup(type: .text, placeholder: "John", text: "", labelText: "First Name")
                cell.delegate = self
                return cell

            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath) as! UTSFormTableViewCell
                cell.setup(type: .text, placeholder: "Doe", text: "", labelText: "Last Name")
                cell.delegate = self
                return cell

            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath) as! UTSFormTableViewCell
                cell.setup(type: .email, placeholder: "johndoe@company.com", text: "", labelText: "Email ID")
                cell.delegate = self
                return cell

            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath) as! UTSPhoneTableViewCell
                cell.setup(placeholder: "(123) 456-7890", text: "", labelText: "Mobile Number", countryCode: "+1")
                cell.delegate = self
                return cell

            default:
                return UITableViewCell()
            }
        case .step2:
            switch indexPath.row
            {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath)
                let profilePhoto = cell.viewWithTag(101) as! RoundedImageView
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
                profilePhoto.cornerRadius = profilePhoto.bounds.size.width/2
                profilePhoto.clipsToBounds = true
                profilePhoto.layer.borderColor = ColorPalette.UTSTealLight.cgColor
                profilePhoto.layer.borderWidth = 1
                
                uploadButton.addTarget(self, action: #selector(pickPhotoForUpload), for: .touchUpInside)
                
                cell.setNeedsLayout()
                cell.setNeedsDisplay()
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath) as! UTSFormTableViewCell
                cell.setup(type: .text, placeholder: "9894541234325425", text: "", labelText: "Driver License Number")
                cell.delegate = self
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath) as! UTSFormTableViewCell
                cell.setup(type: .datePicker, placeholder: DateFormatter().string(from: Date()), text: "", labelText: "Driver License Number")
                cell.delegate = self
                return cell
            default:
                return UITableViewCell()
            }
        case .step3:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath) as! UTSFormTableViewCell
                cell.setup(type: .text, placeholder: "John Doe", text: "", labelText: "Type your User Name")
                cell.delegate = self
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath) as! UTSFormTableViewCell
                cell.setup(type: .password, placeholder: "******", text: "", labelText: "Type password")
                cell.delegate = self
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath) as! UTSFormTableViewCell
                cell.setup(type: .password, placeholder: "******", text: "", labelText: "Retype password")
                cell.delegate = self
                return cell
            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "termsCell", for: indexPath)
                let checkboxImageView = cell.viewWithTag(100) as! UIImageView
                let agreeButton = cell.viewWithTag(101) as! UIButton
                
                if isAgreeToTermsAndConditions{
                    checkboxImageView.image = UIImage(named: "buttonCheckboxTrue")
                }else{
                    checkboxImageView.image = UIImage(named: "buttonCheckboxFalse")
                }
                
                selectedIndexPath = indexPath
                agreeButton.addTarget(self, action: #selector(toggleAgreeToTermsAndConditions), for: .touchUpInside)
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
extension DriverRegisterViewController : ImagePickerDelegate
{
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        //do Nothing
    }
    
    func compressImage(photo:UIImage) -> UIImage
    {
        let compressedImage = UIImageJPEGRepresentation(photo, 0.5)!
        return UIImage(data: compressedImage)!
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage])
    {
////        self.selectedPhoto = images.first
//        guard let photo = images.first else {return}
//        let compressedImage = UIImageJPEGRepresentation(photo, 0.5)!
//        let compressedImageData = NSData(data: compressedImage)
//        
//        let imgSize:Int = compressedImageData.length
//        Defaults[.driverProfilePhotoSize] = Double(imgSize) /// 1024
//        if Double(imgSize)/(1024*1024) > 2
//        {
//            imagePicker.dismiss(animated: true, completion: { 
//                showError(title: "Alert", message: "File size greater than 2MB")
//            })
//        }
//        else
//        {
//            Defaults[.driverProfilePhoto] = compressedImage.base64EncodedString(options: .lineLength64Characters)
//            self.registerTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
//            imagePicker.dismiss(animated: true, completion: nil)
//        }
        
        guard let photo = images.first else {return}
        
        var photoImage = photo //for compressing (photo is constant)
        var img = UIImageJPEGRepresentation(photoImage, 1.0)!
        var imgData = NSData(data: img)
        var imgSize:Int = imgData.length
        
        repeat
        {
            //compress
            photoImage = compressImage(photo: photoImage)
            img = UIImageJPEGRepresentation(photoImage, 1.0)!
            imgData = NSData(data: img)
            imgSize = imgData.length
        }
        while Double(imgSize)/(1024*1024) >= 2 //(in MB)
        
        
        Defaults[.driverProfilePhotoSize] = Double(imgSize)
        Defaults[.driverProfilePhoto] = imgData.base64EncodedString(options: .lineLength64Characters)
        self.registerTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
extension DriverRegisterViewController : UTSPhoneTableViewCellDelegate
{
    func textFieldContent(cell: UTSPhoneTableViewCell, countryCode:String, phoneNumber: String) {
        
        guard rStatus == .step1 else {return}
        let currentIndexPath = self.registerTableView.indexPath(for: cell)
        switch (currentIndexPath?.row)! {
        case 3: self.countryCode = countryCode; mobile = phoneNumber;
        default:
            break // handled below
        }
    }
}
extension DriverRegisterViewController : UTSFormTableViewCellDelegate
{
    func textFieldContent(cell: UTSFormTableViewCell, content: String, secondaryContent:String) {
         let currentIndexPath = self.registerTableView.indexPath(for: cell)
        switch rStatus {
        case .step1:
            switch (currentIndexPath?.row)! {
            case 0: firstName = content
            case 1: lastname = content
            case 2: email = content
            case 3: print("Phone number")
            default: break
            }
        case .step2:
            switch (currentIndexPath?.row)! {
            case 0: print("Image Cell")
            case 1: licenseNo = content
            case 2: licenseExp = content
            default: break
            }
        case .step3:
            switch (currentIndexPath?.row)! {
            case 0: username = content
            case 1: password = content
            case 2: retypePassword = content
            default: break
            }
        }
    }
}
