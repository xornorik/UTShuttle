//
//  TripHistoryStop.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 24/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import SwiftyJSON

class TripHistoryStop {
    
    var stopId:String?
    init(json:JSON) {
        stopId = json["StopId"].stringValue
    }
    
}

//Response logged in DOC (could not test on postman)

//StopId	long
//LocationName	string
//LocationCode	string
//IsService	bool
//IsServiceStatus	string
//CityCode	string
//Latitude	float
//Longitude	float
//LocationTypeId	int
//LocationTypeName	string
//IsTerminal	bool
//IsTerminalStatus	string
//IsActive	bool
//status	string
//Sequence	int
//Address	string
//City	string
//State	string
//Zip	string
//FavouriteName	String
