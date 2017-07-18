//
//  SheduledJob.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 18/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import SwiftyJSON

class ScheduledJob{
    
    var fromStop:String?
    var toStop:String?
    var time:String?
    
    init(json:JSON) {
        fromStop = json["FromStopName"].stringValue
        toStop = json["ToStopName"].stringValue
        time = json["ScheduleTime"].stringValue
    }
}



//Response from server 
//{
//    "IsSuccess": true,
//    "ResponseCode": 1,
//    "ResponseMessage": "1 Record(s) Found",
//    "RouteScheduleJob": [
//    {
//    "CurrentStopId": 0,
//    "Fri": false,
//    "FromStopId": 7,
//    "FromStopName": "Warwick Seattle",
//    "IsActive": true,
//    "JobId": 0,
//    "Mon": false,
//    "RideId": 4293242730131,
//    "RouteId": 5,
//    "RouteName": "R4",
//    "Sat": false,
//    "ScheduleId": 63,
//    "ScheduleTime": "05:41 AM",
//    "Sun": false,
//    "Thu": false,
//    "ToStopId": 1,
//    "ToStopName": "LGA/Terminal D",
//    "TripStatusId": 101,
//    "TripStatusName": "PENDING",
//    "Tue": false,
//    "Wed": false
//    }
//    ]
//}
