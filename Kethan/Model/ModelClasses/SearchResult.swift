//
//  SearchResult.swift
//  Kethan
//
//  Created by Sunil on 31/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SearchResult: NSObject {
    
    var isApproved: String = ""
    var isRejected: String = ""
    var _id: String = ""
    var objectName: String = ""
    var implantManufacture: String = ""
    var removImplant = NSMutableArray()
    var imageData = [ImageData]()
    var watsonImage_id: String = ""
    var createdOn: String = "" //O for SignUp user, 1 for Facebook, 2 for Google
    var modifiedOn: String = ""
    var implantImage = ImplantImage()
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.isApproved = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.isApproved)
        self.isRejected = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.isRejected)
        self._id = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES._id)
        self.objectName = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.objectName)
        self.implantManufacture = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.implantManufacture)
      
        if let dictarr = dictionary.value(forKey: ENTITIES.imageData) as? [NSDictionary] {
            self.imageData = dictarr.map({ (dict) -> ImageData in
                return ImageData(dictionary: dict)
            })
        }
        
      if let dictarr = dictionary.value(forKey: ENTITIES.removImplant) as? [NSDictionary] {
              let arrImaplant  = dictarr.map({ (dict) -> Implant in
                     return Implant(dictionary: dict)
                 }) //as! [Implant]
          self.removImplant = NSMutableArray(array: arrImaplant)
             }
        
        self.watsonImage_id = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.watsonImage_id)
        self.createdOn = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.createdOn)
        self.modifiedOn = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.modifiedOn)

    }
    func getRemovalArray() -> NSArray {
        let implantdictarr = self.removImplant.map { (obj) -> NSDictionary in
            return (obj as! Implant).dictioary()
        }
        return implantdictarr as NSArray
    }
    func dictioary() -> NSDictionary {
        
        let imgdictarr = self.imageData.map { (obj) -> NSDictionary in
            return obj.dictioary()
        }
        let implantdictarr = self.removImplant.map { (obj) -> NSDictionary in
            return (obj as! Implant).dictioary()
        }
        let dictionary: NSDictionary = [
            ENTITIES.isApproved: self.isApproved,
            ENTITIES.isRejected: self.isRejected,
            ENTITIES._id: self._id,
            ENTITIES.objectName: self.objectName,
            ENTITIES.implantManufacture: self.implantManufacture,
            ENTITIES.removImplant: implantdictarr,
            ENTITIES.imageData: imgdictarr,
            ENTITIES.watsonImage_id: self.watsonImage_id,
            ENTITIES.createdOn: self.createdOn,
            ENTITIES.modifiedOn: self.modifiedOn,
            ENTITIES.implantImage: self.implantImage
        ]
        return dictionary
    }
}
