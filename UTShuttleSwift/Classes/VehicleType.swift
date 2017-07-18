//
//  File.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 18/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import SwiftyJSON

class VehicleType{
    
    var id:String?
    var name:String?
    var paxCount:Int?
    
    init(json:JSON) {
        id = json["Id"].stringValue
        name = json["Name"].stringValue
        paxCount = json["PaxCount"].numberValue.intValue
    }
}

//response from server

//{
//    "IsSuccess": true,
//    "ResponseCode": 1,
//    "ResponseMessage": "3 Record(s) Found",
//    "VehicleType": [
//    {
//    "Id": 3,
//    "IsActive": true,
//    "Name": "Sedan Only",
//    "Status": "ACTIVE",
//    "UserName": null,
//    "PaxCount": 3
//    },
//    {
//    "Id": 4,
//    "IsActive": true,
//    "Name": "Sedan Preferred",
//    "Status": "ACTIVE",
//    "UserName": null,
//    "PaxCount": 3
//    },
//    {
//    "Id": 5,
//    "IsActive": true,
//    "Name": "Van",
//    "Status": "ACTIVE",
//    "UserName": null,
//    "PaxCount": 16
//    }
//    ]
//}
