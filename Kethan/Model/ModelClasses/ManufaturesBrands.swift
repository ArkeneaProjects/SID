//
//  ManufaturesBrands.swift
//  Kethan
//
//  Created by Apple on 14/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class ManufaturesBrands: NSObject {
    var _id: String = ""
    var implantManufacture: String = ""
    @objc var brand = NSMutableArray()
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self._id = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES._id)
        self.implantManufacture = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.implantManufacture).capitalizingFirstLetter()
        if let arrBrandName = dictionary.value(forKey: ENTITIES.brand) as? [NSString] {
            self.brand = NSMutableArray(array: arrBrandName)
        }
    }
       
       func dictioary() -> NSDictionary {
           let dictionary: NSDictionary = [
               "_id": self._id,
               ENTITIES.implantManufacture: self.implantManufacture,
               ENTITIES.brand: self.brand
           ]
           return dictionary
       }
}
