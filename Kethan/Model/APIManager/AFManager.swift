//
//  WebServiceManager.swift
//  MYOS
//
//  Created by Arkenea on 1/6/17.
//  Copyright © 2017 Pankaj Arkenea. All rights reserved.
//

import UIKit
import Alamofire
import Photos

typealias APICompletion = (_ response: AnyObject?, _ error: String?, _ errorCode: String?) -> Void
typealias FileDownloadCompletion = (_ isDownloaded: Bool, _ isSaved: Bool, _ fileURL: String, _ error: String) -> Void

let ErrorCodeOffline = -1009, ErrorCodeTimeout = -1001, ErrorCodeConnectionFailed = -1005, ErrorCodeUnexpected = 901, ErrorCodeWrongFormat = 902, ErrorCodeUploadFailed = 903
let ErrorCodeCustom = 23, ErrorCodeIdNotFound = 24, ErrorCodeAuthenticationFail = 401, ErrorCodeFieldInvalid = 14, ErrorCodeFieldRequired = 18

class AFManager: NSObject {
    
    private static let requestCounterStack: NSMutableArray = NSMutableArray()
    
    static var AlamofireManager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [APP_URLS.Domain: .disableEvaluation]
        let manager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default, serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        return manager
    }()
    
    static var AlamofireManagerBackground: SessionManager = {
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "abc.background")
        
        //Default timeout
        configuration.timeoutIntervalForRequest = 10
        
        var manager = Alamofire.SessionManager(configuration: configuration)
        
        return manager
    }()
    
    static func sendGetRequestWithURL(method: HTTPMethod, url: String, completion:@escaping APICompletion) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            if Reachability.isOnline() {
                var token = ""
                if AppConstant.shared.loggedUser.accesstoken.trimmedString().count > 0 {
                    token = AppConstant.shared.loggedUser.accesstoken
                }
                let headers = ["authorization": "\(token)"]
                     
                AlamofireManager.request(url, method: method, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    print("URL -> \(url) \n Bearer==\(token)")
                    print("Response -> \( response.result.value as? NSDictionary)")
                    
                    if let diction = response.result.value as? NSDictionary {
                    CustomLogger.sharedInstance.logValues("URL \n \(url) \n\n respones \n\(String(describing: diction))")
                    
                    if let responseObject = diction.object(forKey: CONSTANT.success) as? String {
                    if responseObject == CONSTANT.Ture {
                    completion(diction, nil, "")
                    } else {
                    let message = diction.object(forKey: CONSTANT.Message) as? String ?? ""
                    completion(nil, message, nil)
                    }
                    } else if let responseObject = diction.object(forKey: CONSTANT.status) as? String {
                    if responseObject == CONSTANT.Ture {
                    completion(diction, nil, "")
                    } else {
                    let message = diction.object(forKey: CONSTANT.Message) as? String ?? ""
                    completion(nil, message, nil)
                    }
                    } else if diction.object(forKey: CONSTANT.status) as? String ==
                    "OK" {
                    completion(diction, nil, "")
                    } else {
                    completion(nil, MESSAGES.errorOccured, "")
                    }
                    
                    } else {
                    // print("URL -> \(url)")
                    //  print("\n\nresponse -> \n\(String(data: response.data!, encoding: String.Encoding.utf8) ?? "")\n")
                    completion(nil, MESSAGES.errorOccured, "")
                    }
                }
            } else {
                DispatchQueue.main.async(execute: {
                    completion(nil, MESSAGES.internetOffline, "")
                })
            }
        }
    }
    
    static func sendPostRequestWithParameters(method: HTTPMethod, urlSuffix: String, parameters: NSDictionary, serviceCount: NSInteger, completion: @escaping APICompletion) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            if Reachability.isOnline() {
                
                var token = ""
                if AppConstant.shared.loggedUser.accesstoken.trimmedString().count > 0 {
                    token = AppConstant.shared.loggedUser.accesstoken
                }
                let headers = ["headers": "\(token)", "Content-Type": "application/json"]

                var strURL = urlSuffix
                if !strURL.isValidURL {
                    strURL = String(format: "%@%@", APP_URLS.Domain, urlSuffix)
                }
                
                AlamofireManager.request(strURL, method: method, parameters: parameters as? Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    
                    self.renderResponse(method: method, urlSuffix: urlSuffix, type: "method", strURL: strURL, headers: headers, parameters: parameters, multipart: [], response: response.result.value, error: response.result.error as NSError?, serviceCount: serviceCount, completion: completion)
                    
                    if response.result.value == nil {
                        //print("\n\nresponse -> \n\(String(data: response.data!, encoding: String.Encoding.utf8) ?? "")\n")
                    }
                }
                
            } else {
                DispatchQueue.main.async(execute: {
                    completion(nil, MESSAGES.internetOffline, "")
                })
            }
        }
    }
    
    static func sendMultipartRequestWithParameters(method: HTTPMethod, urlSuffix: String, parameters: NSDictionary, multipart: NSArray, serviceCount: NSInteger, completion: @escaping APICompletion) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            if Reachability.isOnline() {
                let strURL = String(format: "%@%@", APP_URLS.Domain, urlSuffix)
                
                var token = ""
                if AppConstant.shared.loggedUser.accesstoken.trimmedString().count > 0 {
                    token = AppConstant.shared.loggedUser.accesstoken
                }
                let headers = ["headers": "\(token)", "Content-Type": "application/json"]

                AlamofireManager.upload(multipartFormData: { (formData:MultipartFormData) in
                    for key in parameters.allKeys {
                        let value = parameters.object(forKey: key as? String ?? "") as? String ?? ""
                        formData.append(value.data(using: String.Encoding.utf8)!, withName: key as? String ?? "")
                    }
                    
                    for file in multipart {
                        let multipartFile = file as AnyObject
                        let key = multipartFile.object(forKey: "key") as? String ?? ""
                        let path = multipartFile.object(forKey: "path") as? String ?? ""
                        let name = multipartFile.object(forKey: "name") as? String ?? ""
                        let filURL:URL = URL(fileURLWithPath: path)
                        formData.append(filURL, withName: key, fileName: name, mimeType: "image/png")
                    }
                }, to: strURL, method: .put, headers: headers) { (result: SessionManager.MultipartFormDataEncodingResult) in
                    switch result {
                    case .success(request: let upload, _, _):
                        upload.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                            self.renderResponse(method: method, urlSuffix: urlSuffix, type: "multi", strURL: strURL, headers: headers, parameters: parameters, multipart: multipart, response: response.result.value, error: response.result.error as NSError?, serviceCount: serviceCount, completion: completion)
                        })
                    case .failure(_):
                        let error = NSError(domain: " ORLinkErrorDomain", code: ErrorCodeUploadFailed, userInfo: [NSLocalizedDescriptionKey: MESSAGES.uploadFailed])
                        self.renderResponse(method: method, urlSuffix: urlSuffix, type: "multi", strURL: strURL, headers: headers, parameters: parameters, multipart: multipart, response: nil, error: error, serviceCount: serviceCount, completion: completion)
                    }
                }
            } else {
                DispatchQueue.main.async(execute: {
                    completion(nil, MESSAGES.internetOffline, "")
                })
            }
        }
    }
    
    private static func renderResponse(method: HTTPMethod, urlSuffix: String, type: String, strURL: String, headers: [String: String], parameters: NSDictionary, multipart: NSArray, response: Any?, error: NSError?, serviceCount: NSInteger, completion: @escaping APICompletion) {
        DispatchQueue.main.async(execute: {
            let webServiceData = "\n\nRequest -> \n\(strURL)\n\nHeaders -> \n\(headers)\n\nParameters -> \n\(parameters.jsonString())\n\nResponce -> \n\(response ?? "")"
            print(webServiceData)
            CustomLogger.sharedInstance.logValues("request \n \(parameters) \n\n respones \n\(String(describing: response))")
            if response != nil {
                var jsonObject: NSDictionary?
                if let responseDict = response as? NSDictionary {
                    jsonObject = responseDict
                } else if let responseArray = response as? NSArray {
                    if let responseDict = responseArray.firstObject as? NSDictionary {
                        jsonObject = responseDict
                    } else {
                        //need to update code but not necessary
                    }
                } else {
                    //need to update code but not necessary
                }
                
                if jsonObject != nil {
                    if let responseObject = jsonObject!.object(forKey: CONSTANT.status) as? String {
                        if responseObject == CONSTANT.Ture {
                            if let responseDict = jsonObject!.object(forKey: CONSTANT.data) as? NSDictionary {
                                completion(responseDict, nil, "")
                            }
                        } else {
                            if let responseDict = jsonObject!.object(forKey: CONSTANT.data) as? NSDictionary {
                                let message = responseDict.object(forKey: CONSTANT.Message) as? String ?? ""
                                let errorCode = responseDict.object(forKey: CONSTANT.ErrorCode) as? String ?? ""
                                completion(nil, message, errorCode)
                            } else {
                                completion(nil, MESSAGES.errorOccured, "")
                            }
                        }
                    } else {
                        completion(nil, MESSAGES.errorOccured, "")
                    }
                    
                } else {
                    completion(nil, MESSAGES.invalidFormat, "")
                }
            } else if error != nil {
                // completion(nil, error!.localizedDescription, error!.code)
                if error?.localizedDescription == "The network connection was lost." {
                    if 3 > serviceCount {
                        var reqCount: NSInteger = 2
                        if serviceCount == 0 {
                            reqCount = 1
                        } else if serviceCount == 1 {
                            reqCount = 2
                        }
                        sendPostRequestWithParameters(method: method, urlSuffix: urlSuffix, parameters: parameters, serviceCount: reqCount, completion: completion)
                    } else {
                        completion(nil, error?.localizedDescription, "")
                    }
                } else {
                    completion(nil, error?.localizedDescription, "")
                }
            } else {
                completion(nil, MESSAGES.errorOccured, "")
            }
        })
    }
    
}
