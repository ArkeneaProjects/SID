//
//  Credit.swift
//  Kethan
//
//  Created by Apple on 31/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class Credit: NSObject, NSCopying {
    var creditPoints: String = ""
    var isApprovedDate: String = ""
    var brandName: String = ""
    var manufactur: String = ""
    var image: String = ""
    var msg: String = ""
    var title: String = ""
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary) {
        self.creditPoints = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.creditPoints)
        if let date = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.isApprovedDate).convertStringToDate(actualFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ, expectedFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ) {
            self.isApprovedDate = date.convertDateToStringWithFormat(actualFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ, expectedFormat: DATEFORMATTERS.DDMMMYYYY)!
        }
        let type = getValueFromDictionary(dictionary: dictionary, forKey: "type")
        if type == "implant" {
            self.image = "upload"
            self.title = "Upload Images Rewards"
            self.msg = "Rewarded for being uploaded images on Database"
        } else {
            if let appName = Bundle.main.infoDictionary!["CFBundleName"] as? String {
                self.image = "referral"
                self.title = "Referral Rewards"
                self.msg = "Rewarded for being referred to \(appName) by a friend"
            }
        }
        
        self.brandName = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.brandName)
        self.manufactur = getValueFromDictionary(dictionary: dictionary, forKey: ENTITIES.manufactur)
    }
    
    func dictioary() -> NSDictionary {
        let dictionary: NSDictionary = [
            ENTITIES.creditPoints: self.creditPoints,
            ENTITIES.isApprovedDate: self.isApprovedDate,
            ENTITIES.brandName: self.brandName,
            ENTITIES.manufactur: self.manufactur,
            "image": self.image,
            "title": self.title,
            "message": self.msg
        ]
        return dictionary
    }
    // static let arrCreditHistory = [["image": "referral", "title": "Referral Rewards", "amount": "+ $ 20", "date": "November 20", "description": "Rewarded for being referred to SID by a friend"], ["image": "upload", "title": "Upload Images Rewards", "amount": "+ $ 10", "date": "November 19", "description": "Rewarded for being uploaded images on Database"], ["image": "referral", "title": "Referral Rewards", "amount": "+ $ 20", "date": "November 12", "description": ""], ["image": "referral", "title": "Referral Rewards", "amount": "+ $ 20", "date": "November 20", "description": "Rewarded for being referred to SID by a friend"]]
    func copy(with zone: NSZone? = nil) -> Any {
        let copy: Credit = Credit()
        copy.creditPoints = self.creditPoints
        copy.isApprovedDate = self.isApprovedDate
        copy.brandName = self.brandName
        copy.manufactur = self.manufactur
        copy.image = self.image
        copy.title = self.title
        copy.msg = self.msg
        return copy
        
    }
}
