//
//  TripHistory.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 24/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import SwiftyJSON

class TripHistory {
    
    var rideId:String?
    var pickUpStop:String?
    var dropOffStop:String?
    var tripHistoryStops=[TripHistoryStop]()
    
    init(json:JSON) {
        rideId = json["RideId"].stringValue
        pickUpStop = json["PUStopName"].stringValue
        dropOffStop = json["DOStopName"].stringValue
        
        for tripStop in json["TripHistoryStops"].arrayValue
        {
            let tripHistoryStop = TripHistoryStop(json: tripStop)
            tripHistoryStops.append(tripHistoryStop)
        }
    }
}

//Response from Server

//"TripHistory": [
//{
//"AdultNo": 0,
//"DODateTime": "7/24/2017 11:01:19 AM",
//"DOStopId": 1,
//"DOStopLatitude": 41,
//"DOStopLongitude": -74,
//"DOStopName": "123",
//"PUDateTime": "7/24/2017 1:30:52 AM",
//"PUStopId": 1,
//"PUStopLatitude": 41,
//"PUStopLongitude": -74,
//"PUStopName": "123",
//"RefId": 0,
//"RideId": 4293842730041,
//"TimeTaken": 571,
//"TripDate": "07/24/2017",
//"TripHistoryStops": []
//},
