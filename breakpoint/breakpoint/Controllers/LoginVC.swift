//
//  LoginVC.swift
//  breakpoint
//
//  Created by Mario Galluscio on 1/30/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var emailField: InsetTextField!
    @IBOutlet weak var passwordField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set delegates so we can access them, call functions, etc.
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    // function ran when signin button is pressed.
    @IBAction func signInBtnWasPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil {
            // New user, first login attempt fails and goes to register user. If account exists, logs in.
            AuthService.instance.loginUser(withEmail: emailField.text!, andPassword: passwordField.text!) { (success, error) in
                // executes when user already has account
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // no account
                    print(String(describing: error?.localizedDescription))
                }
                // called if user does/does not already have account, but will go to else block if account already exists.
                AuthService.instance.registerUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, userCreationComplete: { (success, error) in
                    // user is registered and logged in
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailField.text!, andPassword: self.passwordField.text!, loginComplete: { (success, nil) in
                            self.dismiss(animated: true, completion: nil)
                            print("Successfully registered and logged in user")
                        })
                    } else {
                        // user is logged in, not registered.
                        print(String(describing: error?.localizedDescription))
                    }
                })
            }
        }
    }
    
    // dismisses view controller when pressed
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// Conform to UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    
}
