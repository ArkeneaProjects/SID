//
//  CreditVM.swift
//  Kethan
//
//  Created by Apple on 31/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class CreditVM: NSObject {
    
    var totalCreditEarn = 0
    var arrCredit = [Credit]()
    override init() {
        
    }
    
    func callAPI(_ rootController: BaseViewController, isShowLoader: Bool = true, _ completion: @escaping (Bool) -> Void) {
        if isShowLoader {
            ProgressManager.show(withStatus: "", on: rootController.view)
        }
        let dict: NSDictionary = [:]
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.Credit, parameters: dict, serviceCount: 1) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error == nil {
                if isShowLoader {
                    ProgressManager.dismiss()
                }
                if let dict = response as? NSDictionary {
                    if let dataarr = dict.value(forKeyPath: "creditList") as? [NSDictionary] {
                        
                        self.arrCredit = dataarr.map({ (dict) -> Credit in
                            let credit = getValueFromDictionary(dictionary: dict, forKey: "creditPoints")
                            self.totalCreditEarn +=  Int(credit)!
                            
                            return Credit(dictionary: dict)
                        })
                        // Update the credit points
                        if let dictionary = getUserDefaultsForKey(key: UserDefaultsKeys.LoggedUser) as? NSDictionary {
                            let user = User.init(dictionary: dictionary)
                            user.creditPoint = String("\(self.totalCreditEarn)")
                            AppConstant.shared.updateProfile(updatedProfile: user)
                        }
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            } else {
                if isShowLoader {
                    ProgressManager.showError(withStatus: error, on: rootController.view)
                }
                completion(false)
            }
        }
    }
}
