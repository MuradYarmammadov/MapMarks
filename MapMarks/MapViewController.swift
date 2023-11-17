//
//  MapViewController.swift
//  MapMarks
//
//  Created by Murad Yarmamedov on 09.11.23.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    let placeModel = PlaceModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setMapView()
    }
    
    private func setUI(){
        self.title = "MapMarks"
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonTapped))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelButtonTapped))
    }
    
    private func setMapView() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let mapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        mapGestureRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(mapGestureRecognizer)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func chooseLocation(gestureRecognizer: UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotaion = MKPointAnnotation()
            annotaion.coordinate = coordinates
            annotaion.title = PlaceModel.sharedInstance.placeName
            annotaion.subtitle = PlaceModel.sharedInstance.placeType
            self.mapView.addAnnotation(annotaion)
            
            placeModel.placeLatitude = String(coordinates.latitude)
            placeModel.placeLongitude = String(coordinates.longitude)
        }
    }
    
    @objc func saveButtonTapped(){

        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["description"] = placeModel.placeDescription
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude

        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5) {
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }

        object.saveInBackground { success, error in
            if let error = error {
                self.makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.makeAlert(title: "Success", message: "Data saved successfully") { _ in
                    self.performSegue(withIdentifier: "fromMapToTable", sender: nil)
                }
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newPlace"), object: nil)
    }
  
    @objc func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
}
