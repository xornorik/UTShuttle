//
//  TCPClient.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 07/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import SwiftSocket
import SwiftyUserDefaults
import Alamofire

class CommandClient: NSObject {
    
    static let shared = CommandClient()
    
    var address = "10.10.11.14"
    var port:Int32 = 3006
    var client:TCPClient
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")

    
    override init() {
        self.client = TCPClient(address: self.address, port: self.port)
    }
    
    
    struct Commands{
        
        static let DeviceAuth = "VI~"
        static let ReceiveUID = "RU"
        static let DeviceReg = "ND"
        static let DriverAuth = "DL"
        
    }
    
    //Mark: ERRORS
    enum deviceRegError:Int {
        case InvalidUniqueId = 2
        case Success = 1
        case MobileNoNotFound = 0
        case ConnectionError = 99
    }
    
    enum driverAuthError:Int {
        case Fail = 0
        case Success = 1
        case InvalidVehicle = 2
        case InvalidDriverCreds = 3
        case DriverAlreadyLoggedIn = 4
        case InvalidDevice = 5
        case InvalidDriver = 6
        case ConnectionError = 99
    }
    
    
    //MARK: TCP Functions
    
    func startConnection()
    {
        switch client.connect(timeout: 1) {
        case .success:
            print("Connected to TCP Server")
        case .failure(_):
            print("Failed to connect to TCP Server")
        }
    }
    
    func isConnected()->Bool
    {
        switch client.connect(timeout: 1) {
        case .success:
            print("Connected to TCP Server")
            return true
        case .failure(_):
            print("Failed to connect to TCP Server")
            return false
        }
    }

    
    func deviceAuth(callback:(_ success:Bool)->()){
        if isConnected()
        {
            let udid = DeviceDetails.deviceID() //consider encrypting
            let command = "#"+udid+"|"+Commands.DeviceAuth
            switch client.send(string: command)
            {
            case .success:
                guard let data = client.read(1024*10) else { return }
                if let response = String(bytes: data, encoding: .utf8) {
                    print("response received: \(response)")
                    let responseArr = decodeResponse(responseString: response)
                    guard let status = Int(responseArr.last!) else { print("Some error"); return }
                    switch Int(status)
                    {
                    case 0:
                        print("Failed")
                        callback(false)
                    case 1:
                        print("Success")
                        //Store the details retreived and show login page
                        Defaults[.deviceId] = responseArr[0]
                        Defaults[.appVersion] = responseArr[1]
                        callback(true)
                    case 2:
                        print("Invalid Device")
                        callback(true)
                    default:
                        print("Switch case exhaustive")
                    }
                }
            case .failure( _ ):
                callback(false)
            }
        }
        else{
            callback(false)
        }
    }
    
    func receiveUID(mobileNo:String, callback:(_ success:Bool)->())
    {
        if isConnected()
        {
            var reqParameters = [String]()
            reqParameters.append(DeviceDetails.deviceID())
            reqParameters.append(Commands.ReceiveUID)
            reqParameters.append(mobileNo)
            
            let command = encodeRequest(requestParameters: reqParameters)
            switch client.send(string: command)
            {
            case .success:
                guard let data = client.read(1024*10) else { return }
                if let response = String(bytes: data, encoding: .utf8) {
                    print("response received: \(response)")
                    let responseArr = decodeResponse(responseString: response)
                    guard let status = Int(responseArr.last!) else { print("Some error"); return }
                    switch Int(status)
                    {
                    case 0:
                        print("Failed")
                        callback(false)
                    case 1:
                        print("Succeeded")
                        Defaults[.deviceId] = responseArr[0]
                        Defaults[.uniqueId] = responseArr[2]
                        callback(true)
                    default:
                        print("Switch case exhaustive")
                    }
                }
            case .failure(_):
                callback(false)
                
            }
            
        }
        else
        {
            showError(title: "Connection Lost", message: "Connection to server has been lost")
        }
    }
    
    func deviceRegistration(uniqueId:String, callback:(_ success:Bool,_ error:deviceRegError )->())
    {
        if isConnected()
        {
            var reqParameters = [String]()
            reqParameters.append(DeviceDetails.deviceID())
            reqParameters.append(Commands.DeviceReg)
            reqParameters.append(uniqueId)
            reqParameters.append("1") //iOS:1, Android:0
            
            let command = encodeRequest(requestParameters: reqParameters)
            switch client.send(string: command)
            {
            case .success:
                guard let data = client.read(1024*10) else { return }
                if let response = String(bytes: data, encoding: .utf8) {
                    print("response received: \(response)")
                    let responseArr = decodeResponse(responseString: response)
                    guard let status = Int(responseArr.last!) else { print("Some error"); return }
                    switch status {
                    case 1:
                        //success
                        callback(true,deviceRegError.Success)
                    case 0:
                        callback(false, deviceRegError.MobileNoNotFound)
                    case 2:
                        callback(false, deviceRegError.InvalidUniqueId)
                    default:
                        print("Bad response from server")
                    }
                }
            case .failure(_):
                callback(false, deviceRegError.ConnectionError)
            }
            
        }
        else
        {
            showError(title: "Connection Lost", message: "Connection to server has been lost")
        }
    }
    
    func driverAuth(userId:String, password:String, deviceId:String, lat:String, lon:String, callback:(_ success:Bool, _ error:driverAuthError)->())
    {
        if isConnected()
        {
            var reqParameters = [String]()
            reqParameters.append(deviceId)
            reqParameters.append(Commands.DriverAuth)
            reqParameters.append(lat)
            reqParameters.append(lon)
            reqParameters.append(userId)
            reqParameters.append(password)
            
            let command = encodeRequest(requestParameters: reqParameters)
            switch client.send(string: command)
            {
            case .success:
                guard let data = client.read(1024*10) else { return }
                if let response = String(bytes: data, encoding: .utf8) {
                    print("response received: \(response)")
                    let responseArr = decodeResponse(responseString: response)
                    guard let status = Int(responseArr.last!) else { print("Some error"); return }
                    switch status {
                    case 0,2,3,4,5,6:
                        callback(false, driverAuthError(rawValue: status)!)
                    case 1:
                        callback(true, driverAuthError.Success)
                    default:
                        print("Bad response from server")
                    }
                }
            }
        }
        else
        {
            callback(false, driverAuthError.ConnectionError)
        }
    }
    
    //MARK: Helper Functions
    
    func decodeResponse(responseString:String) -> [String]
    {
        let response = responseString.replacingOccurrences(of: "<", with: "").replacingOccurrences(of: ">", with: "")
        let responseArr = response.components(separatedBy: "|")
        return responseArr
    }
    
    func encodeRequest(requestParameters:[String]) -> String
    {
        var encodedReq = "{"
        for parameter in requestParameters
        {
            encodedReq += parameter + "|"
        }
        encodedReq.remove(at: encodedReq.endIndex) //removing the last | symbol
        encodedReq += "}"
        
        return encodedReq
    }
}
