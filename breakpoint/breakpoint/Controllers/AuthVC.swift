//
//  AuthVC.swift
//  breakpoint
//
//  Created by Mario Galluscio on 1/30/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // called when view DID appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // have to dismiss AuthVC when there is a current user. Otherwise, view gets stuck and must force close app to view feed.
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Present loginVC when email button is pressed. Function creates an instance of loginVC and presents it.
    @IBAction func signInWithEmailBtnWasPressed(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    @IBAction func googleSignInBtnWasPressed(_ sender: Any) {
    }
    @IBAction func facebookSignInBtnWasPressed(_ sender: Any) {
    }
}
