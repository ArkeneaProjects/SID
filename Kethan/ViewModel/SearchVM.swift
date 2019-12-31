//
//  SearchVM.swift
//  Kethan
//
//  Created by Apple on 30/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SearchVM {
    
    var arrSearchResult = [SearchResult] ()
    var rootController: BaseViewController?
    
    func getAllSearchResult(manufecture: String, brandname: String, completion: @escaping () -> Void) {
        ProgressManager.show(withStatus: "", on: self.rootController?.view)
        let dict: NSDictionary = ["manufecture": manufecture,
                                  "brandName": brandname]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SearchByText, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error != nil {
                ProgressManager.showError(withStatus: error, on: self.rootController?.view)
                
            } else {
                if let dict = response as? NSDictionary {
                    if let dataarr = dict.value(forKeyPath: "implant") as? [NSDictionary] {
                        self.arrSearchResult = dataarr.map({ return SearchResult(dictionary: $0)
                        })
                        ProgressManager.dismiss()
                        if let controller = self.rootController?.instantiate(SearchListViewController.self, storyboard: STORYBOARD.main) as? SearchListViewController {
                            controller.arrResult = self.arrSearchResult
                            self.rootController?.navigationController?.pushViewController(controller, animated: true)
                        }
                    } else {
                        
                        ProgressManager.showError(withStatus: getValueFromDictionary(dictionary: dict, forKey: "message"), on: self.rootController?.view)
                    }
                    
                }
            }
        }
    }
    
    func numberofItems(section: Int) -> Int {
        return self.arrSearchResult.count
    }
    
}
