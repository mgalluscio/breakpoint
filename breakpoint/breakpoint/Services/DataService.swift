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
    
    // uploads posts to db, takes message, user ID and group ID. If group ID exists, send to group ref, else post to feed.
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()) {
        if groupKey != nil {
            // send to groups ref
        } else {
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
    }
    
    // gets all messages from feed table in db
    // escaping closure allows us to pass the returned data outside the closure
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
        // array to hold all messages (of type Message)
        var messageArray = [Message]()
        // OBSERVES all messages from feed
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
            // safely create array of ALL of objects as type DataSnapshot. Otherwise, return.
            guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            // iterate over feedMessageSnapshot and append  initalized message object to messageArray
            for message in feedMessageSnapshot {
                // childsnapshots are used to pull out data from DataSnapshot
                let content = message.childSnapshot(forPath: "content").value as! String
                let senderId = message.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                messageArray.append(message)
            }
            // return messageArray :)
            handler(messageArray)
        }
    }
    
    // function passes userid and returns email as string for that user
    func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        // only want to observe once (singleEvent)
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            // get all objects as array of type DataSnapshot. Else, just return
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            // loop over userSnapshot array. If user.key equals uid passsed return email as string.
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
    }
    
    // takes query and returns array of emails contain that query through escaping closure
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        // array we are going to return
        var emailArray = [String]()
        // observe all values in REF_USERS
        REF_USERS.observe(.value) { (UserSnapshot) in
            // create array called userSnapshot with all children objects (contains emails)
            guard let userSnapshot = UserSnapshot.children.allObjects as? [DataSnapshot] else { return }
            // loop over userSnapshot array, save email as constant
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                // if email contains query AND email isn't user's append to emailArray
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    emailArray.append(email)
                }
            }
            // return list through closure
            handler(emailArray)
        }
    }
    
    func getIds(forUsername username: String, handler: @escaping (_ uidArray: [String]) -> ()) {
        var idArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if username.contains(email) {
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
    }
    
}
