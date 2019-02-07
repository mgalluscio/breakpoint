//
//  AuthService.swift
//  breakpoint
//
//  Created by Mario Galluscio on 1/31/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    // singleton
    static let instance = AuthService()
    
    // registers user, completion handler to know when done. Completion handler has status to tell when done and error if necessary (nil, may or may not have an error). Finally, adds user to db with createDBUser from DataService
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool,_ error: Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user?.user else {
                userCreationComplete(false, error)
                return
            }
            
            let userData = ["provider": user.providerID, "email": user.email]
            DataService.instance.createDBUser(uid: user.uid, userData: userData as Dictionary<String, Any>)
            userCreationComplete(true, nil)
        }
    }
    
    // logs in user with email and password. Completion handler to tell when login is complete with staus and error.
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool,_ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                loginComplete(false, error)
                return
            }
            loginComplete(true, nil)
        }
    }
}
