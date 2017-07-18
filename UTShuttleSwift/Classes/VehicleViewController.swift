//
//  VehicleViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 17/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class VehicleViewController: UIViewController {
    
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var vehicleTableView:UITableView!
    @IBOutlet weak var closeButton:UIButton!
    @IBOutlet weak var addVehicleButton:UIButton!
    @IBOutlet weak var currentVehicleLabel:UILabel!
    @IBOutlet weak var unmapButton:UIButton!
    
    var vehicleSearchController = UISearchController()
    
    var filteredVehicles = [Vehicle]()
    var vehicles = [Vehicle]()
    var apiClient = APIClient.shared


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupVC()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "buttonAddJob"), style: .done, target: self, action: #selector(addVehicleTapped))
        
        self.vehicleSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.barStyle = UIBarStyle.default
            controller.searchBar.searchBarStyle = .minimal
            controller.searchBar.showsCancelButton = false
            controller.searchBar.barTintColor = UIColor.white
            controller.searchBar.backgroundColor = UIColor.clear
            self.vehicleTableView.tableHeaderView = controller.searchBar

            return controller
        })()
        
        closeButton.addTarget(self, action: #selector(dissmissVehicleVC), for: .touchUpInside)
        addVehicleButton.addTarget(self, action: #selector(addVehicleTapped), for: .touchUpInside)
        if let vehicleNo = Defaults[.driverVehicleNo]
        {
            currentVehicleLabel.text = "Today I'm Driving Vehicle" + vehicleNo
            unmapButton.isHidden = false
            unmapButton.addTarget(self, action: #selector(unmapButtonTapped), for: .touchUpInside)
        }
        else
        {
            currentVehicleLabel.text = "Today I'm Driving..."
            unmapButton.isHidden = true
        }
        currentVehicleLabel.text = "Today I'm Driving " + (Defaults[.driverVehicleNo] ?? "...")
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "EEEE, dth MMM"
        dateLabel.text = "Today, " + dateformatter.string(from: Date())
        
        getVehicles()
    }
    
    func dissmissVehicleVC()
    {
        dismiss(animated: true, completion: nil)
    }
    
    func getVehicles()
    {
        guard let deviceId = Defaults[.deviceId] else {return}
        apiClient.getDriverVehicles(deviceId: deviceId) { (success, error, vehicles) in
            
            if success
            {
                self.vehicles = vehicles
                self.vehicleTableView.reloadData()
            }
            else
            {
                showErrorForModal(title: "Alert", message: error, viewController: self)
            }
        }
    }
    
    func unmapButtonTapped()
    {
        guard let vehicleId = Defaults[.driverVehicleId] else {return}
        showConfirmForModal(title: "Alert", message: "Are you sure you want to un-map this vehicle?", viewController: self) {
            self.mapOrUnmapVehicle(shouldMap: false,vehicleId: Int(vehicleId)!) { _ in
                Defaults[.driverVehicleNo] = nil
                Defaults[.driverVehicleId] = nil
                self.setupVC()
            }
        }
    }
    
    func mapOrUnmapVehicle(shouldMap:Bool = true, vehicleId:Int,callback:(()->Void)!)
    {
        guard let deviceId = Defaults[.deviceId] else {return}
        guard let username = Defaults[.driverUsername] else {return}
        let machineIp = DeviceDetails.ipAddress()
        
        apiClient.mapVehicleToDriver(vehicleId: vehicleId, deviceId: Int(deviceId)!, machineIp: machineIp, username: username) { (success, error) in
            
            if !success
            {
                showError(title: "Alert", message: error)
                return
            }
            if callback != nil
            {
                callback()
            }
        }
        
    }
    
    func addVehicleTapped()
    {
        let nextVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "addVehicleVC")
        self.present(nextVC, animated: true, completion: nil)
    }

}
extension VehicleViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = vehicleTableView.dequeueReusableCell(withIdentifier: "vehicleCell", for: indexPath)
        let vehicleNumber = cell.viewWithTag(100) as! UILabel!
        
        vehicleNumber?.text = vehicles[indexPath.row].vehicleNo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showConfirmForModal(title: "Alert", message: "Are you sure you want to map \(String(describing: vehicles[indexPath.row].vehicleNo))", viewController: self) {
            Defaults[.driverVehicleNo] = self.vehicles[indexPath.row].vehicleNo
            Defaults[.driverVehicleId] = self.vehicles[indexPath.row].vehicleId
            
            self.mapOrUnmapVehicle(vehicleId: Int(self.vehicles[indexPath.row].vehicleId!)!) {
                self.dissmissVehicleVC()
            }

        }
    }
}

extension VehicleViewController:UISearchResultsUpdating
{
    func filterContentForSearchText(searchText: String) {
        filteredVehicles = self.vehicles.filter { vehicle in
            return (vehicle.vehicleNo?.contains(searchText))!
        }
        vehicleTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

}
