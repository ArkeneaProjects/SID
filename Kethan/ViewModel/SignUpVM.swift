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
    var statusCodeSignUp: String = ""
    
    var responseOTPDict = NSDictionary()
    var errorOTP: String = ""
    var statusCodeOTP: String = ""
    
    var loginVM: LoginViewModel?
    
    var rootViewController: BaseViewController?
    
    override init() {
        
    }
    
    func clearAllData() {
        self.name = ""
        self.email = ""
        self.contactNumber = ""
        self.countryCode = ""
        self.profession = ""
        self.referral = ""
        self.otp = ""
        
        self.responseSignUpDict = NSDictionary()
        self.errorSignUp = ""
        self.statusCodeSignUp = ""
        
        self.responseOTPDict = NSDictionary()
        self.errorOTP = ""
        self.statusCodeOTP = ""
    }
    
    // MARK: - Validation
    func validateSignUp(controller: BaseViewController) {
        
        self.rootViewController = controller
        
        if self.name.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.fullName, on: self.rootViewController!.view)
            return
        } else if self.email.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.emilId, on: self.rootViewController!.view)
            return
        } else if self.email.isValidEmail() == false {
            ProgressManager.showError(withStatus: ERRORS.invalidEmail, on: self.rootViewController!.view)
            return
        } else if self.contactNumber.count > 0 && self.contactNumber.count <= 9 {
            ProgressManager.showError(withStatus: ERRORS.validMobileNumber, on: self.rootViewController!.view)
            return
        }
        self.callSignUpAPI()
    }
    
    func validateOTP(controller: BaseViewController) {
        self.rootViewController = controller
        if self.otp.trimmedString().count <= 5 {
            ProgressManager.showError(withStatus: ERRORS.otp, on: self.rootViewController!.view)
            return
        }
        self.verifyOTPAPI()
    }
    
    // MARK: - APIs
    func callSignUpAPI() {
        
        ProgressManager.show(withStatus: "", on: self.rootViewController!.view)
        var dict: NSDictionary = [:]
        if self.loginVM == nil { //Without Social media login
            dict = [ENTITIES.name: self.name, ENTITIES.email: self.email, ENTITIES.contactNumber: self.contactNumber, ENTITIES.profession: self.profession, ENTITIES.referralCode: self.referral, ENTITIES.countryCode: (self.contactNumber.count == 0) ?"":countryCode]
        } else {
            dict = [ENTITIES.name: self.name, ENTITIES.email: self.email, ENTITIES.contactNumber: self.contactNumber, ENTITIES.profession: self.profession, ENTITIES.referralCode: self.referral, ENTITIES.countryCode: (self.contactNumber.count == 0) ?"":countryCode, ENTITIES.socialMediaToken: self.loginVM!.socialMediaID, ENTITIES.socialPlatform: (self.loginVM!.loginType == "facebook") ?"facebook":"google", ENTITIES.userImage: self.loginVM!.profileURL]
        }
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SignUp, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error != nil {
                self.errorSignUp = error ?? ""
                self.statusCodeSignUp = errorCode ?? ""
                ProgressManager.showError(withStatus: self.errorSignUp, on: self.rootViewController!.view) {
                    if self.statusCodeSignUp == CONSTANT.StatusCodeOne { //Already register but not confirmed OTP
                        if let controller = self.rootViewController!.instantiate(VerifyOTPViewController.self, storyboard: STORYBOARD.signup) as? VerifyOTPViewController {
                            controller.enterEmail = self.email
                            controller.signupVM.loginVM = self.loginVM
                            self.rootViewController!.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                }
            } else {
                if let dict = response as? NSDictionary {
                    self.responseSignUpDict = dict
                    ProgressManager.showSuccess(withStatus: getValueFromDictionary(dictionary: self.responseSignUpDict, forKey: CONSTANT.Message), on: self.rootViewController!.view) {
                        if let controller = self.rootViewController!.instantiate(VerifyOTPViewController.self, storyboard: STORYBOARD.signup) as? VerifyOTPViewController {
                            controller.enterEmail = self.email
                            controller.signupVM.loginVM = self.loginVM
                            self.rootViewController!.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func verifyOTPAPI() {
        
        ProgressManager.show(withStatus: "", on: self.rootViewController!.view)
        
        let dict: NSDictionary = [ENTITIES.email: self.email, ENTITIES.otp: self.otp]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SignUPOTP, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error != nil {
                self.errorOTP = error ?? ""
                self.statusCodeOTP = errorCode ?? ""
                ProgressManager.showError(withStatus: self.errorOTP, on: self.rootViewController!.view, completion: {
                    if let controller = self.rootViewController as? VerifyOTPViewController { //Clear the Pin
                        controller.pinView.clearPin()
                    }
                })
            } else {
                if let dict = response as? NSDictionary {
                    self.responseOTPDict = dict
                    ProgressManager.dismiss()
                    if self.loginVM == nil { //without social media login
                        if let controller = self.rootViewController!.instantiate(ChangePwdViewController.self, storyboard: STORYBOARD.signup) as? ChangePwdViewController {
                            controller.email = self.email
                            controller.isComeFrom = 2
                            self.rootViewController!.navigationController?.pushViewController(controller, animated: true)
                        }
                    } else {
                        if let userDict = self.responseOTPDict["user"] as? NSDictionary {
                            updateUserDetail(userDetail: userDict)
                            if let controller = self.rootViewController!.instantiate(SignUpUserGuideViewController.self, storyboard: STORYBOARD.signup) as? SignUpUserGuideViewController {
                                self.rootViewController!.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //SignUp Resend OTP
    func signupResendOTP(controller: BaseViewController) {
        
        self.rootViewController = controller
        ProgressManager.show(withStatus: "", on: self.rootViewController!.view)
        
        let dict: NSDictionary = [ENTITIES.email: self.email]
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SignupResendOTP, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error != nil {
                self.errorOTP = error!
                self.statusCodeOTP = errorCode ?? ""
                ProgressManager.showError(withStatus: self.errorOTP, on: self.rootViewController!.view)
            } else {
                if let dict = response as? NSDictionary {
                    self.responseOTPDict = dict
                    let msg = getValueFromDictionary(dictionary: self.responseOTPDict, forKey: CONSTANT.Message)
                    ProgressManager.showSuccess(withStatus: msg, on: self.rootViewController!.view, completion: {
                        
                    })
                }
            }
        }
    }
    
    func checkEmailisValid( completion: @escaping ( _ isValidate: Bool) -> Void) {
        
        if self.email.trimmedString().count == 0 {
            completion(false)
            return
        } else if self.email.isValidEmail() == false {
            completion(false)
            return
        }
        
        let dict: NSDictionary = [ENTITIES.email: self.email]
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.CheckEmail, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
        
    }
}
