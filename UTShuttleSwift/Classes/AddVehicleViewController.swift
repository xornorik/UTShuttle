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
    var selectedVehicleType:VehicleType?
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupVC()
    }
    
    func setupVC()
    {
        closeButton.addTarget(self, action: #selector(dismissAddVehicleVC), for: .touchUpInside)
        addVehicleButton.addTarget(self, action: #selector(addVehicle), for: .touchUpInside)
        getVehicleTypes() {
            self.transferVehicleTypeDataToPickerCell()
        }
    }
    
    func dismissAddVehicleVC()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getVehicleTypes(callback:@escaping ()->()!)
    {
        guard let username = Defaults[.driverUsername] else {return}
        apiClient.getVehicleTypes(username: username) { (success, error, vehicleTypes) in
            
            if success
            {
                self.vehicleTypes = vehicleTypes
                callback()
            }
            else
            {
                showErrorForModal(title: "Alert", message: "Trouble fetching vehicle types", viewController: self)
            }
        }
    }
    
    func validateForm() -> Bool{
        guard vehicleNo != "" else {showError(title: "Alert", message: "Please enter the Vehicle Number."); return false}
        guard vehicleIdentityNumber != "" else {showError(title: "Alert", message: "Please enter the Vehicle Id Number."); return false}
        guard licensePlateNumber != "" else {showError(title: "Alert", message: "Please enter the License Plate Number."); return false}
        guard DOTNumber != "" else {showError(title: "Alert", message: "Please enter the DOT Number."); return false}
        guard selectedVehicleType != nil else {showError(title: "Alert", message: "Please select the type of vehicle."); return false}
            //what about number of seats? [!]
        return true
    }
    
    func addVehicle()
    {
        if validateForm()
        {
            guard let username = Defaults[.driverUsername] else {return}
            apiClient.addNewVehicle(vNo: vehicleNo, vin: vehicleIdentityNumber, plateNo: licensePlateNumber, dotNo: DOTNumber, vehicleTypeId: Int((selectedVehicleType?.id)!)!, seats: noOfSeats, username: username, callback: { (success, error) in
                
                showError(title: "Alert", message: error)
                self.dismiss(animated: true, completion: nil)
            })

        }
    }
    
    func transferVehicleTypeDataToPickerCell()
    {
        let pickerCell = addVehicleTableView.cellForRow(at: IndexPath(row: 4, section: 0)) as! UTSFormTableViewCell
        for cell in addVehicleTableView.visibleCells
        {
            if pickerCell == cell
            {
                pickerCell.pickerOptions = self.vehicleTypes
            }
        }
    }
    
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath) as! UTSFormTableViewCell
            cell.setup(type: .text, placeholder: "V100", text: "", labelText: "Vehicle Number")
            cell.delegate = self

            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath) as! UTSFormTableViewCell
            cell.setup(type: .text, placeholder: "1HGBH41JXMN", text: "", labelText: "Vehicle Identity Number")
            cell.delegate = self

            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath) as! UTSFormTableViewCell
            cell.setup(type: .text, placeholder: "HK ML266", text: "", labelText: "License Plate Number")
            cell.delegate = self

            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath) as! UTSFormTableViewCell
            cell.setup(type: .text, placeholder: "USDOT1234", text: "", labelText: "DOT Number")
            cell.delegate = self

            return cell

        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath) as! UTSFormTableViewCell
            cell.pickerOptions = vehicleTypes
            cell.setup(type: .picker, placeholder: "Sedan", text: "", labelText: "Vehicle Type")
            cell.delegate = self

            return cell

        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addVehicleCell", for: indexPath) as! UTSFormTableViewCell
            cell.setup(type: .text, placeholder: "2", text: String(noOfSeats), labelText: "Number of Seats")
            cell.formTextField.isEnabled = false
            cell.delegate = self

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

extension AddVehicleViewController : UTSFormTableViewCellDelegate
{
    func textFieldContent(cell: UTSFormTableViewCell, content: String, secondaryContent:String) {
        let currentIndexPath = self.addVehicleTableView.indexPath(for: cell)
        switch (currentIndexPath?.row)! {
        case 0: vehicleNo = content
        case 1: vehicleIdentityNumber = content
        case 2: licensePlateNumber = content
        case 3: DOTNumber = content
        case 4:
            for vehicle in vehicleTypes
            {
                if vehicle.name == content
                {
                    selectedVehicleType = vehicle
                    noOfSeats = vehicle.paxCount!
                    self.addVehicleTableView.reloadRows(at: [IndexPath(row: 5, section: 0)], with: .automatic) // to update the seat count
                }
            }
//        case 5: noOfSeats = Int(content)! Nothing happens here
        default: break
        }
    }
}
