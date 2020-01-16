//
//  ForgotVM.swift
//  Kethan
//
//  Created by Apple on 19/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class ForgotVM: NSObject {
    var email: String = ""
    var rootViewController: BaseViewController?
    var responseOTPDict = NSDictionary()
    var errorOTP: String = ""
    var statusCodeOTP: String = ""
    var otp: String = ""
    var isCameFromForgotScreen: Bool = true
    
    func clearAllData() {
        self.email = ""
        self.responseOTPDict = NSDictionary()
        self.errorOTP = ""
        self.statusCodeOTP = ""
        self.otp = ""
    }
    
    func validateEmail(controller: BaseViewController) {
        self.rootViewController = controller
        if self.email.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.emilId, on: self.rootViewController!.view)
            return
        } else if self.email.isValidEmail() == false {
            ProgressManager.showError(withStatus: ERRORS.invalidEmail, on: self.rootViewController!.view)
            return
        }
        self.callResendOTP(controller: self.rootViewController!)
    }
    
    func validateOTP(controller: BaseViewController) {
        self.rootViewController = controller
        if self.otp.trimmedString().count <= 5 {
            ProgressManager.showError(withStatus: ERRORS.otp, on: self.rootViewController!.view)
            return
        }
        self.verifyOTPAPI()
    }
    
    // MARK: - API Call
    func callResendOTP(controller: BaseViewController) {
        
        self.rootViewController = controller
        ProgressManager.show(withStatus: "", on: self.rootViewController!.view)
        
        let dict: NSDictionary = [ENTITIES.email: self.email]
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: (self.isCameFromForgotScreen == true) ? SUFFIX_URL.ForgotPassword:SUFFIX_URL.ChangeEmail, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error != nil {
                self.errorOTP = error!
                self.statusCodeOTP = errorCode ?? ""
                ProgressManager.showError(withStatus: self.errorOTP, on: self.rootViewController!.view)
            } else {
                if let dict = response as? NSDictionary {
                    self.responseOTPDict = dict
                    let msg = getValueFromDictionary(dictionary: self.responseOTPDict, forKey: CONSTANT.Message)
                    ProgressManager.showSuccess(withStatus: msg, on: self.rootViewController!.view, completion: {
                        if let controller = self.rootViewController as? ForgotPwdViewController {
                            if controller.constSpacerViewHeight.constant != 0 {
                                controller.showOTPView()
                            }
                        }
                    })
                }
            }
        }
    }
    
    func verifyOTPAPI() {
        
        ProgressManager.show(withStatus: "", on: self.rootViewController!.view)
        
        let key = (self.isCameFromForgotScreen == true) ?ENTITIES.resetOtp:ENTITIES.otp
        
        let dict: NSDictionary = [ENTITIES.email: self.email, key: self.otp]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: (self.isCameFromForgotScreen == true) ? SUFFIX_URL.ForgotVerifyOTP:SUFFIX_URL.EmailVerifyOTP, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error != nil {
                self.errorOTP = error ?? ""
                self.statusCodeOTP = errorCode ?? ""
                
                ProgressManager.showError(withStatus: self.errorOTP, on: self.rootViewController!.view, completion: {
                    if let controller = self.rootViewController as? ForgotPwdViewController {
                        controller.pinView.clearPin()
                    }
                })
            } else {
                if let dict = response as? NSDictionary {
                    self.responseOTPDict = dict
                  
                    if self.isCameFromForgotScreen == true {
                          ProgressManager.dismiss()
                        if let controller = self.rootViewController!.instantiate(ChangePwdViewController.self, storyboard: STORYBOARD.signup) as? ChangePwdViewController {
                            controller.email = self.email
                            controller.isComeFrom = 1
                            self.rootViewController!.navigationController?.pushViewController(controller, animated: true)
                        }
                    } else {
                        ProgressManager.showSuccess(withStatus: "") {
                            if let userDict = dict["user"] as? NSDictionary {
                                updateUserDetail(userDetail: userDict)
                            }
                        self.rootViewController?.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}
