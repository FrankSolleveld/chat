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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // MARK: - TODO: Handle completion handler for Notifications
        }

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func addRegion(_ sender: UILongPressGestureRecognizer) {
        let touchLocation = sender.location(in: mapView)
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "geoRegion")
        mapView.removeOverlays(mapView.overlays)
        locationManager.startMonitoring(for: region)
        let circle = MKCircle(center: coordinate, radius: region.radius)
        mapView.addOverlay(circle)
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
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert(title: K.GeoFence.geoAlertExitTitle, message: K.GeoFence.geoAlertExitBody)
        showNotification(title: K.GeoFence.geoAlertExitTitle, message: K.GeoFence.geoAlertExitBody)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let circleOverlay = overlay as? MKCircle else { return MKOverlayRenderer() }
        
         // This renders the selected region for the GeoFence on the map.
        let circleRenderer = MKCircleRenderer(circle: circleOverlay)
        circleRenderer.strokeColor = .red
        circleRenderer.fillColor = .red
        circleRenderer.alpha = 0.5
        
        return circleRenderer
    }
}
