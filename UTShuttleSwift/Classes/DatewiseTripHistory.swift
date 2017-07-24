//
//  DatewiseTripHistory.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 24/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import SwiftyJSON

class DatewiseTripHistory {
    
    var tripDate:String?
    var tripHistory = [TripHistory]()
    
    init(json:JSON) {
        tripDate = json["TripDate"].stringValue
        
        for trip in json["TripHistory"].arrayValue
        {
            let tripHistory = TripHistory(json: trip)
            self.tripHistory.append(tripHistory)
        }
    }
}

//reponse from server 

//DriverTripHistory": [
//    {
//        "TripDate": "07/24/2017",
//        "TripHistory": [
//        {
//        "AdultNo": 0,
//        "DODateTime": "7/24/2017 11:01:19 AM",
//        "DOStopId": 1,
//        "DOStopLatitude": 41,
//        "DOStopLongitude": -74,
//        "DOStopName": "123",
//        "PUDateTime": "7/24/2017 1:30:52 AM",
//        "PUStopId": 1,
//        "PUStopLatitude": 41,
//        "PUStopLongitude": -74,
//        "PUStopName": "123",
//        "RefId": 0,
//        "RideId": 4293842730041,
//        "TimeTaken": 571,
//        "TripDate": "07/24/2017",
//        "TripHistoryStops": []
//        },
