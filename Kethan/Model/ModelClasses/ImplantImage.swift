//
//  ImplantImage.swift
//  Kethan
//
//  Created by Ashwini on 02/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class ImplantImage: NSObject {
    var imageWidth: String = ""
    var imageHeight: String = ""
    var labelWidth: String = ""
    var labelHeight: String = ""
    var labelOffsetX: String = ""
    var labelOffsetY: String = ""
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.imageWidth = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.imageWidth)
        self.imageHeight = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.imageHeight)
        self.labelWidth = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.labelWidth)
        self.labelOffsetY = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.labelOffsetY)
        self.labelOffsetX = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.labelOffsetX)
    }
    
    func dictioary() -> NSDictionary {
        let dictionary: NSDictionary = [
            ENTITIES.imageWidth: self.imageWidth,
            ENTITIES.imageHeight: self.imageHeight,
            ENTITIES.labelWidth: self.labelWidth,
            ENTITIES.labelOffsetX: self.labelOffsetX,
            ENTITIES.labelOffsetY: self.labelOffsetY,
        ]
        return dictionary
    }
}
