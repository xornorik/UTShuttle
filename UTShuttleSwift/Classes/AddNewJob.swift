//
//  AddNewJob.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 19/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class AddNewJob: UIView {

    @IBOutlet weak var selectRouteTF:UITextField!
    @IBOutlet weak var timeTF:UITextField!
    @IBOutlet weak var isRecurringButton:UIButton!
    
    @IBOutlet weak var isMondayButton:UIButton!
    @IBOutlet weak var isTuesdayButton:UIButton!
    @IBOutlet weak var isWednesdayButton:UIButton!
    @IBOutlet weak var isThursdayButton:UIButton!
    @IBOutlet weak var isFridayButton:UIButton!
    @IBOutlet weak var isSaturdayButton:UIButton!
    @IBOutlet weak var isSundayButton:UIButton!
    
    @IBOutlet weak var saveButton:UIButton!
    @IBOutlet weak var cancelButton:UIButton!
    
    var overlayView:UIView?
    var dialogView:UIView?
    var pickerView:UIPickerView?
    var saveButtonCallback: (()->())?
    
    var routes:[Route]?
    let apiClient = APIClient.shared
    
    var isRecurring = false
    var isMonday = false
    var isTuesday = false
    var isWednesday = false
    var isThrusday = false
    var isFriday = false
    var isSaturday = false
    var isSunday = false
    var selectedRouteId:Int?
    var time = ""
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
        setupView()
    }
    
    required init?(routes: [Route]) {
        
        super.init(frame: UIApplication.shared.keyWindow!.frame)
        self.routes = routes
        
        loadView()
        setupView()
    }
    
    func loadView() {
        dialogView = Bundle.main.loadNibNamed("AddNewJob", owner: self, options: nil)![0] as? UIView
        self.frame = UIApplication.shared.keyWindow!.frame
        dialogView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width - 30, height: (self.frame.size.width - 30)*(5/6))//CGRect(0, 0, self.frame.size.width, self.frame.size.height)
        dialogView?.center = self.center
        dialogView?.cornerRadius = 20
        self.addSubview(dialogView!)
    }
    
    func setupView()
    {
        self.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        
        self.selectRouteTF.delegate = self
        
        self.isRecurringButton.addTarget(self, action: #selector(weekButtonToggle(sender:)), for: .touchUpInside)
        self.isMondayButton.addTarget(self, action: #selector(weekButtonToggle(sender:)), for: .touchUpInside)
        self.isTuesdayButton.addTarget(self, action: #selector(weekButtonToggle(sender:)), for: .touchUpInside)
        self.isWednesdayButton.addTarget(self, action: #selector(weekButtonToggle(sender:)), for: .touchUpInside)
        self.isThursdayButton.addTarget(self, action: #selector(weekButtonToggle(sender:)), for: .touchUpInside)
        self.isFridayButton.addTarget(self, action: #selector(weekButtonToggle(sender:)), for: .touchUpInside)
        self.isSaturdayButton.addTarget(self, action: #selector(weekButtonToggle(sender:)), for: .touchUpInside)
        self.isSundayButton.addTarget(self, action: #selector(weekButtonToggle(sender:)), for: .touchUpInside)
        
        
        //setting picker View
        let pickerView = UIPickerView()
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.tintColor = ColorPalette.UTSTeal
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(dismissPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        
        self.selectRouteTF.inputView = pickerView
        self.selectRouteTF.inputAccessoryView = toolBar
        pickerView.delegate = self
        
        //setting time picker
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(handleDatePicker), for: UIControlEvents.valueChanged)
        timeTF.inputView = timePicker
        timeTF.inputAccessoryView = toolBar

    }
    
    func weekButtonToggle(sender:UIButton)
    {
        switch sender.tag {
        case 101:
            if isMonday{
                isMonday = false
                isMondayButton.setImage(UIImage(named: "buttonCheckboxNewJobFalse"), for: .normal)
            }
            else
            {
                isMonday = true
                isMondayButton.setImage(UIImage(named: "buttonCheckboxNewJobTrue"), for: .normal)
            }
        case 102:
            if isTuesday{
                isTuesday = false
                isTuesdayButton.setImage(UIImage(named: "buttonCheckboxNewJobFalse"), for: .normal)
            }
            else
            {
                isTuesday = true
                isTuesdayButton.setImage(UIImage(named: "buttonCheckboxNewJobTrue"), for: .normal)
            }

        case 103:
            if isWednesday{
                isWednesday = false
                isWednesdayButton.setImage(UIImage(named: "buttonCheckboxNewJobFalse"), for: .normal)
            }
            else
            {
                isWednesday = true
                isWednesdayButton.setImage(UIImage(named: "buttonCheckboxNewJobTrue"), for: .normal)
            }

        case 104:
            if isThrusday{
                isThrusday = false
                isThursdayButton.setImage(UIImage(named: "buttonCheckboxNewJobFalse"), for: .normal)
            }
            else
            {
                isThrusday = true
                isThursdayButton.setImage(UIImage(named: "buttonCheckboxNewJobTrue"), for: .normal)
            }

        case 105:
            if isFriday{
                isFriday = false
                isFridayButton.setImage(UIImage(named: "buttonCheckboxNewJobFalse"), for: .normal)
            }
            else
            {
                isFriday = true
                isFridayButton.setImage(UIImage(named: "buttonCheckboxNewJobTrue"), for: .normal)
            }

            
        case 106:
            if isSaturday{
                isSaturday = false
                isSaturdayButton.setImage(UIImage(named: "buttonCheckboxNewJobFalse"), for: .normal)
            }
            else
            {
                isSaturday = true
                isSaturdayButton.setImage(UIImage(named: "buttonCheckboxNewJobTrue"), for: .normal)
            }
        case 107:
            if isSunday{
                isSunday = false
                isSundayButton.setImage(UIImage(named: "buttonCheckboxNewJobFalse"), for: .normal)
            }
            else
            {
                isSunday = true
                isSundayButton.setImage(UIImage(named: "buttonCheckboxNewJobTrue"), for: .normal)
            }
        case 108:
            if isRecurring
            {
                isRecurring = false
                isRecurringButton.setImage(UIImage(named: "buttonCheckboxNewJobFalse"), for: .normal)
            }
            else
            {
                isRecurring = true
//                isMonday = true; isTuesday = true; isWednesday = true; isThrusday = true; isFriday = true; isSaturday = true; isSunday = true
                isRecurringButton.setImage(UIImage(named: "buttonCheckboxNewJobTrue"), for: .normal)
            }
        default:
            print("Exhaustive")
        }
    }
    func validate() -> Bool
    {
        guard (selectedRouteId != nil) else {showError(title: "Alert", message: "Please select a route");return false}
        guard time != "" else{showError(title: "Alert", message: "Invalid Time"); return false}
//        if !isMonday && !isTuesday && !isWednesday && !isThrusday && !isFriday && !isSaturday && !isSunday && !isRecurring
//        {
//            showError(title: "Alert", message: "Please select at least one day of the week.")
//            return false
//        }
        return true
    }
    
    func saveButtonTapped()
    {
        if validate()
        {
            guard let username = Defaults[.driverUsername] else {return}
            let payload:[String:Any] = [
                "RouteId":selectedRouteId!,
                "ScheduleTime":time,
                "Mon":isMonday,
                "Tue":isTuesday,
                "Wed":isWednesday,
                "Thu":isThrusday,
                "Fri":isFriday,
                "Sat":isSaturday,
                "Sun":isSunday,
                "UserName":username
            ]
            
            apiClient.addNewJob(payload: payload, callback: { (success, error) in
                if success
                {
                    self.saveButtonCallback?()
                    self.hide()
                }
                else
                {
                    showError(title: "Alert", message: error)
                }
            })
        }
    }
        
    func dismissPicker()
    {
        self.endEditing(false)
    }
    
    func handleDatePicker(sender:UIDatePicker)
    {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        timeTF.text = timeFormatter.string(from: sender.date)
        time = timeTF.text!
    }
    
    func show()
    {
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(self)
        
        overlayView = UIView(frame: self.frame)
        overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        let TGR = UITapGestureRecognizer(target: self, action: #selector(hide))
        overlayView?.addGestureRecognizer(TGR)
        self.dialogView?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)

        self.addSubview(overlayView!)
        self.bringSubview(toFront: dialogView!)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.dialogView?.transform = CGAffineTransform(scaleX: 1, y: 1)

        }) { (true) in
        }
    }
    
    func hide()
    {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.overlayView?.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.dialogView?.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            
        }) { (true) in
            self.overlayView?.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
}
extension AddNewJob:UIPickerViewDelegate,UIPickerViewDataSource
{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let routes = self.routes else {return 0}
        return (routes.count)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return routes?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRouteTF.text = routes?[row].name
        selectedRouteId = routes?[row].id
    }
}
extension AddNewJob : UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let routes = self.routes else {return}
        if routes.count == 0
        {
            showError(title: "Alert", message: "No Routes found"){ _ in self.hide()};
            self.dismissPicker()
        }
    }
}
