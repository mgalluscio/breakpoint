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
    
    // takes query and returns array of emails contain that query (typed email) through escaping closure
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
    
    // function gets IDs for passed username. Returns array of ids through escaping closure.
    func getIds(forUsername username: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        // array to be returned
        var idArray = [String]()
        // observes all users once, create array with data, loop over it and append ids to array
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if username.contains(email) {
                    idArray.append(user.key)
                }
            }
            // return list through closure
            handler(idArray)
        }
    }
    
    // function takes a group as a parameter and returns a list through a escaping closure of each members email
    func getEmailsFor(group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        // array to hold member emails
        var emailArray = [String]()
        // observe once
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            // create userSnapshot list of type DataSnapshot
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            // iterate through list
            for user in userSnapshot {
                // if group members list contains user.key in snapshot append to emailArray
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            // return list of emails
            handler(emailArray)
        }
    }
    
    // function takes title, description and array of userIds and creates group in db
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        handler(true)
    }
    
    // function returns groups from db through escaping closure
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        // create array of type Group to hold returned groups
        var groupsArray = [Group]()
        // observe single event (only called once)
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            // create array to hold returned data
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            // iterate over array to pull out data
            for group in groupSnapshot {
                // array to hold memeber ids
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                // we only want groups that we're a part of
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    // grab title, description and create data structure
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    let group = Group(title: title, description: description, key: group.key, members: memberArray, memberCount: memberArray.count)
                    // append created group to groupsArray
                    groupsArray.append(group)
                }
            }
            // return groupsArray
            handler(groupsArray)
        }
    }
    
}
