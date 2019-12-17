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
    
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.userId = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.userId)
        self.email = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.email)
        self.accesstoken = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.accesstoken)
    }
    
    func dictioary() -> NSDictionary {
        let dictionary: NSDictionary = [
            ENTITIES.userId: self.userId,
            ENTITIES.email: self.email,
            ENTITIES.accesstoken: self.accesstoken
        ]
        return dictionary
    }
}
