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
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.removalProcess = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.removalProcess)
        self.surgeryDate = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.surgeryDate)
        self.surgeryLocation = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.surgeryLocation)
    
    }
    
    func dictioary() -> NSDictionary {
        let dictionary: NSDictionary = [
            ENTITIES.removalProcess: self.removalProcess,
            ENTITIES.surgeryDate: self.surgeryDate,
            ENTITIES.surgeryLocation: self.surgeryLocation
        ]
        return dictionary
    }
}
