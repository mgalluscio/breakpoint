//
//  MeVC.swift
//  breakpoint
//
//  Created by Mario Galluscio on 2/7/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // show users email
        self.emailLbl.text = Auth.auth().currentUser?.email
    }
    
    // called when signout button is pressed
    @IBAction func signOutBtnWasPressed(_ sender: Any) {
        // create nice popup
        let logoutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        // action that is called
        let logoutAction = UIAlertAction(title: "Logout?", style: .destructive) { (buttonTapped) in
            // logout
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        }
        // added and present popUp with action
        logoutPopup.addAction(logoutAction)
        present(logoutPopup, animated: true, completion: nil)
    }
}
