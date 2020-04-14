//
//  Geo.swift
//  GeoChat
//
//  Created by Frank Solleveld on 14/04/2020.
//

import UIKit
import CoreLocation

struct Geo {
    static var isInRegion = false
    private let defaults = UserDefaults.standard
    
    func showNotification(title: String, message: String){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = message
        content.badge = 1
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "geoNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func saveCoordinates(_ coordinate: CLLocationCoordinate2D){
        let lat = Double(coordinate.latitude)
        let long = Double(coordinate.longitude)
        
        defaults.set(lat, forKey: K.GeoFence.defaultsLatKey)
        defaults.set(long, forKey: K.GeoFence.defaultsLongKey)
    }  
}
