//
//  LocationManager.swift
//  InTheHood-ios
//
//  Created by Rotem Nevgauker on 13/07/2019.
//  Copyright © 2019 Rotem Nevgauker. All rights reserved.
//

import Foundation
import CoreLocation


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        current = location
        
//        AppDelegate.geoCoder.reverseGeocodeLocation(location) { placemarks, _ in
//            if let place = placemarks?.first {
//                let description = "Fake visit: \(place)"
//
//
//            }
//        }
    }
}


class LocationManager: NSObject {
    
    
    let manager = CLLocationManager()
    
    var current:CLLocation?


    private static var sharedLocationManager: LocationManager = {
        let locationManager = LocationManager()
        return locationManager
    }()
    
    private override init() {
        
    }
    class func shared() -> LocationManager {
        return sharedLocationManager
    }
    
    
    func startLocationTracking () {
        manager.requestAlwaysAuthorization()
        
        
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        manager.delegate = self

        manager.startUpdatingLocation()
        manager.requestLocation()

    }
    

}
