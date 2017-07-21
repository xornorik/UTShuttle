//
//  UTSFormTableViewCell.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 21/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

enum FormCellType{
    case text
    case password
    case email
    case datePicker
    case picker
}

protocol UTSFormTableViewCellDelegate {
    func textFieldContent(cell:UTSFormTableViewCell, content:String, secondaryContent:String)
}

class UTSFormTableViewCell: UITableViewCell {
    
    @IBOutlet weak var formTextField:UITextField!
    @IBOutlet weak var formLabel:UILabel!
    
    var cellType = FormCellType.text
    var tfContent:String?
    var delegate:UTSFormTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        formTextField.delegate = self
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
            break //for now
        }
    }
    
    func textFieldDidChange(textField: UITextField)
    {
        tfContent = textField.text
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
extension UTSFormTableViewCell : UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard tfContent != nil else {return}
        delegate?.textFieldContent(cell: self, content: tfContent!, secondaryContent: "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}
