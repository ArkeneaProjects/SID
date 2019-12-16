//
//  SignUpViewModel.swift
//  Kethan
//
//  Created by Apple on 13/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SignUpViewModel: NSObject {
    var name: String = ""
    var email: String = ""
    var contactNumber: String = ""
    var profession: String = ""
    var referral: String = ""
    var otp: String = ""
    
    var responseSignUpDict = NSDictionary()
    var errorSignUp: String = ""
    
    var responseOTPDict = NSDictionary()
    var errorOTP: String = ""
    
    override init() {
        
    }
    
    func validateSignUp() -> ValidationState {
        if self.name.trimmedString().count == 0 {
            return .InValid(ERRORS.fullName)
        } else if self.email.trimmedString().count == 0 {
            return .InValid(ERRORS.emilId)
        } else if self.email.isValidEmail() == false {
            return .InValid(ERRORS.invalidEmail)
        } else if self.profession.count == 0 {
            return .InValid(ERRORS.profession)
        }
        return .Valid
    }
    
    func callSignUpAPI(completion: @escaping VoidCompletion) {
        
        let dict: NSDictionary = [ENTITIES.name: self.name, ENTITIES.email: self.email, ENTITIES.phoneNumber: self.contactNumber, ENTITIES.profession: self.profession, ENTITIES.referralCode: self.referral]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SignIn, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: NSInteger?) in
                if let dict = response as? NSDictionary {
                    self.responseSignUpDict = dict
                }
                self.errorOTP = error!
                completion()
        }
    }
    
    func callSignUpOTPAPI(completion: @escaping VoidCompletion) {
        let dict: NSDictionary = [ENTITIES.email: self.email, ENTITIES.otp: self.otp]
               
               AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SignUPOTP, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: NSInteger?) in
                       if let dict = response as? NSDictionary {
                           self.responseOTPDict = dict
                       }
                       self.errorOTP = error!
                       completion()
               }
    }
    
}
