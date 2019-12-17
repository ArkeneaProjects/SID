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
    
    var user = User()
    
    override init() {
        
    }
    
    func validateChangePwd() -> ValidationState {
        if self.newPwd.trimmedString().count == 0 {
            return .InValid(ERRORS.newPwdEmpty)
        } else if self.confirmPwd.trimmedString().count == 0 {
            return .InValid(ERRORS.confirmPwdEmpty)
        } else if self.newPwd != self.confirmPwd {
            return .InValid(ERRORS.matchPwd)
        } else if self.newPwd.isAlphaNeumeric() == false {
            return .InValid(ERRORS.invalidPwd)
        } else if self.confirmPwd.trimmedString().count <= 6 {
            return .InValid(ERRORS.invalidLenghtPwd)
        }
        return .Valid
    }
    
    func changePwdAPI(completion: @escaping VoidCompletion) {
        
        let encryptedPassword = EncDec.aes128Base64Encrypt(self.newPwd)
        let dict: NSDictionary = [ENTITIES.email: self.email, ENTITIES.password: encryptedPassword!]
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SetPassword, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: NSInteger?) in
            if error != nil {
                self.error = error!
            } else {
                if let dict = response as? NSDictionary {
                    self.user = User.init(dictionary: dict)
                }
            }
            completion()
        }
    }
}
