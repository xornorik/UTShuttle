//
//  AddVehicleViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 18/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class AddVehicleViewController: UIViewController {
    
    @IBOutlet weak var addVehicleTableView:UITableView!
    @IBOutlet weak var addVehicleButton:UIButton!
    @IBOutlet weak var closeButton:UIButton!
    
    var vehicleNo = ""
    var vehicleIdentityNumber = ""
    var licensePlateNumber = ""
    var DOTNumber = ""
    var noOfSeats = 0
    var vehicleType:VehicleType?
    var vehicleTypes = [VehicleType]()
    
    let apiClient = APIClient.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func setupVC()
    {
        closeButton.addTarget(self, action: #selector(dismissAddVehicleVC), for: .touchUpInside)
        addVehicleButton.addTarget(self, action: #selector(addVehicle), for: .touchUpInside)
        getVehicleTypes()
        
    }
    
    func dismissAddVehicleVC()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getVehicleTypes()
    {
        guard let username = Defaults[.driverUsername] else {return}
        apiClient.getVehicleTypes(username: username) { (success, error, vehicleTypes) in
            
            if success
            {
                self.vehicleTypes = vehicleTypes
            }
            else
            {
                showError(title: "Alert", message: "Trouble fetching vehicle types")
            }
        }
    }
    
    func addVehicle()
    {
        
    }
}

extension AddVehicleViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.item
        {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath)
            let tf = cell.viewWithTag(100) as! UITextField
            let label = cell.viewWithTag(101) as! UILabel
            
            tf.placeholder = "V100"
            tf.keyboardType = .asciiCapable
            tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
            tf.delegate = self
            tf.tag = 1000
            
            label.text = "Vehicle Number"
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath)
            let tf = cell.viewWithTag(100) as! UITextField
            let label = cell.viewWithTag(101) as! UILabel
            
            tf.placeholder = "1HGBH41JXMN"
            tf.keyboardType = .asciiCapable
            tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
            tf.delegate = self
            tf.tag = 1001
            
            label.text = "Vehicle Identity Number"
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath)
            let tf = cell.viewWithTag(100) as! UITextField
            let label = cell.viewWithTag(101) as! UILabel
            
            tf.placeholder = "HK ML266"
            tf.keyboardType = .asciiCapable
            tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
            tf.delegate = self
            tf.tag = 1002
            
            label.text = "License Plate Number"
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath)
            let tf = cell.viewWithTag(100) as! UITextField
            let label = cell.viewWithTag(101) as! UILabel
            
            tf.placeholder = "USDOT1234"
            tf.keyboardType = .asciiCapable
            tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
            tf.delegate = self
            tf.tag = 1003
            
            label.text = "DOT Number"
            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath)
            let label = cell.viewWithTag(101) as! UILabel
            
           if let tf = cell.viewWithTag(100) as? UITextField
           {
            tf.placeholder = "Sedan"
            tf.keyboardType = .asciiCapable
            tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
            tf.delegate = self
            tf.tag = 1004
            
            
            let pickerView = UIPickerView()
            pickerView.delegate = self
            
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.tintColor = ColorPalette.UTSTeal
            toolBar.isTranslucent = true
            toolBar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissKeyboard))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            toolBar.setItems([spaceButton, doneButton], animated: false)
            
            tf.inputView = pickerView
            tf.inputAccessoryView = toolBar
            
            }
            else
           {
            let tf = cell.viewWithTag(1004) as! UITextField
            tf.placeholder = "Sedan"
            tf.keyboardType = .asciiCapable
            tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
            tf.delegate = self
            tf.tag = 1004
            
            
            let pickerView = UIPickerView()
            pickerView.delegate = self
            
            let toolBar = UIToolbar()
            toolBar.barStyle = UIBarStyle.default
            toolBar.tintColor = ColorPalette.UTSTeal
            toolBar.isTranslucent = true
            toolBar.sizeToFit()
            
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissKeyboard))
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            toolBar.setItems([spaceButton, doneButton], animated: false)
            
            tf.inputView = pickerView
            tf.inputAccessoryView = toolBar

            }

            label.text = "Vehicle Type"

            return cell

            
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath)
            let tf = cell.viewWithTag(100) as! UITextField
            let label = cell.viewWithTag(101) as! UILabel
            
            tf.placeholder = "2"
            tf.keyboardType = .numberPad
            tf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
            tf.delegate = self
            tf.tag = 1005
            
            label.text = "Number of Seats"
            return cell

        default:
            print("Exhaustive")
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension AddVehicleViewController : UITextFieldDelegate
{
    // MARK: Keyboard Notifications
    
    func dismissKeyboard()
    {
        self.view.endEditing(false)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            let padding:CGFloat = 20
            addVehicleTableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight + padding, 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            self.addVehicleTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
    
    //MARK: TextField Functions
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag != 1004
        {
            textField.tag = 100
        }
    }
    
    func textFieldDidChange(textField: UITextField)
    {
        switch textField.tag {
        case 1000:
            vehicleNo = textField.text!
        case 1001:
            vehicleIdentityNumber = textField.text!
        case 1002:
            licensePlateNumber = textField.text!
        case 1003:
            DOTNumber = textField.text!
        case 1005:
            noOfSeats = Int(textField.text!)!
        default:
            print("Exhaustive")
        }

    }
}
extension AddVehicleViewController : UIPickerViewDelegate, UIPickerViewDataSource
{
    
    func handlePicker()
    {
//        let cell = self.addVehicleTableView.cellForRow(at: IndexPath(row: 4, section: 0))
        let textField = self.view.viewWithTag(1004) as! UITextField
        textField.text = vehicleType?.name
//        self.addVehicleTableView.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .automatic)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return vehicleTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return vehicleTypes[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.vehicleType = vehicleTypes[row]
        handlePicker()
    }
}
