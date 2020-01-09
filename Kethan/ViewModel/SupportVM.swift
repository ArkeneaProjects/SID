//
//  SupportVM.swift
//  Kethan
//
//  Created by Apple on 09/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class SupportVM: NSObject {
    
    var query = ""
    
    override init() {
        
    }
    
    func supportQuery(controller: BaseViewController) {
        if query.count == 0 {
            ProgressManager.showError(withStatus: "Please enter your Query.", on: controller.view)
            return
        }
        
        ProgressManager.show(withStatus: "", on: controller.view)
        let dict: NSDictionary = [ENTITIES.query: self.query]
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.Support, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errroCode: String?) in
            if error == nil {
                ProgressManager.dismiss()
                if let thankController = controller.instantiate(ThankYouViewController.self, storyboard: STORYBOARD.main) as? ThankYouViewController {
                    thankController.isComeFrom = 0
                    controller.navigationController?.pushViewController(thankController, animated: true)
                }
            } else {
                ProgressManager.showError(withStatus: error, on: controller.view)
            }
        }
    }
}
