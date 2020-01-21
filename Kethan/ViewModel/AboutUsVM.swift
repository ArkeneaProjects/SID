//
//  AboutUsVM.swift
//  Kethan
//
//  Created by Apple on 21/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class AboutUsVM: NSObject {
    
    var page: String = ""
    
    override init() {
        
    }
    
    func callAPI(page: String, completion: @escaping ( _ content: String) -> Void) {
        
        let dict: NSDictionary = [:]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.GetCMSPage, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error == nil {
                if let dict = response as? NSDictionary, let arrCMS = dict.value(forKeyPath: "cmsList") as? [NSDictionary] {
                    
                    var content = ""
                    for item in arrCMS {
                        if page == getValueFromDictionary(dictionary: item, forKey: "pageName") {
                            content = getValueFromDictionary(dictionary: item, forKey: "content")
                        }
                    }
                    completion(content)
                    
                } else {
                    completion("")
                }
            } else {
                completion("")
            }
            
        }
    }
}
