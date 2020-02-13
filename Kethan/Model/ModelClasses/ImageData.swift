//
//  ImageData.swift
//  Kethan
//
//  Created by Sunil on 31/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class ImageData: NSObject, NSCopying {
    
    var createdDate: String = ""
    @objc var id: String = ""
    var isApproved: String = ""
    var isRejected: String = ""

    var userId: String = ""
    
    var imageName: String = ""
    var watsonImage_id: String = ""
    var objectLocation: ObjectLocation = ObjectLocation()
    var image: UIImage?
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.imageName = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.imageName)
        self.watsonImage_id = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.watsonImage_id)
        self.createdDate = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.createdDate)
        self.id = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.id)
        self.isApproved = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.isApproved)
        self.isRejected = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.isRejected)
        self.userId = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.userId)
        if let dict = dictionary.value(forKey: ENTITIES.imageObjective) as? NSDictionary {
            self.objectLocation = ObjectLocation(dictionary: dict)
        }
        
    }
    
    func dictioary() -> NSDictionary {
        let dictionary: NSDictionary = [
            ENTITIES.imageName: self.imageName,
            ENTITIES.watsonImage_id: self.watsonImage_id,
            ENTITIES.createdDate: self.createdDate,
            ENTITIES.id: self.id,
            ENTITIES.isApproved: (self.isApproved == "" || self.isApproved == "0") ?false:true,
            ENTITIES.isRejected: (self.isRejected == "" || self.isRejected == "0") ?false:true,
            ENTITIES.userId: self.userId,
            ENTITIES.objectLocation: self.objectLocation.dictioary()
        ]
        return dictionary
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy: ImageData = ImageData()
        copy.imageName = self.imageName
        copy.watsonImage_id = self.watsonImage_id
        copy.createdDate = self.createdDate
        copy.id = self.id
        copy.isApproved = self.isApproved
        copy.isRejected = self.isRejected
        copy.userId = self.userId
        copy.objectLocation = self.objectLocation
        return copy
        
    }
}
