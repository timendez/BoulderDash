//
//  User.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 2/17/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import Foundation

class User {
    var firstName: String
    var lastName: String
    var id: String
    var level: Int
    var exp: Int
    
    var friends: [String]
    
    init(firstName: String, lastName: String, id: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.level = -1
        self.exp = -1
        
        self.friends = []
    }
}