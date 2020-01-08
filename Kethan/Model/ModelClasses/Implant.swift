//
//  Implant.swift
//  Kethan
//
//  Created by Sunil on 31/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class Implant: NSObject {
    
    var removalProcess: String = ""
    var surgeryDate: String = ""
    var surgeryLocation: String = ""
    @objc var createdDate: String = ""
    var id: String = ""
    var isApproved: String = ""
    var userId: String = ""
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.removalProcess = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.removalProcess)
        self.surgeryDate = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.surgeryDate)
        self.surgeryLocation = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.surgeryLocation)
        self.createdDate = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.createdDate)
        self.id = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.id)
        self.isApproved = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.isApproved)
        self.userId = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.userId)
    }
    
    func dictioary() -> NSDictionary {
        let dictionary: NSDictionary = [
            ENTITIES.removalProcess: self.removalProcess,
            ENTITIES.surgeryDate: self.surgeryDate,
            ENTITIES.surgeryLocation: self.surgeryLocation,
            ENTITIES.createdDate: self.createdDate,
            ENTITIES.id: self.id,
            ENTITIES.isApproved: self.isApproved,
            ENTITIES.userId: self.userId
        ]
        return dictionary
    }
}
