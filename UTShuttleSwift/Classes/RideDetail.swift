//
//  RideDetail.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 18/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import SwiftyJSON

class RideDetail{
    
    var pickupLocation:String?
    var flightDetails:String?
    var time:String?
    var pax:String?
    
    init(json:JSON) {
        pickupLocation = json["PuLocationName"].stringValue
        flightDetails = json["PuAirLineCode"].stringValue + " - " + json["PuAirLineNo"].stringValue
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "mm/dd/yyyy HH:MM:SS a"
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:MM a"
        let date = dateformatter.date(from: json["PuDateTime"].stringValue)
        time = timeformatter.string(from: date!)
        
        pax = json["AdultNo"].stringValue
    }
    
}

//Response from server 

//{
//    "IsSuccess": true,
//    "ResponseCode": 1,
//    "ResponseMessage": "70 Record(s) Found",
//    "RideDetails": [
//    {
//    "Id": 0,
//    "IsActive": null,
//    "Name": null,
//    "Status": null,
//    "UserName": null,
//    "AdultNo": 2,
//    "PuAirLineCode": "NK",
//    "PuAirLineNo": "0147",
//    "PuDateTime": "7/18/2017 3:55:00 PM",
//    "PuLocationName": "ATL",
//    "RideId": 0,
//    "TripStatusId": 0
//    },
