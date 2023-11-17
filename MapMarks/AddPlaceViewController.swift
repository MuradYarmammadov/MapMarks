//
//  addPlacesViewController.swift
//  MapMarks
//
//  Created by Murad Yarmamedov on 09.11.23.
//

import UIKit

class AddPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeTypeTextField: UITextField!
    @IBOutlet weak var placeDescriptionTextField: UITextField!
    @IBOutlet weak var selectPhotoImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    private func setUI(){
        self.title = "MapMarks"

        selectPhotoImageView.isUserInteractionEnabled = true
        let selectImageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        selectPhotoImageView.addGestureRecognizer(selectImageGestureRecognizer)
    }
    
    @IBAction func nextButtonAction(_ sender: Any) {
        
        if placeNameTextField.text != "" && placeTypeTextField.text != "" && placeDescriptionTextField.text != "" {
            if let chosenImage = selectPhotoImageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameTextField.text!
                placeModel.placeType = placeTypeTextField.text!
                placeModel.placeDescription = placeDescriptionTextField.text!
                placeModel.placeImage = chosenImage
                
                self.performSegue(withIdentifier: "toMapPage", sender: nil)
            }
        } else {
            self.makeAlert(title: "Error", message: "Enter all information")
        }
    }
    
    @objc func imageTapped(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectPhotoImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    func makeAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}
