//
//  ImplantImage.swift
//  Kethan
//
//  Created by Ashwini on 02/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class ImplantImage: NSObject {
    @objc var id = ""
    var imageWidth =  ""
    var imageHeight = ""
    var labelWidth = ""
    var labelHeight = ""
    var labelOffsetX = ""
    var labelOffsetY = ""
    var selectedImage: UIImage?
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.imageWidth = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.imageWidth)
        self.imageHeight = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.imageHeight)
        self.labelWidth = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.labelWidth)
        self.labelOffsetY = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.labelOffsetY)
        self.labelOffsetX = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.labelOffsetX)
        self.labelWidth = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.labelWidth)
        self.labelHeight = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.labelHeight)
    }
    
    func dictioary() -> NSDictionary {
        let dictionary: NSDictionary = [
            "id": self.id,
            ENTITIES.imageWidth: self.imageWidth,
            ENTITIES.imageHeight: self.imageHeight,
            ENTITIES.labelOffsetX: self.labelOffsetX,
            ENTITIES.labelOffsetY: self.labelOffsetY,
            ENTITIES.labelWidth: self.labelWidth,
            ENTITIES.labelHeight: self.labelHeight,
            ENTITIES.selectedImage: self.selectedImage!
        ]
        return dictionary
    }
}
