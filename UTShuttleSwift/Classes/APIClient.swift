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
    var prodBaseUrl = "http://services.utwiz.com/Services/ShuttleMobileService/V1.0.0/CoreService.svc/"
    
    var baseUrl = ""
    
    var manager = SessionManager.default
    
    struct EndPoints{
        static let driverRegistration = "Driver/CrudDriverUser"
        static let driverProfile = "Driver/GetDriverProfile"
        static let getDriverVehicles = "Driver/GetDriverVehicles"
        static let getVehicleTypes = "VehicleType/GetVehicleType"
        static let addNewVehicle = "Vehicle/AddEditShuttleVehicle"
        static let mapVehicle = "Driver/MapDeviceVehicle"
        static let getJobList = "RouteScheduleJobList/GetRouteScheduleJobList"
        static let getRideDetails = "RouteScheduleRideList/GetRideDetails"
        static let getRoutes = "Route/GetRoutes"
        static let addNewJob = "Vehicle/CrudRouteSchedules"
        static let getCurrentRideDetails = "RouteScheduleRideList/GetCurrentRide"
        static let getCurrentRideStops = "ScheduleRouteStops/GetScheduleRouteStops"
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
    
    func addNewVehicle(vNo:String, vin:String, plateNo:String, dotNo:String, vehicleTypeId:Int, seats:Int, username:String, callback:@escaping(_ success:Bool, _ error:String)->())
    {
        print("Requesting Add new Vehicle")
        showHUD()
        let vehicle:[String : Any] = ["VehicleNo":vNo,"Vin":vin,"PlateNo":plateNo, "DOTNumber":dotNo, "VehicleTypeId":vehicleTypeId, "seats":seats, "UserName":username]
        let parameters:[String : Any] = ["Vehicle":vehicle]
        let url = baseUrl + EndPoints.addNewVehicle
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                print("Received response \(response)")
                if response.result.isSuccess
                {
                    let json = JSON(response.result.value!)
                    hideHUD()
                    callback(false,json["ResponseMessage"].stringValue)
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
                        //showSuccessHUD()
                        hideHUD()
                        callback(true,json["ResponseMessage"].stringValue)
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
    
    func getRouteSheduledJobList(username:String, callback:@escaping(_ success:Bool, _ error:String,_ scheduledJobs:[ScheduledJob])->())
    {
        print("Requesting Scheduled Jobs")
        showHUD()
        let parameters:[String : Any] = ["UserName":username]
        let url = baseUrl + EndPoints.getJobList
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                print("Received response \(response)")
                if response.result.isSuccess
                {
                    let json = JSON(response.result.value!)
                    if json["IsSuccess"].boolValue
                    {
                        var scheduledJobs = [ScheduledJob]()
                        for subjson in json["RouteScheduleJob"].arrayValue
                        {
                            let scheduledJob = ScheduledJob(json: subjson)
                            scheduledJobs.append(scheduledJob)
                        }
                        hideHUD()
                        callback(true,"",scheduledJobs)
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
    func getRideDetails(username:String, callback:@escaping(_ success:Bool, _ error:String,_ rideDetails:[RideDetail])->())
    {
        print("Requesting Ride Details")
        showHUD()
        let parameters:[String : Any] = ["UserName":username]
        let url = baseUrl + EndPoints.getRideDetails
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                print("Received response \(response)")
                if response.result.isSuccess
                {
                    let json = JSON(response.result.value!)
                    if json["IsSuccess"].boolValue
                    {
                        var rideDetails = [RideDetail]()
                        for subjson in json["RideDetails"].arrayValue
                        {
                            let rideDetail = RideDetail(json: subjson)
                            rideDetails.append(rideDetail)
                        }
                        hideHUD()
                        callback(true,"",rideDetails)
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
    
    func getRoutes(username:String, callback:@escaping (_ success:Bool,_ error:String, _ routes:[Route])->())
    {
        print("Requesting Routes")
        showHUD()
        let parameters:[String : Any] = ["UserName":username]
        let url = baseUrl + EndPoints.getRoutes
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                print("Received response \(response)")
                if response.result.isSuccess
                {
                    let json = JSON(response.result.value!)
                    if json["IsSuccess"].boolValue
                    {
                        var routes = [Route]()
                        for subjson in json["Routes"].arrayValue
                        {
                            let route = Route(json: subjson)
                            routes.append(route)
                        }

                        hideHUD()
                        callback(true,"",routes)
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
    
    func addNewJob(payload:[String:Any], callback:@escaping (_ success:Bool,_ error:String)->())
    {
        print("Requesting Add new Job")
        showHUD()
        let parameters:[String : Any] = ["RouteSchedules":payload]
        let url = baseUrl + EndPoints.addNewJob
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                print("Received response \(response)")
                if response.result.isSuccess
                {
                    let json = JSON(response.result.value!)
                    if json["IsSuccess"].boolValue
                    {
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
    
    func getCurrentRideDetails(username:String, rideId:Double, callback:@escaping(_ success:Bool,_ error:String,_ currentRideDetails:[CurrentRideDetail])->())
    {
        print("Requesting Current Ride Details")
        showHUD()
        let parameters:[String : Any] = ["UserName":username, "RideId":rideId]
        let url = baseUrl + EndPoints.getCurrentRideDetails
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                print("Received response \(response)")
                if response.result.isSuccess
                {
                    let json = JSON(response.result.value!)
                    if json["IsSuccess"].boolValue
                    {
                        var rideDetails = [CurrentRideDetail]()
                        for subjson in json["CurrentRide"].arrayValue
                        {
                            let rideDetail = CurrentRideDetail(json: subjson)
                            rideDetails.append(rideDetail)
                        }
                        
                        hideHUD()
                        callback(true,"",rideDetails)
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
    
    func getCurrentRideStops(scheduleId:Int, callback:@escaping(_ success:Bool,_ error:String,_ currentRouteStops:[ScheduledRouteStop])->())
    {
        print("Requesting Current Ride Stops")
        showHUD()
        let parameters:[String : Any] = ["ScheduleId":scheduleId]
        let url = baseUrl + EndPoints.getCurrentRideStops
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
            .validate()
            .responseJSON { (response) in
                print("Received response \(response)")
                if response.result.isSuccess
                {
                    let json = JSON(response.result.value!)
                    if json["IsSuccess"].boolValue
                    {
                        var rideStops = [ScheduledRouteStop]()
                        for subjson in json["ScheduleRouteStops"].arrayValue
                        {
                            let rideStop = ScheduledRouteStop(json: subjson)
                            rideStops.append(rideStop)
                        }
                        
                        hideHUD()
                        callback(true,"",rideStops)
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

}
