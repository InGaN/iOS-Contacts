//
//  RandomUser.swift
//  Contacts
//
//  Created by Kevin van der Vleuten on 02/11/15.
//  Copyright © 2015 Kevin van der Vleuten. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RandomUser {
    var gender: String?
    var title: String?
    var first: String?
    var last: String?
    var street: String?
    var city: String?
    var state: String?
    var zip: String?
    var email: String?
    var username: String?
    var password: String?
    var salt: String?
    var md5: String?
    var sha1: String?
    var sha256: String?
    var registered: String?
    var dob: String?
    var phone: String?
    var cell: String?
    
    var image: String?
    var thumb: String?
    var nationality: String?
    
    init (gender: String, title: String, first: String, last: String, street: String, city: String, state: String, zip: String,
        email: String, username: String, password: String, salt: String, md5: String, sha1: String, sha256: String,
        dob: String, phone: String, cell: String, image: String, thumb: String, nationality: String) {
            self.gender = gender;
            self.title = title;
            self.first = first;
            self.last = last;
            self.street = street;
            self.city = city;
            self.state = state;
            self.zip = zip;
            self.email = email;
            self.username = username;
            self.password = password;
            self.salt = salt;
            self.md5 = md5
            self.sha1 = sha1;
            self.sha256 = sha256
            self.dob = dob;
            self.phone = phone;
            self.cell = cell;
            self.image = image;
            self.thumb = thumb;
            self.nationality = nationality;
    }
}