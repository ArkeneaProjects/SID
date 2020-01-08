//
//  ObjectLocation.swift
//  Kethan
//
//  Created by Sunil on 31/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class ObjectLocation: NSObject {
    
    var top: String = ""
    var left: String = ""
    var width: String = ""
    var height: String = ""
    
    var imageHeight: String = ""
    var imageWidth: String = ""
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.top = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.top)
        self.left = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.left)
        self.width = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.width)
        self.height = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.height)
        self.imageWidth = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.imageWidth)
        self.imageHeight = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.imageHeight)
    }
    
    func dictioary() -> NSDictionary {
        let dictionary: NSDictionary = [
            ENTITIES.top: self.top,
            ENTITIES.left: self.left,
            ENTITIES.width: self.width,
            ENTITIES.height: self.height,
            ENTITIES.imageWidth: self.imageWidth,
            ENTITIES.imageHeight: self.imageHeight
        ]
        return dictionary
    }
}
