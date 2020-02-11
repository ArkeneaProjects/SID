//
//  SearchVM.swift
//  Kethan
//
//  Created by Apple on 30/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SearchVM: NSObject {
    
    var manufecture: String = ""
    var brandname: String = ""
    var searchImage: UIImage?
 
    var arrSearchResult = [SearchResult] ()
    var rootController: BaseViewController?
    
    override init() {
           
    }
    
    func getAllSearchByText(completion: @escaping (_ error: String) -> Void) {
        let dict: NSDictionary = ["manufecture": self.manufecture,
                                  "brandName": self.brandname]
        
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
    
    func getSearchByImage(imageArray: NSArray ,completion: @escaping (_ error: String) -> Void) {
        
        let dict: NSDictionary = [:]
        
        AFManager.sendMultipartRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SearchByImage, parameters: dict, multipart: imageArray, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error != nil {
                // ProgressManager.showError(withStatus: error, on: self.rootController?.view) {
                completion(error ?? "")
                // }
                
            } else {
                if let dict = response as? NSDictionary, let implantDict = dict.value(forKeyPath: "implantApi") as? NSDictionary {
                    if getValueFromDictionary(dictionary: implantDict, forKey: "status") == "error" {
                        completion(getValueFromDictionary(dictionary: implantDict, forKey: "message"))
                    } else {
                        if let dataarr = implantDict.value(forKeyPath: "implant") as? [NSDictionary] {
                                self.arrSearchResult = dataarr.map({
                                    let objSearch = SearchResult(dictionary: $0)
                                    if let dictWatson = dict.value(forKeyPath: "wastson") as? NSDictionary, let arrImages = dictWatson.value(forKeyPath: "images")! as? [NSDictionary] {
                                        if arrImages.count > 0 {
                                            if let images = arrImages[0] as? NSDictionary, let object = images.value(forKeyPath: "objects")! as? NSDictionary, let arrCollection = object.value(forKeyPath: "collections")! as? [NSDictionary] {
                                                if let arr = arrCollection.last!["objects"] as? [NSDictionary] {
                                                    let predicate = NSPredicate(format: "object == %@", argumentArray: [objSearch.objectName.lowercased()])
                                                    let filtered = arr.filter { predicate.evaluate(with: $0) }
                                                    if filtered.count > 0 {
                                                        if let dict = filtered.last {
                                                            let value = getValueFromDictionary(dictionary: dict, forKey: "score")
                                                            let valueInt = value.floatValue()*100
                                                            objSearch.match = String(format: "%.0f%% match", valueInt)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    return objSearch
                                })
                                ProgressManager.dismiss()
                                completion("")
                        } else {
                            completion(MESSAGES.errorOccured)
                        }
                    }
                }
            }
        }
    }
    
    func checkDuplicateManufacture(apiCallFrom: Int, rootController: BaseViewController) { //apiCallFrom 0 for search by Text, 1 for search by Image, 2 for upload
        
        if apiCallFrom == 2 {
            if self.manufecture.trimmedString().count == 0 {
                       ProgressManager.showError(withStatus: ERRORS.EmptyManufacturer, on: rootController.view)
                       return
                   } else if self.brandname.trimmedString().count == 0 {
                       ProgressManager.showError(withStatus: ERRORS.EmptyBrandName, on: rootController.view)
                       return
                   }
        }
       
        
        ProgressManager.show(withStatus: "", on: rootController.view)
        let dict: NSDictionary = [ENTITIES.manufacture: self.manufecture, ENTITIES
            .brandName: self.brandname]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.DuplicateManufactureName, parameters: dict, serviceCount: 1) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error == nil {
                ProgressManager.dismiss()
                if apiCallFrom == 0 {
                    if let controller = rootController.instantiate(SearchListViewController.self, storyboard: STORYBOARD.main) as? SearchListViewController {
                        controller.menufeacture = self.manufecture
                        controller.brandname = self.brandname
                        controller.isCalledFrom = 0
                        rootController.navigationController?.pushViewController(controller, animated: true)
                    }

                } else if apiCallFrom == 1 {
                    if let controller = rootController.instantiate(SearchListViewController.self, storyboard: STORYBOARD.main) as? SearchListViewController {
                        controller.searchImage = self.searchImage
                        controller.isCalledFrom = 1
                        rootController.navigationController?.pushViewController(controller, animated: true)
                    }
                } else {
                    if let controller = rootController.instantiate(AddDetailsViewController.self, storyboard: STORYBOARD.main) as? AddDetailsViewController {
                        let implantObj = SearchResult()
                        implantObj.objectName = self.brandname
                        implantObj.implantManufacture = self.manufecture
                        controller.implantObj = implantObj
                        rootController.navigationController?.pushViewController(controller, animated: true)
                    }
                }
                
            } else {
                if errorCode == "525" {
                    ProgressManager.dismiss()
                    rootController.showAlert(title: "Subscription expired", message: "Hey, looks like your subscription has expired. Or you have not subscribe to the application. \n Click to subscribe and be able to look up implants ", yesTitle: "Subscribe", noTitle: "Cancel", yesCompletion: {
                            if let controller = rootController.instantiate(SubScriptionViewController.self, storyboard: STORYBOARD.signup) as? SubScriptionViewController {
                                controller.isComeFromLogin = false
                                rootController.navigationController?.pushViewController(controller, animated: true)
                            }
                    }, noCompletion: nil)
                } else {
                    ProgressManager.showError(withStatus: error, on: rootController.view, completion: nil)
                }
                
            }
        }
    }
    
    func sendEmail( implantId: String) {
        let dict: NSDictionary = [ENTITIES.implantId: implantId]
        
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.SendEmail, parameters: dict, serviceCount: 1) { (response: AnyObject?, error: String?, errorCode: String?) in
            
        }
    }
}
