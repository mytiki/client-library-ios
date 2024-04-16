/*
 * Copyright (c) TIKI Inc.
 * MIT license. See LICENSE file in root directory.
 */

import Foundation
import CoreLocation

public class LocationDataManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    public var locationManager = CLLocationManager()
    @Published public var authorizationStatus: CLAuthorizationStatus?

    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:  // Location services are available.
            authorizationStatus = .authorizedWhenInUse
            manager.requestAlwaysAuthorization()
            locationManager.requestLocation()
            break
        case .authorizedAlways:  // Location services are available.
            authorizationStatus = .authorizedAlways
            locationManager.requestLocation()
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.startUpdatingLocation()
            break
            
        case .restricted:  // Location services currently unavailable.
            authorizationStatus = .restricted
            break
            
        case .denied:  // Location services currently unavailable.
            authorizationStatus = .denied
            break
            
        case .notDetermined:        // Authorization not determined yet.
            authorizationStatus = .notDetermined
            manager.requestAlwaysAuthorization()
            manager.requestLocation()
            break
            
        default:
            break
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle location updates
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
    }
    
    
}

