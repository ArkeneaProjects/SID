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
//                        self.arrSearchResult = dataarr.map({ return SearchResult(dictionary: $0)
//                        })
                        
                        for item in dataarr {
                            let objItem = SearchResult(dictionary: item)
                             if objItem.userId == AppConstant.shared.loggedUser.userId || objItem.isApproved == "1" {
                                    self.arrSearchResult.append(objItem)
                            }
                        }
                        
                        //Sorted by Date
                        self.arrSearchResult = self.arrSearchResult.sorted(by: { (obj1: Any, obj2: Any) -> Bool in
                            let objSearcheData1 = obj1 as? SearchResult ?? SearchResult()
                            let objSearcheData2 = obj2 as? SearchResult ?? SearchResult()
                            let date1 = objSearcheData1.modifiedOn.convertStringToDate(actualFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ, expectedFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ)
                            let date2 = objSearcheData2.modifiedOn.convertStringToDate(actualFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ, expectedFormat: DATEFORMATTERS.YYYYMMDDTHHMMSSZ)
                            return (date2!.compare(date1!) == ComparisonResult.orderedAscending)
                        })
                        
                        ProgressManager.dismiss()
                        completion("")
                        
                    } else {
                        ProgressManager.dismiss()
                        completion(getValueFromDictionary(dictionary: dict, forKey: "message"))
                        //                        ProgressManager.showError(withStatus: getValueFromDictionary(dictionary: dict, forKey: "message"), on: self.rootController?.view)
                    }
                }
            }
        }
    }
    
    func numberofItems(section: Int) -> Int {
        return self.arrSearchResult.count
    }
    
    func getSearchByImage( itemArray: NSArray, completion: @escaping (_ error: String) -> Void) {
        
        let dict: NSDictionary = [:]
        
        AFManager.sendMultipartRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SearchByImage, parameters: dict, multipart: itemArray, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
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
    
    func checkDuplicateManufacture( manufactureName: String, brandName: String, rootController: BaseViewController) {
        
        if manufactureName.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.EmptyManufacturer, on: rootController.view)
            return
        } else if brandName.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.EmptyBrandName, on: rootController.view)
            return
        }
        
        ProgressManager.show(withStatus: "", on: rootController.view)
        let dict: NSDictionary = [ENTITIES.manufacture: manufactureName, ENTITIES
            .brandName: brandName]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.DuplicateManufactureName, parameters: dict, serviceCount: 1) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error == nil {
                ProgressManager.dismiss()
                if let controller = rootController.instantiate(AddDetailsViewController.self, storyboard: STORYBOARD.main) as? AddDetailsViewController {
                    //controller.menufeacture = manufactureName
                    //controller.brandname = brandName
                   // controller.isCalledFrom = 2
                    
                    let implantObj = SearchResult()
                    implantObj.objectName = brandName
                    implantObj.implantManufacture = manufactureName
                    
                    controller.implantObj = implantObj
                    rootController.navigationController?.pushViewController(controller, animated: true)
                }
            } else {
                ProgressManager.showError(withStatus: error, on: rootController.view, completion: nil)
            }
        }
    }
    
    func sendEmail( implantId: String) {
        let dict: NSDictionary = [ENTITIES.implantId: implantId]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SendEmail, parameters: dict, serviceCount: 1) { (response: AnyObject?, error: String?, errorCode: String?) in
                  
        }
    }
}
