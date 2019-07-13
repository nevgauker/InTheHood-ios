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
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        // create CLLocation from the coordinates of CLVisit
        let clLocation = CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)
        
        // Get location description
        AppDelegate.geoCoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
            if let place = placemarks?.first {
                let description = "\(place)"
                self.newVisitReceived(visit, description: description)
            }
        }
    }
    
    func newVisitReceived(_ visit: CLVisit, description: String) {
        let location = Location(visit: visit, descriptionString: description)
        LocationsStorage.shared.saveLocationOnDisk(location)
    
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        AppDelegate.geoCoder.reverseGeocodeLocation(location) { placemarks, _ in
            if let place = placemarks?.first {
                let description = "Fake visit: \(place)"
                
               
            }
        }
    }
}


class LocationManager: NSObject {
    
    
    let manager = CLLocationManager()


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
        manager.startMonitoringVisits()
        manager.delegate = self

    }
    

}
