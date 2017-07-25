//
//  ProfileManager.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 25/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

class ProfileManager {
    
    static let shared = ProfileManager()
    
    var isChangedProfile = true
    
    func logOff()
    {
        Defaults[.isLoggedIn] = false
        if !(Defaults[.isLoginDetailsRemembered] ?? true)
        {
            Defaults[.driverUsername] = nil
            Defaults[.driverPassword] = nil
        }
        Defaults[.lastLongitude] = nil
        Defaults[.lastLatitude] = nil
        Defaults[.driverFirstName] = nil
        Defaults[.driverLastName] = nil
        Defaults[.driverEmail] = nil
        Defaults[.driverMobile] = nil
        Defaults[.driverCountryCode] = nil
        Defaults[.driverLicense] = nil
        Defaults[.driverLicenseExp] = nil
        Defaults[.driverProfilePhoto] = nil
        Defaults[.driverProfilePhotoSize] = nil
        Defaults[.driverLoginTime] = nil
        Defaults[.driverVehicleNo] = nil
        Defaults[.driverVehicleId] = nil
        Defaults[.driverRowIndex] = nil
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.setupUI()
    }
}
