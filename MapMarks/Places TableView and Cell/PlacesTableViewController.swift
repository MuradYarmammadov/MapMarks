//
//  PlacesViewController.swift
//  MapMarks
//
//  Created by Murad Yarmamedov on 08.11.23.
//

import UIKit
import Parse

class PlacesTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var placesNamesArray = [String]()
    var placesTypesArray = [String]()
    var placesIdArray = [String]()
    var placeImageArray = [UIImage]()
    var selectedPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTableView()
        getDataFromParse()
    }
    
    private func setUI(){
        self.title = "MapMarks"
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonTapped))
        
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonTapped))
    }
    
    private func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if let error = error {
                self.makeAlert(title: "Error", message: error.localizedDescription)
            } else if let objects = objects {
                
                self.placesIdArray.removeAll()
                self.placesNamesArray.removeAll()
                self.placesTypesArray.removeAll()
                self.placeImageArray.removeAll()
                
                for object in objects {
                    if let placeName = object.object(forKey: "name") as? String {
                        if let placesType = object.object(forKey: "type") as? String {
                            if let placesId = object.objectId {
                                if let placesImage = object.object(forKey: "image") as? PFFileObject {
                                    placesImage.getDataInBackground { data, error in
                                        if error == nil {
                                            if data != nil {
                                                let image = UIImage(data: data!)
                                                self.placeImageArray.append(image!)
                                                self.placesIdArray.append(placesId)
                                                self.placesNamesArray.append(placeName)
                                                self.placesTypesArray.append(placesType)
                                                
                                                DispatchQueue.main.async {
                                                    self.tableView.reloadData()
                                                }
                                            }

                                        }
                                    }
                                }

                            }
                        }
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func addButtonTapped() {
        self.performSegue(withIdentifier: "toAddPlacePage", sender: nil)
    }
    
    @objc func logoutButtonTapped(){
        PFUser.logOutInBackground { error in
            if let error = error {
                self.makeAlert(title: "Error", message: error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "toLoginPage", sender: nil)
            }
        }
    }
    
    func makeAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsPage"{
            let destinationVC = segue.destination as! PlaceDetailsViewController
            destinationVC.chosenPlaceId = selectedPlaceId
        }
        
    }
}

extension PlacesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlacesTableViewCell
        
        cell.placeName.text = placesNamesArray[indexPath.row]
        cell.placeType.text = placesTypesArray[indexPath.row]
        cell.placeImage.image = placeImageArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placesIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsPage", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
}
