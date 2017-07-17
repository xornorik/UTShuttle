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
    
    @IBOutlet weak var vehicleSearchBar:UISearchBar!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var vehicleTableView:UITableView!
    
    var filteredVehicles = [Vehicle]()
    var vehicles = [Vehicle]()
    var apiClient = APIClient.shared


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupVC()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "buttonAddJob"), style: .done, target: self, action: #selector(addVehicleTapped))
        
        let vehicleSearchController:UISearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.barStyle = UIBarStyle.black
            controller.searchBar.showsCancelButton = false
            controller.searchBar.barTintColor = UIColor.white
            controller.searchBar.backgroundColor = UIColor.clear
            controller.searchBar = self.vehicleSearchBar
            return controller
        })()
        
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
                showError(title: "Alert", message: error)
            }
        }
    }
    
    func addVehicleTapped()
    {
        
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
        Defaults[.driverVehicleNo] = vehicles[indexPath.row].vehicleNo
        Defaults[.driverVehicleId] = vehicles[indexPath.row].vehicleId

        dismiss(animated: true, completion: nil)
    }
}

extension VehicleViewController:UISearchResultsUpdating
{
    func filterContentForSearchText(searchText: String) {
        filteredVehicles = self.vehicles.filter { vehicle in
            return (vehicle.vehicleNo?.lowercased().contains(searchText.lowercased()))!
        }
        vehicleTableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }

}
