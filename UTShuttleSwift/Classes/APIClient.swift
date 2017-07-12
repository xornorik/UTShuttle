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
    
    var manager = SessionManager.default
    
    struct EndPoints{
        static let driverRegistration = "Driver/CrudDriverUser"
    }
    
    func setup()
    {
        
    }
    
    func driverRegistration(payload:[String:Any], callback:(_ success:Bool)->())
    {
        let parameters:[String:Any] = ["Driver":payload]
        let url = testBaseUrl + EndPoints.driverRegistration
        manager.request(url, method: HTTPMethod.post, parameters: parameters, encoding: JSONEncoding.default, headers: nil)
        .validate()
        .responseJSON { (response) in
            <#code#>
        }
        
    }
}
