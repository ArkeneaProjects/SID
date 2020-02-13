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
        self.totalCreditEarn = 0
        self.arrCredit.removeAll()
        var completionFlag = false
        if isShowLoader {
            ProgressManager.show(withStatus: "", on: rootController.view)
        }
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        let dict: NSDictionary = [:]
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.ViewProfile, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error == nil {
                if let dict = response as? NSDictionary {
                    ProgressManager.dismiss()
                    if let userDict = dict["user"] as? NSDictionary {
                       let user = User.init(dictionary: userDict)
                        AppConstant.shared.updateProfile(updatedProfile: user)
                        self.totalCreditEarn = Int(AppConstant.shared.loggedUser.creditPoint)!
                    }
                    dispatchGroup.leave()
                }
            } else {
                ProgressManager.showError(withStatus: error, on: rootController.view)
                dispatchGroup.leave()
            }
            
        }
        
        dispatchGroup.enter()
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.Credit, parameters: dict, serviceCount: 1) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error == nil {
                if isShowLoader {
                    ProgressManager.dismiss()
                }
                if let dict = response as? NSDictionary {
                    if let dataarr = dict.value(forKeyPath: "creditList") as? [NSDictionary] {
                        
                        self.arrCredit = dataarr.map({ (dict) -> Credit in
                            return Credit(dictionary: dict)
                        })
                        completionFlag = true
                        dispatchGroup.leave()
                    } else {
                        dispatchGroup.leave()
                    }
                } else {
                    dispatchGroup.leave()
                }
            } else {
                if isShowLoader {
                    ProgressManager.showError(withStatus: error, on: rootController.view)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(completionFlag)
        }
    }
    
    func getCreditPoints(_ completion: @escaping (Bool) -> Void) {
        let dict: NSDictionary = [:]
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.ViewProfile, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error == nil {
                if let dict = response as? NSDictionary {
                    if let userDict = dict["user"] as? NSDictionary {
                        let user = User.init(dictionary: userDict)
                        AppConstant.shared.updateProfile(updatedProfile: user)
                    }
                }
                
            }
            completion(true)
        }
    }
}
