//
//  LogoutVM.swift
//  Kethan
//
//  Created by Apple on 09/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class LogoutVM: NSObject {

    var rootController: BaseViewController?
    override init() {
        
    }
    
    func logoutFromSystem(controller: BaseViewController) {
        self.rootController = controller
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SignOut, parameters: [:], serviceCount: 0) { (result: AnyObject?, error: String?, errorCode: String?) in
            self.rootController!.logoutFromApp()
        }
    }
}
