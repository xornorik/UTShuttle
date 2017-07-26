//
//  RoutesViewController.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 22/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class RoutesViewController: UIViewController {
    
    @IBOutlet weak var routesTableView:UITableView!
    
    let apiClient = APIClient.shared
    var routes:[Route]?

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
        self.title = "Routes"
        getRoutes()
    }
    
    func getRoutes(callback:(()->())? = nil)
    {
        guard let username = Defaults[.driverUsername] else {return}
        apiClient.getRoutes(username: username) { (success, error, routes) in
            
            if success
            {
                self.routes = routes
                self.routesTableView.reloadData()
            }
            else
            {
                showError(title: "Alert", message: error){
                    NavigationUtils.popViewController()
                }
            }
        }
    }
    
    func deleteRouteTapped(sender:UIButton)
    {
        let cell = sender.superview?.superview as! UITableViewCell
        guard let indexPath = self.routesTableView.indexPath(for: cell) else {return}
        guard let route = routes?[indexPath.row] else {return}
        guard let username = Defaults[.driverUsername] else {return}
        
        apiClient.deleteRoute(routeId: route.id!, username: username) { (success, error) in
            
            if success
            {
                self.getRoutes()
            }
            else
            {
                showError(title: "Alert", message: error)

            }
        }
    }
}
extension RoutesViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routeCell", for: indexPath)
        let routeNameLabel = cell.viewWithTag(100) as! UILabel
        let stopsLabel = cell.viewWithTag(101) as! UILabel
        let deleteButton = cell.viewWithTag(102) as! UIButton
        let route = routes?[indexPath.row]
        
        routeNameLabel.text = route?.name
        stopsLabel.text = route?.stopCountText
        deleteButton.addTarget(self, action: #selector(deleteRouteTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
}
