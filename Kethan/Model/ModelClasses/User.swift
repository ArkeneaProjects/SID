//
//  User.swift
//  Kethan
//
//  Created by Apple on 13/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var userId: String = ""
    var email: String = ""
    var accesstoken: String = ""
    var contactNumber: String = ""
    var profession: String = ""
    var name: String = ""
    var country_code: String = ""
    var isSocialMediaUser: String = "" //O for SignUp user, 1 for Facebook, 2 for Google
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.userId = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.userId)
        self.email = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.email)
        self.accesstoken = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.accesstoken)
        self.isSocialMediaUser = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.isSocialMediaUser)
        self.name = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.name)
        self.profession = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.profession)
        self.country_code = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.countryCode)

    }
    
    func dictioary() -> NSDictionary {
        let dictionary: NSDictionary = [
            ENTITIES.userId: self.userId,
            ENTITIES.email: self.email,
            ENTITIES.accesstoken: self.accesstoken,
            ENTITIES.isSocialMediaUser: self.isSocialMediaUser,
            ENTITIES.profession: self.profession,
            ENTITIES.name: self.name,
            ENTITIES.countryCode: self.country_code
        ]
        return dictionary
    }
}
