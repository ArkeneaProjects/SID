//
//  CustomConstraint.swift
//  YupEasy
//
//  Created by Pankaj on 12/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

class CustomConstraint: NSLayoutConstraint {
    @IBInspectable var dynamic: Bool = false
       
       override func setValue(_ value: Any?, forKey key: String) {
           super.setValue(value, forKey: key)
           
           if self.dynamic == true {
               self.constant = getCalculated(self.constant)
           }
       }
}
