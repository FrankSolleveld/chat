//
//  MapViewController.swift
//  GeoChat
//
//  Created by Frank Solleveld on 13/04/2020.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    // MARK: - @IBOutlets
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    var isInRegion = false
    let feedbackGenerator = UISelectionFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("[MapViewController] UNUserNotificationCenter: User granted permission.")
            } else if let err = error {
                print("[MapViewController] UNUserNotificationCenter: An error occured \(err)")
            }
        }
        
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        checkForCoordinates()
    }
    
    @IBAction func addRegion(_ sender: UILongPressGestureRecognizer) {
        let touchLocation = sender.location(in: mapView)
        
        // Converts user touch location to coordinates
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        saveCoordinates(coordinate)
        
        let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "geoRegion")
        isUserInRegion(region)
        mapView.removeOverlays(mapView.overlays)
        locationManager.startMonitoring(for: region)
        
        let circle = MKCircle(center: coordinate, radius: region.radius)
        mapView.addOverlay(circle)
        
        // This provides the user with haptic feedback to indicate a change in the selection of the region.
        feedbackGenerator.selectionChanged()
    }
    
    // Method that shows alert when going in/out the specific region.
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
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
    
    func checkForCoordinates() {
        let lat = defaults.double(forKey: K.GeoFence.defaultsLatKey)
        let long = defaults.double(forKey: K.GeoFence.defaultsLongKey)
        
        let coordinates = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = CLCircularRegion(center: coordinates, radius: 200, identifier: "geoRegion")
        mapView.removeOverlays(mapView.overlays)
        locationManager.startMonitoring(for: region)
        
        let circle = MKCircle(center: coordinates, radius: region.radius)
        mapView.addOverlay(circle)
        isUserInRegion(region)
    }
    
    func isUserInRegion(_ region: CLCircularRegion) {
        if let coordinates = locationManager.location?.coordinate {
           isInRegion = region.contains(coordinates)
            defaults.set(isInRegion, forKey: K.GeoFence.isInRegionKey)
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Simply shows user location.
        locationManager.stopUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert(title: K.GeoFence.geoAlertEnteredTitle , message: K.GeoFence.geoAlertEnteredBody)
        showNotification(title: K.GeoFence.geoAlertEnteredTitle, message: K.GeoFence.geoAlertEnteredBody)
        isInRegion = false
        defaults.set(isInRegion, forKey: K.GeoFence.isInRegionKey)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert(title: K.GeoFence.geoAlertExitTitle, message: K.GeoFence.geoAlertExitBody)
        showNotification(title: K.GeoFence.geoAlertExitTitle, message: K.GeoFence.geoAlertExitBody)
        isInRegion = true
        defaults.set(isInRegion, forKey: K.GeoFence.isInRegionKey)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
        
         // This renders the selected region for the GeoFence on the map.
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.fillColor = UIColor(named: "GreenColor")
        circleRenderer.alpha = 0.5
        
        return circleRenderer
    }
}
