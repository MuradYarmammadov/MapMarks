//
//  SelectedMapViewController.swift
//  MapMarks
//
//  Created by Murad Yarmamedov on 13.11.23.
//

import UIKit
import MapKit

class SelectedMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var selectedMapView: MKMapView!
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    let placeDetailsVC = PlaceDetailsViewController()
    var placeName = ""
    var placeSubtitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMapView()
        getMapLocation(latitude: chosenLatitude, longitude: chosenLongitude, title: placeName, subtitle: placeSubtitle)
    }
    
    
    func setMapView(){
        self.selectedMapView.delegate = self
        
        let location = CLLocationCoordinate2D(latitude: chosenLatitude, longitude: chosenLongitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let region = MKCoordinateRegion(center: location, span: span)
        self.selectedMapView.setRegion(region, animated: true)
    }
    
    func getMapLocation(latitude: Double, longitude: Double, title: String, subtitle: String) {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        let region = MKCoordinateRegion(center: location, span: span)
        self.selectedMapView.setRegion(region, animated: true)
        
        let annotaion = MKPointAnnotation()
        annotaion.coordinate = location
        annotaion.title = title
        annotaion.subtitle = subtitle
        self.selectedMapView.addAnnotation(annotaion)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "id"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLatitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: chosenLatitude, longitude: chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placeMarks, error in
                if let placeMarks = placeMarks {
                    let mkPlaceMark = MKPlacemark(placemark: placeMarks[0])
                    let mapItem = MKMapItem(placemark: mkPlaceMark)
                    mapItem.name = self.placeName
                    
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
                    mapItem.openInMaps(launchOptions: launchOptions)
                }
            }
        }
    }
    
}
