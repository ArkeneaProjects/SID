//
//  LoginViewModel.swift
//  Kethan
//
//  Created by Apple on 09/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

enum ValidationState {
    case Valid
    case InValid(String)
}

class LoginViewModel: NSObject {
    
    var email: String = ""
    var password: String = ""
    
    func validate() -> ValidationState {
        if email.trimmedString().count == 0 {
            return .InValid("Email can't be empty")
        } else if email.isValidEmail() == false {
            return .InValid("Invaid Email Id")
        }
        return .Valid
    }
}
