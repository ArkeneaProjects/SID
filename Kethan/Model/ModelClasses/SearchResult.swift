//
//  SearchResult.swift
//  Kethan
//
//  Created by Sunil on 31/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SearchResult: NSObject, NSCopying {
    
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
        
        //Sorted by Date
        self.imageData = self.imageData.sorted(by: { (obj1: Any, obj2: Any) -> Bool in
             let objImageData1 = obj1 as? ImageData ?? ImageData()
            let objImageData2 = obj2 as? ImageData ?? ImageData()
            let date1 = objImageData1.createdDate.convertStringToDate(actualFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ, expectedFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ)
            let date2 = objImageData2.createdDate.convertStringToDate(actualFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ, expectedFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ)
            return (date2!.compare(date1!) == ComparisonResult.orderedAscending)
        })
        
      if let dictarr = dictionary.value(forKey: ENTITIES.removImplant) as? [NSDictionary] {
              let arrImaplant  = dictarr.map({ (dict) -> Implant in
                     return Implant(dictionary: dict)
                 }) //as! [Implant]
        
        //Sorted by Date
          self.removImplant = NSMutableArray(array: arrImaplant.sorted(by: { (obj1: Any, obj2: Any) -> Bool in
               let objImplant1 = obj1 as? Implant ?? Implant()
              let objImplant2 = obj2 as? Implant ?? Implant()
              let date1 = objImplant1.createdDate.convertStringToDate(actualFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ, expectedFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ)
              let date2 = objImplant2.createdDate.convertStringToDate(actualFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ, expectedFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ)
              return (date2!.compare(date1!) == ComparisonResult.orderedAscending)
          }))
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
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy: SearchResult = SearchResult()
        copy.isApproved = self.isApproved
        copy.isRejected = self.isRejected
        copy._id = self._id
        copy.objectName = self.objectName
        copy.implantManufacture = self.implantManufacture
        copy.imageData = self.imageData
        copy.removImplant = self.removImplant
        copy.watsonImage_id = self.watsonImage_id
        copy.createdOn = self.createdOn
        copy.modifiedOn = self.modifiedOn
        copy.implantImage = self.implantImage
        return copy
        
    }
    
}
