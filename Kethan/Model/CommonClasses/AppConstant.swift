//
//  AppConstant.swift
//  Kethan
//
//  Created by Apple on 19/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class AppConstant: NSObject {
    var loggedUser = User()
    
    var manufactureName: String = ""
    var brandName: String = ""
    
    static let shared: AppConstant = AppConstant()
    
    func updateProfile(updatedProfile: User) {
        AppConstant.shared.loggedUser.userId = updatedProfile.userId
        AppConstant.shared.loggedUser.accesstoken = updatedProfile.accesstoken
        AppConstant.shared.loggedUser.isSocialMediaUser = updatedProfile.isSocialMediaUser
        AppConstant.shared.loggedUser.email = updatedProfile.email
        AppConstant.shared.loggedUser.contactNumber = updatedProfile.contactNumber
        AppConstant.shared.loggedUser.name = updatedProfile.name
        AppConstant.shared.loggedUser.profession = updatedProfile.profession
        AppConstant.shared.loggedUser.userImage = updatedProfile.userImage
        AppConstant.shared.loggedUser.country_code = updatedProfile.country_code
        AppConstant.shared.loggedUser.referralCode = updatedProfile.referralCode
        AppConstant.shared.loggedUser.creditPoint = updatedProfile.creditPoint
        AppConstant.shared.loggedUser.subscriptionStatus = updatedProfile.subscriptionStatus
        AppConstant.shared.loggedUser.subscriptionType = updatedProfile.subscriptionType
        AppConstant.shared.loggedUser.subscriptionEndDate = updatedProfile.subscriptionEndDate
        
        setUserDefaults(value: AppConstant.shared.loggedUser.dictioary(), forKey: UserDefaultsKeys.LoggedUser)
    }
    
}
