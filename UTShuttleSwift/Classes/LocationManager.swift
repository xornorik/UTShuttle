//
//  LocationManager.swift
//  UTShuttleSwift
//
//  Created by Srinivas Vemuri on 10/07/17.
//  Copyright © 2017 PLEXITECH. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import SwiftyUserDefaults


class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    let locationManager = CLLocationManager()
    var distanceInterval = 200 // default: 200 meters
    var secondInterval = 50 // default: 60 seconds
    var currentLocation: CLLocation?


    func startTracking() {
        
        print("Starting location tracking...")
        
//        if let d = Defaults["locationUpdateDistanceMeters"].int {
//            distanceInterval = d
//        }
//        
//        if let t = Defaults["locationUpdateTimeSeconds"].int {
//            secondInterval = t
//        }
        
//        print("Location Manager configured to update every:\n\t\(secondInterval) seconds \n\tOR\n\t\(distanceInterval) meters")
        
//        sendTimer = NSTimer.scheduledTimerWithTimeInterval(Double(secondInterval), target: self, selector: #selector(sendLocation), userInfo: nil, repeats: true)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
        
        if #available(iOS 9.0, *) {
            locationManager.allowsBackgroundLocationUpdates = true
        }
        
    }
    
    func stopTracking()  {
        
        print("Stopping location tracking...")
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    func saveLastLocation(lastLocation: CLLocation) {
        Defaults[.lastLatitude] = lastLocation.coordinate.latitude
        Defaults[.lastLongitude] = lastLocation.coordinate.longitude
//        Defaults["lastCourse"] = lastLocation.course
//        Defaults["lastSpeed"] = lastLocation.speed > 0 ? lastLocation.speed : 0
//        Defaults["lastAccuracy"] = lastLocation.horizontalAccuracy
    }
    
    func isWithinAcceptableBounds(lat:String, lon:String) -> Bool
    {
//        let destinationLocationCoords = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(lon)!)
        let destinationLocation = CLLocation(latitude: CLLocationDegrees(lat)!, longitude: CLLocationDegrees(lon)!)
//        let currentLocationCoords = currentLocation?.coordinate
        if (currentLocation?.distance(from: destinationLocation))! < Double(distanceInterval)
        {
            return true
        }
        else
        {
            return false
        }
        
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let currentLocation = locations.first else {
            return
        }
        
        self.currentLocation = currentLocation
        
        if currentLocation.horizontalAccuracy < 0 {
            return
        }
        
//        // If the last location's distance from the current point is greater than the distance trigger distance,
//        // send an update now
//        if currentLocation.distanceFromLocation(lastLocation()) >= Double(distanceInterval) {
//            print("Geofence interval triggered. Sending location...")
//            saveLastLocation(currentLocation)
//            sendLocation()
//        }
        
        // Save last location
        saveLastLocation(lastLocation: currentLocation)
    }

    
}
