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
import PKHUD

class APIClient : NSObject {
    
    static let shared = APIClient()
    
    var testBaseUrl = "http://10.10.11.12:4003/UTSShuttleMobile/CoreService.svc/"
    
    var manager = SessionManager.default
    
    struct EndPoints{
        static let driverRegistration = "Driver/CrudDriverUser"
    }
    
    func setup()
    {
        
    }
    
    func parseError(response:DataResponse<Any>)
    {
        if HUD.isVisible
        {
            HUD.hide()
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
        HUD.show(.progress)
        let parameters:[String:Any] = ["Driver":payload]
        let url = testBaseUrl + EndPoints.driverRegistration
        manager.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
        .validate()
        .responseJSON { (response) in
            print("Received response \(response)")
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                if json["IsSuccess"].boolValue
                {
                    HUD.flash(HUDContentType.success, delay: 0.3)
                    callback(true,"")
                }
                else
                {
                    HUD.hide()
                    callback(false,json["ResponseMessage"].stringValue)
                }
            }
            else
            {
                HUD.hide()
                self.parseError(response: response)
            }
        }
        
    }
}
