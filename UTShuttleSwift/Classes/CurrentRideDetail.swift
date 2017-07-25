//
//  CurrentRideDetail.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 20/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TripStatus:Int{
    case Board = 0
    case Unload = 108 //check - was told by Dharmendra
}

class CurrentRideDetail {
    
    var pickupLocationName:String?
    var flightNo:String?
    var time:String?
    var paxCount:String?
    var refId:String?
    var sourceTypeId:String?
    var paxDetailId:String?
    var tripStatus:TripStatus?
    
    init(json:JSON) {
        pickupLocationName = json["PuLocationName"].stringValue
        flightNo = json["PuAirLineCode"].stringValue + " - " + json["PuAirLineNo"].stringValue
        time = json["PuDateTime"].stringValue
        paxCount = json["AdultNo"].stringValue
        refId = json["RefNo"].stringValue
        sourceTypeId = json["SourceTypeId"].stringValue
        paxDetailId = json["PaxDetailId"].stringValue
        tripStatus = TripStatus(rawValue: json["TripStatusId"].numberValue.intValue)
    }
}

//Response From Server

//"CurrentRide": [
//{
//"AdultNo": 2,
//"PaxDetailId": 0,
//"PuAirLineCode": "NK",
//"PuAirLineNo": "0554",
//"PuDateTime": "05:30 AM",
//"PuLocationName": "ATL",
//"RefNo": 60,
//"SourceTypeId": 1,
//"TripStatusId": 0
//},
