//
//  Implant.swift
//  Kethan
//
//  Created by Ashwini on 31/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class Implant: NSObject {
    var imagesArray: NSMutableArray = NSMutableArray()
    var processArray: NSMutableArray = NSMutableArray()
    var location: String = ""
    var manufacturer: String = ""
    var implantName: String = ""
    var surgeryDate: String = ""
    var isEditMode:Bool = false
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.imagesArray = NSMutableArray()
        if let images = dictionary.object(forKey: ENTITIES.imagesArray) as? NSArray {
            for image in images {
                self.imagesArray.add(image)
            }
        }
        
        self.processArray = NSMutableArray()
        if let processes = dictionary.object(forKey: ENTITIES.processArray) as? NSArray {
            for process in processes {
                self.processArray.add(process)
            }
        }
        
        self.location = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.location)
        self.manufacturer = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.manufacturer)
        self.implantName = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.implantName)
        self.surgeryDate = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.surgeryDate)
    }
    
    func dictioary() -> NSDictionary {
        let dictionary: NSDictionary = [
            ENTITIES.processArray: self.processArray,
            ENTITIES.imagesArray: self.imagesArray,
            ENTITIES.location: self.location,
            ENTITIES.manufacturer: self.manufacturer,
            ENTITIES.implantName: self.implantName,
            ENTITIES.surgeryDate: self.surgeryDate,
            ENTITIES.isEditMode: self.isEditMode
        ]
        return dictionary
    }
}
