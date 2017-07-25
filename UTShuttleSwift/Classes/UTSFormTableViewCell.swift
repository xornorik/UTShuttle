//
//  UTSFormTableViewCell.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 21/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

enum FormCellType{
    case text
    case password
    case email
    case datePicker
    case picker
    case  double
}

protocol UTSFormTableViewCellDelegate {
    func textFieldContent(cell:UTSFormTableViewCell, content:String, secondaryContent:String)
}

class UTSFormTableViewCell: UITableViewCell {
    
    @IBOutlet weak var formTextField:UITextField!
    @IBOutlet weak var formLabel:UILabel!
    
    @IBOutlet weak var secondaryFormTextField:UITextField!
    @IBOutlet weak var secondaryFormLabel:UILabel!
    
    var cellType = FormCellType.text
    var tfContent:String?
    var secondaryTfContent:String?
    var delegate:UTSFormTableViewCellDelegate?
    var pickerOptions:[VehicleType]?
    var pickerContent:VehicleType?
    var apiClient = APIClient.shared

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        formTextField.delegate = self
        if secondaryFormTextField != nil
        {
            secondaryFormTextField.delegate = self
            secondaryFormTextField.tag = 0
        }
    }
    
    func setup(type:FormCellType, placeholder:String, text:String, labelText:String,secondaryPlaceholder:String? = nil, secondaryText:String? = nil, secondaryLabelText:String? = nil) //secondary stuff for profile View reusing same cell
    {
        switch type {
        case .text:
            formTextField.placeholder = placeholder
            formTextField.text = text
            formTextField.autocapitalizationType = .words
            formTextField.autocorrectionType = .no
            formTextField.keyboardType = .asciiCapable
            formLabel.text = labelText
            formTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        case .email:
            formTextField.placeholder = placeholder
            formTextField.text = text
            formTextField.autocapitalizationType = .none
            formTextField.autocorrectionType = .no
            formTextField.keyboardType = .emailAddress
            formTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)

            formLabel.text = labelText
        case .password:
            formTextField.placeholder = placeholder
            formTextField.text = text
            formTextField.autocapitalizationType = .none
            formTextField.autocorrectionType = .no
            formTextField.keyboardType = .asciiCapable
            formTextField.isSecureTextEntry = true
            formTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)

            formLabel.text = labelText
        case .datePicker:
            formTextField.placeholder = placeholder
            formTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
            formTextField.text = text
            
            //configure datepicker
//            let minDate = (Calendar.current as NSCalendar).date(byAdding: .month, value: 6, to: Date(), options: []) //[!] Check with mgmt
            let pickerView = UIDatePicker()
            pickerView.datePickerMode = .date
            pickerView.addTarget(self, action: #selector(handleDatePicker), for: UIControlEvents.valueChanged)
            pickerView.minimumDate = Date()//minDate
            
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
            
            formTextField.inputView = pickerView
            formTextField.inputAccessoryView = toolBar
            
            formLabel.text = labelText

        case .picker:
            formTextField.placeholder = placeholder
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
            
            formTextField.inputView = pickerView
            formTextField.inputAccessoryView = toolBar
        case .double:
            formTextField.placeholder = placeholder
            formTextField.text = text
            formTextField.autocapitalizationType = .words
            formTextField.autocorrectionType = .no
            formTextField.keyboardType = .asciiCapable
            formLabel.text = labelText
            formTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
            
            secondaryFormTextField.placeholder = secondaryPlaceholder
            secondaryFormTextField.text = secondaryText
            secondaryFormTextField.autocapitalizationType = .words
            secondaryFormTextField.autocorrectionType = .no
            secondaryFormTextField.keyboardType = .asciiCapable
            secondaryFormLabel.text = secondaryLabelText
            secondaryFormTextField.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)

        }
    }
    
    func textFieldDidChange(textField: UITextField)
    {
        if textField == formTextField
        {
            tfContent = textField.text
        }
        else
        {
            secondaryTfContent = textField.text
        }
        
    }
    
    func handleDatePicker(sender:UIDatePicker)
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        formTextField.text = dateFormatter.string(from: sender.date)
        tfContent = formTextField.text!

    }
    
    func dismissKeyboard()
    {
        self.contentView.endEditing(false)
    }
}
extension UTSFormTableViewCell : UIPickerViewDelegate, UIPickerViewDataSource
{
    func handlePicker()
    {
        formTextField.text = pickerContent?.name
        delegate?.textFieldContent(cell: self, content: (pickerContent?.name)!, secondaryContent: "")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerOptions!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerContent = pickerOptions?[row]
        handlePicker()
    }
}
extension UTSFormTableViewCell : UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard tfContent != nil else {return}
        delegate?.textFieldContent(cell: self, content: tfContent!, secondaryContent: secondaryTfContent ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
