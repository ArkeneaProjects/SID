//
//  ImageData.swift
//  Kethan
//
//  Created by Sunil on 31/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class ImageData: NSObject {
    
    var imageName: String = ""
    var watsonImage_id: String = ""
    var objectLocation: ObjectLocation = ObjectLocation()
  
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.imageName = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.imageName)
        self.watsonImage_id = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.watsonImage_id)
        if let dict = dictionary.value(forKey: ENTITIES.objectLocation) as? NSDictionary {
            self.objectLocation = ObjectLocation(dictionary: dict)
        }

    }
    
    func dictioary() -> NSDictionary {
        let dictionary: NSDictionary = [
            ENTITIES.imageName: self.imageName,
            ENTITIES.watsonImage_id: self.watsonImage_id,
            ENTITIES.objectLocation: self.objectLocation.dictioary()
        ]
        return dictionary
    }
}

