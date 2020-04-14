//
//  LocationManager.swift
//  GeoChat
//
//  Created by Frank Solleveld on 14/04/2020.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    var region = CLCircularRegion()
    var isInRegion = false
    let defaults = UserDefaults.standard
    
    static let shared = LocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func monitor(for region: CLCircularRegion){
        self.region = region
        locationManager.startMonitoring(for: region)
    }
    
    func isUserInRegion(_ region: CLCircularRegion) {
        if let coordinates = locationManager.location?.coordinate {
            isInRegion = region.contains(coordinates)
            defaults.set(isInRegion, forKey: K.GeoFence.isInRegionKey)
        }
    }
    
    // MARK: - Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Simply shows user location.
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let geo = Geo()
        geo.showNotification(title: K.GeoFence.geoAlertEnteredTitle, message: K.GeoFence.geoAlertEnteredBody)
        let isInRegion = true
        UserDefaults.standard.set(isInRegion, forKey: K.GeoFence.isInRegionKey)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let geo = Geo()
        geo.showNotification(title: K.GeoFence.geoAlertExitTitle, message: K.GeoFence.geoAlertExitBody)
        let isInRegion = false
        UserDefaults.standard.set(isInRegion, forKey: K.GeoFence.isInRegionKey)
    }
}
