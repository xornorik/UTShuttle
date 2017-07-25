//
//  ProfileViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 25/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import ImagePicker
import Kingfisher


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileTableView:UITableView!
    @IBOutlet weak var saveButton:UIButton!
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var mobile = ""
    var licenseNo = ""
    var licenseExp = ""
    var countryCode = ""
    var profilePhotoUrl = ""
    var profilePhotoString:String?
    var profilePhotoSize:Double?
    
    var hasChangedPhoto = false
    
    var apiClient = APIClient.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupVC()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupVC()
    {
        self.title = "My Profile"
        retreiveDataFromStorage()
        
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    func retreiveDataFromStorage()
    {
        guard let _firstName = Defaults[.driverFirstName] else {displayError();return}
        guard let _lastName = Defaults[.driverLastName] else {displayError();return}
        guard let _email = Defaults[.driverEmail] else {displayError();return}
        guard let _mobile = Defaults[.driverMobile] else {displayError();return}
        guard let _countryCode = Defaults[.driverCountryCode] else {displayError();return}
        guard let _licenseNo = Defaults[.driverLicense] else {displayError();return}
        guard let _licenseExp = Defaults[.driverLicenseExp] else {displayError();return}
        guard let _profilePhotoUrl = Defaults[.driverProfilePhoto] else {displayError();return}
        
        
        firstName = _firstName
        lastName = _lastName
        email = _email
        mobile = _mobile
        countryCode = _countryCode
        licenseNo = _licenseNo
        licenseExp = _licenseExp
        profilePhotoUrl = _profilePhotoUrl
        
        self.profileTableView.reloadData() // just in case
    }
    
    func displayError()
    {
        showError(title: "Alert", message: "Fatal error: Please log out and log back in.") {
            NavigationUtils.popViewController()
        }
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
    
    func validateForm() -> Bool
    {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        guard firstName != "" else {showError(title: "Alert", message: "Please enter the first name."); return false}
        guard lastName != "" else {showError(title: "Alert", message: "Please enter the last name."); return false}
        guard email != "", emailTest.evaluate(with: email) else {showError(title: "Alert", message: "Please enter a valid email Id."); return false}
        guard mobile != "", mobile.characters.count < 15 else {showError(title: "Alert", message: "Please enter a valid phone number."); return false}
        guard licenseNo != "" else {showError(title: "Alert", message: "Please enter a valid driving license number."); return false}
        guard licenseExp != "" else {showError(title: "Alert", message: "Please enter the expiry date of the driving license."); return false}
        return true
    }
    
    func storeDetails()
    {
        Defaults[.driverFirstName] = firstName
        Defaults[.driverLastName] = lastName
        Defaults[.driverEmail] = email
        Defaults[.driverMobile] =  mobile
        Defaults[.driverCountryCode] = countryCode
        Defaults[.driverLicense] = licenseNo
        Defaults[.driverLicenseExp] = licenseExp
        
    }
    
    func saveButtonTapped()
    {
        
        if validateForm()
        {
            guard let deviceId = Defaults[.deviceId] else {return}
            guard let username = Defaults[.driverUsername] else {return}
            guard let password = Defaults[.driverPassword] else {return}
            guard let imgUser = profilePhotoString else {return}
            guard let imgSize = profilePhotoSize else {return}
            guard let rowIndex = Defaults[.driverRowIndex] else {return}
            
            let payload:[String:Any] = [
                "RowIndex": rowIndex,
                "UniqueId": "",
                "DeviceId": deviceId,
                "UserName": username,
                "FirstName": firstName,
                "LastName": lastName,
                "Email": email,
                "Mobile": mobile ,
                "Password": password,
                "DateofBirth": "",
                "Address_1": "",
                "Address_2": "",
                "ZipCode": "",
                "CityId": 0,
                "StateId": 0,
                "CityName": "",
                "StateName": "",
                "Phone": mobile,
                "CountryCode": countryCode,
                "DriverLicenceNumber": licenseNo,
                "DriverLicenceExpiryDate": licenseExp ,
                "DotPermitNumber": "",
                "DotPermitExpiryDate": "",
                "ImageUser": imgUser,
                "ImageSize": imgSize,
                "Extension": ".jpeg"
            ]
            apiClient.driverRegistration(payload: payload) { (success, error) in
                
                if success
                {
                    if self.hasChangedPhoto
                    {
                        //notify profile manager, so URL can be fetched on dashboard
                    }
                    self.storeDetails()
                    ProfileManager.shared.isChangedProfile = true
                    NavigationUtils.popViewController()
                }
                else
                {
                    showError(title: "Alert", message: error)
                }
            }
            
        }
    }
    
    // MARK: Keyboard Notifications
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            let padding:CGFloat = 20
            profileTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight + padding, 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            self.profileTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
    
}
extension ProfileViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileImageCell", for: indexPath)
            let profilePhoto = cell.viewWithTag(101) as! RoundedImageView
            let uploadButton = cell.viewWithTag(100) as! UIButton
            
            if hasChangedPhoto
            {
                guard let img = Defaults[.driverProfilePhoto] else {return cell}
                let decodedData = Data(base64Encoded: img, options: .ignoreUnknownCharacters)!
                profilePhoto.image = UIImage(data: decodedData)
            }
            else
            {
                let url = URL(string: profilePhotoUrl)
                profilePhoto.kf.setImage(with: url, placeholder: UIImage(named: "imgUserProfilePlaceholder"), options: nil, progressBlock: nil, completionHandler: { (image, _, _, _) in
                    guard image != nil else {profilePhoto.image = UIImage(named: "imgUserProfilePlaceholder");return}
                    profilePhoto.image = image
                })
            }
            let photoData = UIImageJPEGRepresentation(profilePhoto.image!, 1)
            profilePhotoString = photoData?.base64EncodedString(options: .lineLength64Characters)
            profilePhotoSize = Double(NSData(data: photoData!).length)
            
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileDoubleCell", for: indexPath) as! UTSFormTableViewCell
            cell.setup(type: .double, placeholder: "John", text: firstName, labelText: "First Name", secondaryPlaceholder: "Doe", secondaryText: lastName, secondaryLabelText: "Last Name")
            cell.delegate = self
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! UTSFormTableViewCell
            cell.setup(type: .email, placeholder: "johndoe@company.com", text: email, labelText: "Email ID")
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profilePhoneCell", for: indexPath) as! UTSPhoneTableViewCell
            cell.setup(placeholder: "(123) 456-7890", text: mobile, labelText: "Mobile Number", countryCode: countryCode)
            cell.delegate = self
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! UTSFormTableViewCell
            cell.setup(type: .text, placeholder: "123456789", text: licenseNo, labelText: "Driver License Number")
            cell.delegate = self
            return cell
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! UTSFormTableViewCell
            cell.setup(type: .datePicker, placeholder: "12-05-2019", text: licenseExp, labelText: "Driver License Expiry Date")
            cell.delegate = self
            return cell
        default:
            return UITableViewCell()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0
        {
            return 100
        }
        else
        {
            return 65
        }
    }
    
}
extension ProfileViewController : UTSPhoneTableViewCellDelegate
{
    func textFieldContent(cell: UTSPhoneTableViewCell, countryCode:String, phoneNumber: String) {
        
        let currentIndexPath = self.profileTableView.indexPath(for: cell)
        switch (currentIndexPath?.row)! {
        case 3: self.countryCode = countryCode; mobile = phoneNumber
        default:
            break // handled below
        }
    }
}
extension ProfileViewController : UTSFormTableViewCellDelegate
{
    func textFieldContent(cell: UTSFormTableViewCell, content: String, secondaryContent:String) {
        let currentIndexPath = self.profileTableView.indexPath(for: cell)
        switch (currentIndexPath?.row)! {
        case 1:
            firstName = content
            lastName = secondaryContent
        case 2: email = content
        case 3: break //phone
        case 4: licenseNo = content
        case 5: licenseExp = content
        default: break
        }
    }
}
extension ProfileViewController : ImagePickerDelegate
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
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
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
        print(Defaults[.driverProfilePhoto] ?? "")
        hasChangedPhoto = true
        self.profileTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

