//
//  LoginPageViewController.swift
//  MapMarks
//
//  Created by Murad Yarmamedov on 07.11.23.
//
import UIKit
import Parse

class LoginPageViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var createNewAccountLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    func setUI(){
        
        passwordTextField.textContentType = .init(rawValue: "")
        
        forgotPasswordLabel.isUserInteractionEnabled = true
        let resetPasswordGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        forgotPasswordLabel.addGestureRecognizer(resetPasswordGestureRecognizer)
        
        createNewAccountLabel.isUserInteractionEnabled = true
        let createAccountGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(createAccountTapped))
        createNewAccountLabel.addGestureRecognizer(createAccountGestureRecognizer)
    }
    
    @objc func forgotPasswordTapped() {
        performSegue(withIdentifier: "toForgotPassword", sender: nil)
    }
    
    @objc func createAccountTapped() {
        performSegue(withIdentifier: "toRegisterPage", sender: nil)
    }

    @IBAction func loginButtonAction(_ sender: UIButton) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            makeAlert(title: "Error", message: "Email or Password is empty")
        } else {
            PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!) { user, error in
                if let error = error {
                    self.makeAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.makeAlert(title: "Success", message: "Login Successfully") { _ in
                        self.performSegue(withIdentifier: "toPlacesPage", sender: nil)
                    }
                }
            }
        }
    }
    
    func makeAlert(title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: handler)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    

}
