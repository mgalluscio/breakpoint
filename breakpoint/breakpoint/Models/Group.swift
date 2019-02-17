//
//  Group.swift
//  breakpoint
//
//  Created by Mario Galluscio on 2/17/19.
//  Copyright © 2019 Mario Galluscio. All rights reserved.
//

import Foundation

class Group {
    // private class variables
    private var _groupTitle: String
    private var _groupDescription: String
    private var _key: String
    private var _memberCount: Int
    private var _members: [String]
    
    // public class variables
    var groupTitle: String {
        return _groupTitle
    }
    
    var groupDescription: String {
        return _groupDescription
    }
    
    var key: String {
        return _key
    }
    
    var memberCount: Int {
        return _memberCount
    }
    
    var memebers: [String] {
        return _members
    }
    
    // initialize it all
    init(title: String, description: String, key: String, members: [String], memberCount: Int) {
        self._groupTitle = title
        self._groupDescription = description
        self._key = key
        self._members = members
        self._memberCount = memberCount
    }
}
