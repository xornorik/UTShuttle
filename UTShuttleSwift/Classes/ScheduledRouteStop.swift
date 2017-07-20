//
//  ScheduledRouteStop.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 20/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import SwiftyJSON

class ScheduledRouteStop {
    
    var scheduleId:String?
    var stopId:String?
    var stopLat:String?
    var stopLon:String?
    var stopName:String?
    
    init(json:JSON) {
        scheduleId = json["ScheduleId"].stringValue
        stopId = json["StopId"].stringValue
        stopLat = json["StopLatitude"].stringValue
        stopLon = json["StopLongitue"].stringValue
        stopName = json["StopName"].stringValue
    }
    
}

//Response from Server

//"ScheduleRouteStops": [
//{
//"ScheduleId": 177,
//"ScheduleTime": "05:29:00",
//"ScheduleTimeInMinutes": "5",
//"StopId": 1,
//"StopLatitude": 42,
//"StopLongitue": -71,
//"StopName": "John F. Kennedy Presidential Library and Museum"
//},
