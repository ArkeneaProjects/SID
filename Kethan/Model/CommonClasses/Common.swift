//
//  Common.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit
import SpinKit

typealias VoidCompletion = () -> Void

let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width
var isLoginViewAnimated: Bool = true
var device_token: String = ""

enum ValidationState {
    case Valid
    case InValid(String)
}

func getUserDefaultsForKey(key: String) -> Any? {
    return UserDefaults.standard.object(forKey: key)
}

func setUserDefaults(value: AnyObject, forKey key: String) {
    UserDefaults.standard.set(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func deleteUserDefaultsForKey(key: String) {
    UserDefaults.standard.removeObject(forKey: key)
    UserDefaults.standard.synchronize()
}

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
    return (isDevice() == DEVICES.iPhoneX) ?667:736
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
                    if topViewController is SWRevealViewController {
                        let controller = (topViewController as? SWRevealViewController)?.frontViewController as? BaseViewController
                       return controller
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

func updateUserDetail(userDetail: NSDictionary) {
    
    //Get Manufacture and Brand Name
    let loginVM = LoginViewModel()
    loginVM.callManutactureAPI()
    
    let user = User.init(dictionary: userDetail)
    AppConstant.shared.updateProfile(updatedProfile: user)
}

func addSpinnerWithStyle(spinnerStyle: RTSpinKitViewStyle, withColor color: UIColor, withBackgroundColor backgroundColor: UIColor, withParent parentView: UIView, ofSize size: Float) {
    let spinner: RTSpinKitView = RTSpinKitView(style: spinnerStyle, color: color.withAlphaComponent(0.5), spinnerSize: CGFloat(size))
    if parentView.viewWithTag(95111111) != nil {
        parentView.viewWithTag(95111111)!.removeFromSuperview()
    }
    let container: UIView = UIView(frame: parentView.bounds)
    container.tag = 95111111
    container.alpha = 0
    container.backgroundColor = backgroundColor
    spinner.center = CGPoint(x: parentView.bounds.midX, y: parentView.bounds.midY)
    spinner.startAnimating()
    container.addSubview(spinner)
    parentView.addSubview(container)
    UIView.animate(withDuration: 0.3, animations: {() -> Void in
        container.alpha = 1.0
    })
}
func removeSpinnerFromView(parentView: UIView) {
    if parentView.viewWithTag(95111111) != nil {
        let spinner = parentView.viewWithTag(95111111)!
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            spinner.alpha = 0.0
        }, completion: {(finished: Bool) -> Void in
            if finished {
                spinner.removeFromSuperview()
            }
        })
    }
}
