//
//  VehicleViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 17/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

class VehicleViewController: UIViewController {
    
    @IBOutlet weak var vehicleSearchController:UISearchController!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var vehicleTableView:UITableView!
    
    var filteredVehicles = [Vehicle]()
    var vehicles = [Vehicle]()


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
        self.vehicleSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.barStyle = UIBarStyle.black
            controller.searchBar.showsCancelButton = false
            controller.searchBar.barTintColor = UIColor.white
            controller.searchBar.backgroundColor = UIColor.clear
            return controller
        })()
    }
    
    func getVehicles()
    {
        
    }

}
extension VehicleViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
