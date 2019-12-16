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
    
    override init() {
        
    }
    
    func validateLogin() -> ValidationState {
        if email.trimmedString().count == 0 {
            return .InValid(ERRORS.emilId)
        } else if email.isValidEmail() == false {
            return .InValid(ERRORS.invalidEmail)
        } else if password.trimmedString().count == 0 {
            return .InValid("Password can't be empty")
        }
        return .Valid
    }
    
    func loginAPI(completion: @escaping VoidCompletion) {
        
        let encryptedPassword = EncDec.aes128Base64Encrypt(self.password)
        let dict: NSDictionary = [ENTITIES.email: self.email, ENTITIES.password: encryptedPassword!]
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SignIn, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: NSInteger?) in
            if let dict = response as? NSDictionary {
                self.responseDict = dict
            }
            self.error = error!
            completion()
        }
    }
}
