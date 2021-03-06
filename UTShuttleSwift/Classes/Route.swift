//
//  Route.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 20/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import SwiftyJSON

class Route {
    
    var id:Double?
    var name:String?
    var stopCountText:String?
    
    init(json:JSON) {
        id = json["Id"].numberValue.doubleValue
        name = json["RouteName"].stringValue
        stopCountText = json["StopCount"].stringValue
    }
}


//Response from Server

//"Routes": [
//{
//"Id": 1,
//"IsActive": null,
//"Name": null,
//"Status": null,
//"UserName": null,
//"DispatchRouteId": 0,
//"DropOffInstructions": null,
//"FromStopId": 0,
//"PickupInstructions": null,
//"RouteGroupId": 0,
//"RouteName": "My Route",
//"StopCount": "4 STOPS",
//"ToStopId": 0
//},
