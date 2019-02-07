//
//  AuthVC.swift
//  breakpoint
//
//  Created by Mario Galluscio on 1/30/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
