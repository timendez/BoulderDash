//
//  User.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 2/17/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import Foundation

struct User {
    var firstName: String
    var lastName: String
    var id: String
    var level: Int
    var exp: Int
    
    init(firstName: String, lastName: String, id: String, level: Int, exp: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.level = level
        self.exp = exp
    }
}