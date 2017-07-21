//
//  UTSPhoneTableViewCell.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 21/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftyUserDefaults

protocol UTSPhoneTableViewCellDelegate {
    func textFieldContent(cell:UTSPhoneTableViewCell, countryCode:String, phoneNumber:String)
}

class UTSPhoneTableViewCell: UITableViewCell {
    
    @IBOutlet weak var formTextField:UITextField!
    @IBOutlet weak var formLabel:UILabel!
    @IBOutlet weak var countryPickerButton:UIButton!
    @IBOutlet weak var countryCodeLabel:UILabel!
    
    var phoneNumber:String?
    var delegate:UTSPhoneTableViewCellDelegate?
    var countries = [Country]()
    var chosenCountry = Country(code: "US", name: "United States", phoneCode: "+1")
    var countryPicker = UIPickerView()


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCountryPicker()
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


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(placeholder:String, text:String, labelText:String)
    {
        formTextField.autocapitalizationType = .none
        formTextField.placeholder = placeholder
        formTextField.keyboardType = .decimalPad
        formTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        
        countryCodeLabel.text = chosenCountry.phoneCode
        Defaults[.driverCountryCode] = chosenCountry.phoneCode //to Initialize it to US
        countryPickerButton.setImage(chosenCountry.flag, for: .normal)
        countryPickerButton.addTarget(self, action: #selector(countryPickerButtonTapped), for: .touchUpInside)
    }
    
    func countryPickerButtonTapped()
    {
        
        if formTextField.isFirstResponder
        {
            formTextField.resignFirstResponder()
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
        formTextField.inputView = countryPicker
        formTextField.inputAccessoryView = toolBar
        
        formTextField.becomeFirstResponder()
    }
    
    func donePickingCountry()
    {
        
        formTextField.resignFirstResponder()
        formTextField.inputView = nil
        formTextField.inputAccessoryView = nil
        countryPickerButton.setTitle(chosenCountry.phoneCode, for: .normal)
        formTextField.becomeFirstResponder()
    }
    
    func dismissKeyboard()
    {
        self.contentView.endEditing(false)
    }
    
    func textFieldDidChange(textField: UITextField)
    {
        textField.text = textField.text!.formatPhoneNumber()
        phoneNumber = textField.text?.formatPhoneNumber()
    }

}
extension UTSPhoneTableViewCell : UIPickerViewDelegate, UIPickerViewDataSource
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
        
        countryCodeLabel.text = country.phoneCode
    }
}

extension UTSPhoneTableViewCell : UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard phoneNumber != nil else {return}
        delegate?.textFieldContent(cell: self, countryCode: chosenCountry.phoneCode!, phoneNumber: phoneNumber!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
