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
    var countryCode: String = ""
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
        } else if self.contactNumber.count > 0 && self.contactNumber.count <= 9 {
            return .InValid(ERRORS.validMobileNumber)
        }
        return .Valid
    }
    
    func validateOTP() -> ValidationState {
        if self.otp.trimmedString().count <= 5 {
            return .InValid(ERRORS.otp)
        }
        return .Valid
    }
    
    func callSignUpAPI(completion: @escaping VoidCompletion) {
        let dict: NSDictionary = [ENTITIES.name: self.name, ENTITIES.email: self.email, ENTITIES.phoneNumber: (self.contactNumber.count == 0) ?self.contactNumber:self.countryCode+self.contactNumber, ENTITIES.profession: self.profession, ENTITIES.referralCode: self.referral]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SignUp, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: NSInteger?) in
            if error != nil {
                self.errorSignUp = error!
            } else {
                if let dict = response as? NSDictionary {
                    self.responseSignUpDict = dict
                }
            }
            completion()
        }
    }
    
    func callSignUpOTPAPI(completion: @escaping VoidCompletion) {
        let dict: NSDictionary = [ENTITIES.email: self.email, ENTITIES.otp: self.otp]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SignUPOTP, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: NSInteger?) in
            if error != nil {
                self.errorOTP = error!
            } else {
                if let dict = response as? NSDictionary {
                    self.responseOTPDict = dict
                }
            }
            completion()
        }
    }
    
    func callResendOTP(completion: @escaping VoidCompletion) {
        let dict: NSDictionary = [ENTITIES.email: self.email]
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.ForgotPassword, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: NSInteger?) in
            if error != nil {
                self.errorOTP = error!
            } else {
                if let dict = response as? NSDictionary {
                    self.responseOTPDict = dict
                }
            }
            completion()
        }

    }
    
    
}
