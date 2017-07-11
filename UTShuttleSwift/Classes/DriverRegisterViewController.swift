//
//  DriverRegisterViewController.swift
//  UTShuttleSwift
//
//  Created by Apple Developer on 11/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit

enum RegistrationStatus {
    case step1
    case step2
    case step3
}

class DriverRegisterViewController: UIViewController {
    
    var rStatus = RegistrationStatus.step1
    
    @IBOutlet weak var stepImageView:UIImageView!
    @IBOutlet weak var registerTableView:UITableView!
    @IBOutlet weak var nextButton:UIButton!
    

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
        if (self.navigationController?.isNavigationBarHidden)!
        {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }

        switch rStatus {
        case .step1:
            self.title = "Profile Information"
            self.stepImageView.image = UIImage(named: "imgRegStep1")
        case .step2:
            self.title = "Driver Information"
            self.stepImageView.image = UIImage(named: "imgRegStep2")

        case .step3:
            self.title = "Account Information"
            self.stepImageView.image = UIImage(named: "imgRegStep3")

        }
        
        nextButton.cornerRadius = 10
        self.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    func nextButtonTapped()
    {
        switch rStatus {
        case .step1:
            NavigationUtils.goToDriverRegisterStep2()
        case .step2:
            NavigationUtils.goToDriverRegisterStep3()
        default:
            print("This should not happen")
        }
    }
    
}
extension DriverRegisterViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch rStatus
        {
        case .step1:
            return 4
        case .step2:
            return 2
        case .step3:
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch rStatus {
        case .step1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "John"
                tf.autocapitalizationType = .words
                tf.keyboardType = .asciiCapable

                label.text = "First Name"
                return cell

            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "Doe"
                tf.autocapitalizationType = .words
                tf.keyboardType = .asciiCapable
                
                label.text = "Last Name"
                return cell

            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "johndoe@company.com"
                tf.autocapitalizationType = .none
                tf.keyboardType = .emailAddress
                label.text = "Email ID"
                return cell

            case 3:
                let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                let countryButton = cell.viewWithTag(102) as! UIButton
                
                tf.text = "+1 "
                tf.autocapitalizationType = .words
                label.text = "Phone Number"
                countryButton.setImage(UIImage(named: "US.png"), for: .normal)
                return cell

            default:
                return UITableViewCell()
            }
        case .step2:
            switch indexPath.row
            {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "989454"
                label.text = "Driver License Number"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "989454"
                label.text = "Driver License Expiry Date"
                return cell
            default:
                return UITableViewCell()
            }
        case .step3:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "989454"
                label.text = "Type your User Name"
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "989454"
                label.text = "Type password"
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "registerCell", for: indexPath)
                let tf = cell.viewWithTag(100) as! UITextField
                let label = cell.viewWithTag(101) as! UILabel
                
                tf.placeholder = "989454"
                label.text = "Retype Password"
                return cell

            default:
                return UITableViewCell()
            }
            
        default:
            print("Keep waiting")
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
