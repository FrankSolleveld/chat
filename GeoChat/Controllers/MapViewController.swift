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
    
    let defaults = UserDefaults.standard
    let feedbackGenerator = UISelectionFeedbackGenerator()
    let region = CLCircularRegion()
    let geo = Geo()
    let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkForCoordinates()
        mapView.showsUserLocation = true
    }
    
    @IBAction func addRegion(_ sender: UILongPressGestureRecognizer) {
        let touchLocation = sender.location(in: mapView)
        
        // Converts user touch location to coordinates
        let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        saveCoordinates(coordinate)
        
        let region = CLCircularRegion(center: coordinate, radius: 200, identifier: "geoRegion")
        locationManager.isUserInRegion(region)
        mapView.removeOverlays(mapView.overlays)
        locationManager.monitor(for: region)
        
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
        locationManager.monitor(for: region)
        let circle = MKCircle(center: coordinates, radius: region.radius)
        mapView.addOverlay(circle)
        locationManager.isUserInRegion(region)
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
