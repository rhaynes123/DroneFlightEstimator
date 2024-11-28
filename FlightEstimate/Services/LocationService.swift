//
//  LocationService.swift
//  FlightEstimate
//
//  Created by richard Haynes on 11/23/24.
//
import Foundation
import CoreLocation
final class LocationService : NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var location: CLLocation?
    private var manager : CLLocationManager = CLLocationManager()
    
    func checkAuthorization() {
        manager.delegate = self
        manager.startUpdatingLocation()
        manager.requestAlwaysAuthorization()
        switch manager.authorizationStatus {
        case .authorizedWhenInUse:
            print("Authorized")
            location = manager.location
        case .notDetermined:
            print("Not Determined")
            manager.requestWhenInUseAuthorization()
        case .denied:
            print("Denied")
        case .restricted:
            print("Restricted")
        case .authorizedAlways:
            print("Authorized Always")
            location = manager.location
            
        @unknown default:
        return
        }
        
    }
    
}
