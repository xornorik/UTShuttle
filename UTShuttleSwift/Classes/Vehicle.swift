//
//  File.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 17/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import SwiftyJSON

class Vehicle
{
    var vehicleId:String?
    var vehicleNo:String?
    
    init(json:JSON) {
        vehicleId = json["VehicleId"].stringValue
        vehicleNo = json["VehicleNo"].stringValue
    }
    
    //Response from server
//    {
//    "IsSuccess": true,
//    "ResponseCode": 1,
//    "ResponseMessage": "3 Record(s) Found",
//    "DriverVehicles": [
//    {
//    "Id": 0,
//    "IsActive": null,
//    "Name": null,
//    "Status": null,
//    "UserName": null,
//    "AcDescription": null,
//    "Acciceble": null,
//    "AccountId": "4399",
//    "AccountRowId": 0,
//    "Capacity": 0,
//    "CarriageDescription": null,
//    "CreatedBy": 0,
//    "DOTNumber": null,
//    "DeviceId": null,
//    "DeviceName": null,
//    "Imie": null,
//    "InOutServiceNote": null,
//    "IsAC": false,
//    "IsAccessible": false,
//    "IsCarriage": false,
//    "IsMDTLogin": false,
//    "IsPayrollActivated": false,
//    "IsPreventAccess": false,
//    "LicenceNo": null,
//    "LocationId": "13",
//    "LocationName": null,
//    "LocationRowId": null,
//    "MachineIP": null,
//    "MakeYear": null,
//    "MdtNo": null,
//    "MobileNo": null,
//    "PaxCount": 0,
//    "PlateNo": null,
//    "PreventAccess": null,
//    "PreventAccessNote": null,
//    "RadioNo": null,
//    "SimNo": null,
//    "StatusId": 0,
//    "UpdatedBy": 0,
//    "VehicleId": 733,
//    "VehicleLogDescription": null,
//    "VehicleModel": "",
//    "VehicleNo": "6789",
//    "VehicleNumber": null,
//    "VehicleOwner": null,
//    "VehicleOwnerId": 0,
//    "VehicleOwnerTypeId": null,
//    "VehicleStatus": null,
//    "VehicleTypeId": 0,
//    "VendorId": null,
//    "VendorNo": null,
//    "Vin": null,
//    "WefDate": null,
//    "seate": 0
//    }
}
