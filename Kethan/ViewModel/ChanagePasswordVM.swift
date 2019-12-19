//
//  ChanagePasswordVM.swift
//  Kethan
//
//  Created by Apple on 16/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class ChanagePasswordVM: NSObject {
    var oldPwd: String = ""
    var newPwd: String = ""
    var confirmPwd: String = ""
    var email: String = ""
    var error: String = ""
    var iscommingFrom = 0
    
    var user = User()
    
    var rootController: BaseViewController?
    
    
    override init() {
        
    }
    
    func clearAll() {
        self.oldPwd = ""
        self.newPwd = ""
        self.confirmPwd = ""
        self.email = ""
        self.error = ""
        self.iscommingFrom = 0
        
        self.user = User()
    }
    
    func validateChangePwd(controller: BaseViewController) {
        self.rootController = controller
        if self.newPwd.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.newPwdEmpty, on: self.rootController!.view)
            return
        } else if self.confirmPwd.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.confirmPwdEmpty, on: self.rootController!.view)
            return
        } else if self.newPwd != self.confirmPwd {
            ProgressManager.showError(withStatus: ERRORS.matchPwd, on: self.rootController!.view)
            return
        } else if self.newPwd.isAlphaNeumeric() == false {
            ProgressManager.showError(withStatus: ERRORS.invalidPwd, on: self.rootController!.view)
            return
        } else if self.confirmPwd.trimmedString().count <= 5 {
            ProgressManager.showError(withStatus: ERRORS.invalidLenghtPwd, on: self.rootController!.view)
            return
        }
        self.changePwdAPI()
    }
    
    func changePwdAPI() {
        
        ProgressManager.show(withStatus: "", on: self.rootController!.view)
        
        let encryptedPassword = EncDec.aes128Base64Encrypt(self.newPwd)
        let dict: NSDictionary = [ENTITIES.email: self.email, ENTITIES.password: encryptedPassword!]
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SetPassword, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error != nil {
                self.error = error ?? ""
                ProgressManager.showError(withStatus: self.error, on: self.rootController!.view)
            } else {
                if let dict = response as? NSDictionary {
                    
                    if self.iscommingFrom == 2 {
                        self.user = User.init(dictionary: dict)
                        AppConstant.shared.updateProfile(updatedProfile: self.user)
                        
                        ProgressManager.showSuccess(withStatus: "Your password has been set successfully", on: self.rootController!.view) {
                            if let controller = self.rootController!.instantiate(SignUpUserGuideViewController.self, storyboard: STORYBOARD.signup) as? SignUpUserGuideViewController {
                                self.rootController!.navigationController?.pushViewController(controller, animated: true)
                            }
                        }
                    } else {
                        ProgressManager.showSuccess(withStatus: "Your password has been reset successfully", on: self.rootController!.view) {
                            self.rootController!.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}
