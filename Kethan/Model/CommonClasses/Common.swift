//
//  Common.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

typealias VoidCompletion = () -> Void

let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width
var isLoginViewAnimated: Bool = true

func isDevice() -> String {
    if screenHeight == 896 {
        return DEVICES.iPhoneXR
    } else if screenHeight == 812 {
        return DEVICES.iPhoneX
    } else if screenHeight == 736 {
        return DEVICES.iPhonePlus
    } else if screenHeight == 667 {
        return DEVICES.iPhone6
    } else {
        return DEVICES.iPhoneSE
    }
}
func getCalculated(_ value: CGFloat) -> CGFloat {
        if isDevice() == DEVICES.iPhoneX || isDevice() == DEVICES.iPhoneXR {
            return safeAreaHeight() * (value / 568.0)
        } else {
            return screenHeight * (value / 568.0)
        }
    }

func safeAreaHeight() -> CGFloat {
    return (isDevice() == DEVICES.iPhoneX) ?667:751
}

func getValueFromDictionary(dictionary: NSDictionary, forKey key: String) -> String {
    var boolCheck: [String: Bool]?
    let object: AnyObject? = dictionary.object(forKey: key) as AnyObject
    
    if object == nil {
        return ""
    } else if object?.isKind(of: NSNull.classForCoder()) == true {
        return ""
    } else  if object?.isKind(of: NSArray.classForCoder()) == true {
        return ""
    } else if object?.isKind(of: NSNumber.classForCoder()) == true {
        let value: NSNumber = object as? NSNumber ?? 0
        return value.stringValue
    } else if object?.isKind(of: NSString.classForCoder()) == true {
        return object as? String ?? String()
    } else if boolCheck?[key] == true {
        return "true"
    } else if boolCheck?[key] == false {
        return "false"
    } else {
        return ""
    }
}

func getObjectFromDictionary(dictionary: NSDictionary, forKey key: String, isArray array: Bool) -> AnyObject {
    let object: AnyObject? = dictionary.object(forKey: key) as AnyObject
    
    if object == nil {
        return (array) ?NSArray(): NSDictionary()
    } else if object?.isKind(of: NSNull.classForCoder()) == true {
        return (array) ?NSArray(): NSDictionary()
    } else if object?.isKind(of: NSString.classForCoder()) == true {
        if (object as? String ?? String()).count > 0 {
            return (object as? String ?? String()).jsonObject()
        } else {
            return (array) ?NSArray(): NSDictionary()
        }
    } else {
        if array {
            if object?.isKind(of: NSArray.classForCoder()) == true {
                return object!
            } else {
                return NSArray()
            }
        } else {
            if object?.isKind(of: NSDictionary.classForCoder()) == true {
                return object!
            } else {
                return NSDictionary()
            }
        }
    }
}

// to check for the visible controller
func getTopViewController() -> BaseViewController? {
    if let rootViewController = AppDelegate.delegate()?.window?.rootViewController {
        if let tabBarViewController = rootViewController as? UITabBarController {
            if let navbarViewController = tabBarViewController.selectedViewController as? UINavigationController {
                if let topViewController = navbarViewController.topViewController {
                    if let presentedViewController = topViewController.presentedViewController {
                        return presentedViewController as? BaseViewController
                    } else {
                        return topViewController as? BaseViewController
                    }
                } else {
                    return nil
                }
            } else {
                return tabBarViewController.selectedViewController as? BaseViewController
            }
        } else if let navbarViewController = rootViewController as? UINavigationController {
            if let topViewController = navbarViewController.topViewController {
                if let presentedViewController = topViewController.presentedViewController {
                    return presentedViewController as? BaseViewController
                } else {
                    return topViewController as? BaseViewController
                }
            } else {
                return nil
            }
        } else {
            return rootViewController as? BaseViewController
        }
    }
    return nil
}
