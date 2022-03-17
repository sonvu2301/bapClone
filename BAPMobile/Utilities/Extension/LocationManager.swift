//
//  LocationManager.swift
//  BAPMobile
//
//  Created by Dang nhu phuc on 16/03/2022.
//

import Foundation
import CoreLocation
extension CLLocationManager{
    func getCurrentLocation() -> MapLocation {
        var current = MapLocation(lng: 0, lat: 0)
        self.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = self.location else {
                return MapLocation(lng: 0, lat: 0)
            }
            
            current = MapLocation(lng: currentLocation.coordinate.longitude,
                                  lat: currentLocation.coordinate.latitude)
        }
        return current
    }
}
