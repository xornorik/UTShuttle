//
//  APIClient.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 12/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftyUserDefaults

class APIClient : NSObject {
    
    static let shared = APIClient()
    
    var testBaseUrl = "http://10.10.11.12:4003/UTSShuttleMobile/CoreService.svc/"
    
    var baseUrl = ""
    
    var manager = SessionManager.default
    
    struct EndPoints{
        static let driverRegistration = "Driver/CrudDriverUser"
        static let driverProfile = "Driver/GetDriverProfile"
        static let getDriverVehicles = "Driver/GetDriverVehicles"
        static let getVehicleTypes = "VehicleType/GetVehicleType"
        static let mapVehicle = "Driver/MapDeviceVehicle"
    }
    
    func setup()
    {
        baseUrl = testBaseUrl
    }
    
    func parseError(response:DataResponse<Any>)
    {
        if isHUDVisible()
        {
            hideHUD()
        }
        guard let responseCode = response.response?.statusCode else {
            showError(title: "Connection Lost", message: "Connection to server has been lost")
            return
        }
        print(responseCode)
        print(response.result.error.debugDescription)
    }
    
    func driverRegistration(payload:[String:Any], callback:@escaping (_ success:Bool,_ error:String)->())
    {
        print("Requesting driver registration")
        showHUD()
        let parameters:[String:Any] = ["Driver":payload]
        let url = baseUrl + EndPoints.driverRegistration
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
        .validate()
        .responseJSON { (response) in
            print("Received response \(response)")
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                if json["IsSuccess"].boolValue
                {
                    showSuccessHUD()
                    callback(true,"")
                }
                else
                {
                    hideHUD()
                    callback(false,json["ResponseMessage"].stringValue)
                }
            }
            else
            {
                hideHUD()
                self.parseError(response: response)
            }
        }
    }
    
    func getDriverProfile(username:String, callback:@escaping ( _ success:Bool,_ error:String)->())
    {
        print("Requesting Driver profile information")
        showHUD()
        let parameters:[String : Any] = ["UserId":0,"UserName":username]
        let url = baseUrl + EndPoints.driverProfile
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
        .validate()
        .responseJSON { (response) in
            print("Received response \(response)")
            if response.result.isSuccess
            {
                let json = JSON(response.result.value!)
                if json["IsSuccess"].boolValue
                {
                    let subjson = json["DriverProfile"]
                    Defaults[.driverFirstName] = subjson["FirstName"].stringValue
                    Defaults[.driverLastName] = subjson["LastName"].stringValue
                    Defaults[.driverProfilePhoto] = subjson["ImageUrl"].stringValue
                    Defaults[.driverCountryCode] = subjson["CountryCode"].stringValue
                    Defaults[.driverUsername] = subjson["UserName"].stringValue
                    Defaults[.driverPassword] = subjson["Password"].stringValue
                    Defaults[.driverEmail] = subjson["Email"].stringValue
                    Defaults[.driverLicense] = subjson["DriverLicenceNumber"].stringValue
                    Defaults[.driverLicenseExp] = subjson["DriverLicenceExpiryDate"].stringValue
                    hideHUD()
                    callback(true,"")
                }
                else
                {
                    hideHUD()
                    callback(false,json["ResponseMessage"].stringValue)
                }
            }
            else
            {
                hideHUD()
                self.parseError(response: response)
            }
 
        }
        
    }
    
    func getDriverVehicles(deviceId:String, callback:@escaping(_ success:Bool, _ error:String,_ vehicles:[Vehicle])->())
    {
        print("Requesting List of Vehicles")
        showHUD()
        let parameters:[String : Any] = ["AccountId":0, "LocationId":0 ,"DeviceId":deviceId]
        let url = baseUrl + EndPoints.getDriverVehicles
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                print("Received response \(response)")
                if response.result.isSuccess
                {
                    let json = JSON(response.result.value!)
                    if json["IsSuccess"].boolValue
                    {
                        var vehicles = [Vehicle]()
                        for subjson in json["DriverVehicles"].arrayValue
                        {
                            let vehicle = Vehicle(json: subjson)
                            vehicles.append(vehicle)
                        }
                        hideHUD()
                        callback(true, "",vehicles)
                    }
                    else
                    {
                        hideHUD()
                        callback(false,json["ResponseMessage"].stringValue,[])
                    }
                }
                else
                {
                    hideHUD()
                    self.parseError(response: response)
                }
        }
    }
    
    func getVehicleTypes(username:String, callback:@escaping(_ success:Bool, _ error:String,_ vehicleTypes:[VehicleType])->())
    {
        print("Requesting Vehicle Types")
        showHUD()
        let parameters:[String : Any] = ["UserName":username]
        let url = baseUrl + EndPoints.getVehicleTypes
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                print("Received response \(response)")
                if response.result.isSuccess
                {
                    let json = JSON(response.result.value!)
                    if json["IsSuccess"].boolValue
                    {
                        var vehicleTypes = [VehicleType]()
                        for subjson in json["VehicleType"].arrayValue
                        {
                            let vehicleType = VehicleType(json: subjson)
                            vehicleTypes.append(vehicleType)
                        }
                        hideHUD()
                        callback(true,"",vehicleTypes)
                    }
                    else
                    {
                        hideHUD()
                        callback(false,json["ResponseMessage"].stringValue,[])
                    }
                }
                else
                {
                    hideHUD()
                    self.parseError(response: response)
                }
        }

    }
    
    func mapVehicleToDriver(vehicleId:Int, deviceId:Int, machineIp:String, username:String, isMapped:Bool = true, callback:@escaping(_ success:Bool, _ error:String)->())
    {
        print("Requesting Vehicle Mapping")
        showHUD()
        let parameters:[String : Any] = ["AccountId":0,"VehicleId":vehicleId, "DeviceId":deviceId, "isMapped":isMapped, "UserId":0, "MachineIP":machineIp, "UserName":username]
        let url = baseUrl + EndPoints.mapVehicle
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                print("Received response \(response)")
                if response.result.isSuccess
                {
                    let json = JSON(response.result.value!)
                    if json["ResponseCode"].numberValue.intValue != 0
                    {
                        showSuccessHUD()
                        callback(true,"")
                    }
                    else
                    {
                        hideHUD()
                        callback(false,json["ResponseMessage"].stringValue)
                    }
                }
                else
                {
                    hideHUD()
                    self.parseError(response: response)
                }
        }
    }
}
