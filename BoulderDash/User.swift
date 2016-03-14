//
//  User.swift
//  BoulderDash
//
//  Created by Classroom Tech User on 2/17/16.
//  Copyright © 2016 Matt&Tim. All rights reserved.
//

import Foundation
import UIKit

class User {
    var firstName: String
    var lastName: String
    var id: String
    var level: Int
    var exp: Int
    var image: UIImage
    
    var friends: [JSON]?
    
    init(firstName: String, lastName: String, id: String, image: UIImage) {
        self.firstName = firstName
        self.lastName = lastName
        self.id = id
        self.level = -1
        self.exp = -1
        self.image = image
        
        self.friends = []
    }
}