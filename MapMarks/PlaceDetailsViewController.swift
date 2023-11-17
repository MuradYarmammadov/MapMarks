//
//  PlaceDetailsViewController.swift
//  MapMarks
//
//  Created by Murad Yarmamedov on 09.11.23.
//

import UIKit
import MapKit
import Parse

class PlaceDetailsViewController: UIViewController {
    
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsPlaceName: UILabel!
    @IBOutlet weak var detailsPlaceType: UILabel!
    @IBOutlet weak var detailsPlaceDescription: UILabel!
    @IBOutlet weak var seeLocationLabel: UILabel!
    
    var chosenPlaceId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    var placeName = ""
    var placeSubtitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        getDataFromParse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getDataFromParse), name: NSNotification.Name("newPlace"), object: nil)
    }
    
    private func setUI(){
        seeLocationLabel.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(seeLocationTapped))
        seeLocationLabel.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func seeLocationTapped(){
        performSegue(withIdentifier: "fromDetailstoMap", sender: nil)
    }
    
    @objc func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.whereKey("objectId", equalTo: chosenPlaceId)
        query.findObjectsInBackground { objects, error in
            if let error = error {
                self.makeAlert(title: "Error", message: error.localizedDescription)
            } else if let objects = objects {
                let chosenPlaceObject = objects[0]
                
                if let placeName = chosenPlaceObject.object(forKey: "name") as? String {
                    self.detailsPlaceName.text = placeName
                    self.placeName = placeName
                }
                
                if let placeType = chosenPlaceObject.object(forKey: "type") as? String {
                    self.detailsPlaceType.text = placeType
                    self.placeSubtitle = placeType
                }
                
                if let placeDescription = chosenPlaceObject.object(forKey: "description") as? String {
                    self.detailsPlaceDescription.text = placeDescription
                }
                
                if let placeLatitude = chosenPlaceObject.object(forKey: "latitude") as? String {
                    if let placeLatitudeDouble = Double(placeLatitude) {
                        self.chosenLatitude = placeLatitudeDouble
                    }
                }
                
                if let placeLongitude = chosenPlaceObject.object(forKey: "longitude") as? String {
                    if let placeLongitudeDouble = Double(placeLongitude) {
                        self.chosenLongitude = placeLongitudeDouble
                    }
                }
                
                if let imageData = chosenPlaceObject.object(forKey: "image") as? PFFileObject {
                    imageData.getDataInBackground { data, error in
                        if let data = data {
                            self.detailsImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromDetailstoMap" {
            let destinationVC = segue.destination as! SelectedMapViewController
            destinationVC.chosenLatitude = self.chosenLatitude
            destinationVC.chosenLongitude = self.chosenLongitude
            destinationVC.placeName = self.placeName
            destinationVC.placeSubtitle = self.placeSubtitle
        }
    }
    
    func makeAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}


