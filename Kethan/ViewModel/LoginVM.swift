//
//  LoginViewModel.swift
//  Kethan
//
//  Created by Apple on 09/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {
    
    var email: String = ""
    var password: String = ""
    var responseDict = NSDictionary()
    var error: String = ""
    var stausCode: String = ""
    var loginType: String = ""
    var socialMediaID: String = ""
    var fullName: String = ""
    var profileURL: String = ""
    
    var rootController: BaseViewController?
    
    override init() {
        DispatchQueue.main.async {
            let dict: NSDictionary = [:]
            AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.TotalManufactureName, parameters: dict, serviceCount: 0, completion: { (response: AnyObject?, error: String?, errorCode: String?) in
                
                if error == nil || error == "" {
                    if let dictionary = response as? NSDictionary {
                        
                        if let arrManufacture = dictionary.value(forKey: "manufecture") as? [String] {
                            setUserDefaults(value: NSMutableArray(array: arrManufacture), forKey: UserDefaultsKeys.Manufecture)
                        }
                        if let arrBrandName = dictionary.value(forKey: "brandName") as? [String] {
                            setUserDefaults(value: NSMutableArray(array: arrBrandName), forKey: UserDefaultsKeys.BrandName)
                        }
                    }
                }
            })
        }
    }
    
    func clearAllData() {
        self.email = ""
        self.password = ""
        self.responseDict = NSDictionary()
        self.error = ""
        self.stausCode = ""
        self.loginType = ""
        self.socialMediaID = ""
        self.fullName = ""
        self.profileURL = ""
    }
    
    func validateLogin(_ controller: BaseViewController) {
        self.rootController = controller
        if email.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.emilId, on: self.rootController!.view)
            return
        } else if email.isValidEmail() == false {
            ProgressManager.showError(withStatus: ERRORS.invalidEmail, on: self.rootController!.view)
            return
        } else if password.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: "Password can't be empty", on: self.rootController!.view)
            return
        }
        self.loginAPI()
    }
    
    
    func validateSocialLogin(controller: BaseViewController) {
        self.rootController = controller
        if email.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.emilId, on: self.rootController!.view)
            return
        } else if email.isValidEmail() == false {
            ProgressManager.showError(withStatus: ERRORS.invalidEmail, on: self.rootController!.view)
            return
        } else if self.socialMediaID.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.socialMediaError, on: self.rootController!.view)
            return
        }
        self.loginAPI()
    }
    
    func loginAPI() {
        ProgressManager.show(withStatus: "", on: self.rootController!.view)
        var dict: NSDictionary = [:]
        if self.loginType.count == 0 {
            let encryptedPassword = EncDec.aes128Base64Encrypt(self.password)
            dict = [ENTITIES.email: self.email, ENTITIES.password: encryptedPassword!]
        } else {
            dict = [ENTITIES.email: self.email, ENTITIES.socialMediaToken: self.socialMediaID, ENTITIES.socialPlatform: (self.loginType == "facebook") ?"facebook":"google"]
        }
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SignIn, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error != nil {
                self.error = error ?? ""
                self.stausCode = errorCode ?? ""
                ProgressManager.showError(withStatus: self.error, on: self.rootController!.view, completion: {
                    if self.stausCode == CONSTANT.StatusCodeOne {
                        if let controller = self.rootController!.instantiate(VerifyOTPViewController.self, storyboard: STORYBOARD.signup) as? VerifyOTPViewController {
                            controller.enterEmail = self.email
                            self.rootController!.navigationController?.pushViewController(controller, animated: true)
                        }
                    } else if self.stausCode == CONSTANT.StatusCodeTwo {
                        if let controller = self.rootController!.instantiate(SignUpViewController.self, storyboard: STORYBOARD.signup) as? SignUpViewController {
                            controller.signUpVM.loginVM = self
                            self.rootController!.navigationController?.pushViewController(controller, animated: true)
                        }
                    }
                })
            } else {
                if let dict = response as? NSDictionary {
                    self.responseDict = dict
                    ProgressManager.dismiss()
                    if let userDict = self.responseDict["user"] as? NSDictionary {
                        updateUserDetail(userDetail: userDict)
                        self.rootController!.navigateToHome(false, false)
                    }
                }
            }
        }
    }
}
