//
//  DataService.swift
//  breakpoint
//
//  Created by Mario Galluscio on 1/29/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import Foundation
import Firebase

// DB base constant
let DB_BASE = Database.database().reference()

class DataService {
    // singleton
    static let instance = DataService()
    
    // private variables to only be accessed by the class
    // returns db path for the relative path specified
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    // public variables to access private vars
    // DatabaseReference represents a location in the firebase db for reading/writing
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        return _REF_FEED
    }
    
    /*
     Creates db user in "user" path. Function takes a user ID (uid) and userData as a dictionary.
     Function creates db record as uid with userData information.
     
     users
        |
        uid
            |
            "email":"test@test.com"
            "name":"Test Test"
    */
    func createDBUser(uid: String, userData: Dictionary<String, Any>) {
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
}
