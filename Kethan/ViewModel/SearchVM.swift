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
    
    func getAllSearchByText(manufecture: String, brandname: String, completion: @escaping (_ error: String) -> Void) {
        ProgressManager.show(withStatus: "", on: self.rootController?.view)
        let dict: NSDictionary = ["manufecture": manufecture,
                                  "brandName": brandname]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SearchByText, parameters: dict, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error != nil {
                ProgressManager.showError(withStatus: error, on: self.rootController?.view)
                completion(error ?? "")
            } else {
                if let dict = response as? NSDictionary {
                    if let dataarr = dict.value(forKeyPath: "implant") as? [NSDictionary] {
                        self.arrSearchResult = dataarr.map({ return SearchResult(dictionary: $0)
                        })
                        ProgressManager.dismiss()
                        completion("")
                        
                    } else {
                        completion(getValueFromDictionary(dictionary: dict, forKey: "message"))
                        ProgressManager.showError(withStatus: getValueFromDictionary(dictionary: dict, forKey: "message"), on: self.rootController?.view)
                    }
                }
            }
        }
    }
    
    func numberofItems(section: Int) -> Int {
        return self.arrSearchResult.count
    }
    
    func getSearchByImage( itemArray: NSArray, completion: @escaping (_ error: String) -> Void) {
        ProgressManager.show(withStatus: "Searching our database...", on: self.rootController?.view)

        let dict: NSDictionary = [:]
        let imageDict  = saveImageInDocumentDict(image: itemArray.firstObject as! UIImage, imageName: "photo")

        AFManager.sendMultipartRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SearchByImage, parameters: dict, multipart: [imageDict], serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error != nil {
                ProgressManager.showError(withStatus: error, on: self.rootController?.view)
                completion(error ?? "")
            } else {
                if let dict = response as? NSDictionary, let implantDict = dict.value(forKeyPath: "implantApi") as? NSDictionary {
                    if let dataarr = implantDict.value(forKeyPath: "implant") as? [NSDictionary] {
                        self.arrSearchResult = dataarr.map({ return SearchResult(dictionary: $0)
                        })
                        ProgressManager.dismiss()
                        completion("")
                        
                    } else {
                        completion(getValueFromDictionary(dictionary: dict, forKey: "message"))
                        ProgressManager.showError(withStatus: getValueFromDictionary(dictionary: dict, forKey: "message"), on: self.rootController?.view)
                    }
                }
            }
        }
    }
}
