//
//  RegisterPageViewController.swift
//  MapMarks
//
//  Created by Murad Yarmamedov on 07.11.23.
//

import UIKit
import Parse

class RegisterPageViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    
    private func setUI(){
        passwordTextField.textContentType = .init(rawValue: "")
        
        
        loginLabel.isUserInteractionEnabled = true
        let resetPasswordGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped))
        loginLabel.addGestureRecognizer(resetPasswordGestureRecognizer)
    }
    
    @objc func loginLabelTapped(){
        performSegue(withIdentifier: "toLoginPage", sender: nil)
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        
        if nameTextField.text == "" ||
            emailTextField.text == "" ||
            passwordTextField.text == "" ||
            confirmPasswordTextField.text == "" {
            makeAlert(title: "Error", message: "You should enter all information")
        } else {
            let validPassword = validpassword(mypassword: passwordTextField.text!)
            if validPassword == false {
                makeAlert(title: "Error", message: "Pasword must include: at least one uppercase, one digit, one lowercase, one symbol, min 8 characters total")
            } else{
                if passwordTextField.text == confirmPasswordTextField.text{
                    let user = PFUser()
                    user.username = nameTextField.text
                    user.email = emailTextField.text
                    user.password = passwordTextField.text
                    user.signUpInBackground { success, error in
                        if let error = error {
                            self.makeAlert(title: "Error", message: error.localizedDescription)
                        } else {
                            self.makeAlert(title: "Success", message: "Account is created successfully") { _ in
                                self.performSegue(withIdentifier: "toLoginPage", sender: nil)
                            }
                        }
                    }
                } else {
                    makeAlert(title: "Error", message: "Passwords didn't matched")
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
    
    func validpassword(mypassword : String) -> Bool
        {
            let passwordreg =  ("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[@#$%^&*]).{8,}")
            let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
            return passwordtesting.evaluate(with: mypassword)
        }
}
