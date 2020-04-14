//
//  Geo.swift
//  GeoChat
//
//  Created by Frank Solleveld on 14/04/2020.
//

import UIKit

struct Geo {
    static var isInRegion = false
    
     func showNotification(title: String, message: String){
           let content = UNMutableNotificationContent()
           content.title = title
           content.body = message
           content.badge = 1
           content.sound = .default
           
           let request = UNNotificationRequest(identifier: "geoNotification", content: content, trigger: nil)
           UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
       }
}
