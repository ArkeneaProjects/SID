//
//  Extensions.swift
//  YupEasy
//
//  Created by Pankaj on 12/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//
import Security
import UIKit

extension NSObject {
    func jsonString() -> String {
        let data: NSData? = try! JSONSerialization.data(withJSONObject: self, options: []) as NSData?
        var jsonStr: String = ""
        if data != nil {
            jsonStr = String(data: data! as Data, encoding: String.Encoding.ascii)!
        }
        return jsonStr
    }
}
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            self.layoutIfNeeded()
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = (newValue > 0)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue.cgColor
        }
    }
    
    static func loadInstanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)![0] as? UIView ?? UIView()
    }
    
    func getSpanshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, 0.0)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        self.insertSubview(blurEffectView, at: 0)
        blurEffectView.addFullResizeConstraints(parent: self)
        self.backgroundColor = UIColor.clear
    }
    
    func constraintWithIdentifier(_ identifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter { $0.identifier == identifier }.first
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }

    func addFullResizeConstraints(parent: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parent, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parent, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parent, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: parent, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
    }
    
    func applyLeftPresent(delay: TimeInterval, duration: TimeInterval) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: -15.0, y: 0)
        
        UIView.animateKeyframes(withDuration: (duration/4.0) * 3.0, delay: delay, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            self.alpha = 1.0
        }) { _ in
            
        }
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            self.transform = CGAffineTransform.identity
        }) { _ in
            
        }
    }
    
    func applyPopPresent(delay: TimeInterval, duration: TimeInterval) {
        self.alpha = 0
        self.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1.2)
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            self.alpha = 1.0
            self.layer.transform = CATransform3DIdentity
        }) { _ in
            
        }
    }
    
    func applyTopPresent(delay: TimeInterval, duration: TimeInterval) {
        self.alpha = 0
        self.transform = CGAffineTransform(translationX: 0, y: -15.0)
        
        UIView.animateKeyframes(withDuration: (duration/4.0) * 3.0, delay: delay, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            self.alpha = 1.0
        }) { _ in
            
        }
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: UIView.KeyframeAnimationOptions(rawValue: 0), animations: {
            self.transform = CGAffineTransform.identity
        }) { _ in
            
        }
    }
    
    /*func addSizingConstraint(with attribute: NSLayoutAttribute, constraint: CGFloat) {
     addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constraint))
     }
     
     func addEqualConstraint(to anotherView: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat) {
     anotherView.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: anotherView, attribute: attribute, multiplier: multiplier, constant: 0))
     }
     
     func addCenterConstraint(to anotherView: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat, constraint: CGFloat) {
     anotherView.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: anotherView, attribute: attribute, multiplier: multiplier, constant: constraint))
     }
     
     func addAlignmentConstraint(to anotherView: UIView, attribute: NSLayoutAttribute, multiplier: CGFloat, constraint: CGFloat) {
     anotherView.addConstraint(NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: anotherView, attribute: attribute, multiplier: multiplier, constant: constraint))
     }
     
     func addSpacingConstraint(to anotherView: UIView, firstAttribute: NSLayoutAttribute, secondAttribute: NSLayoutAttribute, multiplier: CGFloat, constraint: CGFloat) {
     anotherView.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: firstAttribute, relatedBy: .equal, toItem: anotherView, attribute: secondAttribute, multiplier: multiplier, constant: constraint))
     }
     
     func addRatioConstraint(withFirstAttribute firstAttribute: NSLayoutAttribute, secondAttribute: NSLayoutAttribute, multiplier: CGFloat) {
     addConstraint(NSLayoutConstraint(item: self, attribute: firstAttribute, relatedBy: .equal, toItem: self, attribute: secondAttribute, multiplier: multiplier, constant: 0))
     }*/
    
    func addSelfConstraint(firstAttribute: NSLayoutConstraint.Attribute, secondAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat, constraint: CGFloat) {
        addConstraint(NSLayoutConstraint(item: self, attribute: firstAttribute, relatedBy: .equal, toItem: nil, attribute: secondAttribute, multiplier: multiplier, constant: constraint))
    }
    
    func addChildConstraint(anotherView: UIView, firstAttribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, secondAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat, constraint: CGFloat) {
        anotherView.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: firstAttribute, relatedBy: relation, toItem: anotherView, attribute: secondAttribute, multiplier: multiplier, constant: constraint))
    }
    
    func addParentConstraint(anotherView: UIView, firstAttribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, secondAttribute: NSLayoutConstraint.Attribute, multiplier: CGFloat, constraint: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: anotherView, attribute: firstAttribute, relatedBy: relation, toItem: self, attribute: secondAttribute, multiplier: multiplier, constant: constraint))
    }
    
    static func mk_loadInstanceFromNib() -> UIView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)![0] as? UIView ?? UIView()
    }
    
}
extension UIToolbar {
    
    func ToolbarPiker(mySelect: Selector, cancel: Selector, doneTitle: String, cancelTitle: String) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: doneTitle, style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: cancelTitle, style: UIBarButtonItem.Style.plain, target: self, action: cancel)

        toolBar.setItems([ cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
}
extension UIColor {
    convenience init(hexCode: UInt32) {
        let red = CGFloat((hexCode & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hexCode & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hexCode & 0xFF)/256.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    convenience init(hexString: String) {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            self.init(red: 120.0/255.0, green: 120.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        } else {
            var rgbValue: UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            
            self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                      alpha: CGFloat(1.0))
        }
    }
    
    convenience init(gray: CGFloat) {
        self.init(red: gray/255.0, green: gray/255.0, blue: gray/255.0, alpha: 1.0)
    }
    
    convenience init(rgb: CGFloat, alpha: CGFloat) {
        self.init(red: rgb/255.0, green: rgb/255.0, blue: rgb/255.0, alpha: alpha)
    }
    
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let color = CIColor(color: self)
        return (color.red, color.green, color.blue, color.alpha)
    }
}

extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}

extension UIWindow {
    func setWindowRootViewController(rootController: UIViewController) {
        let previousRootViewController: UIViewController? = self.rootViewController
        
       // self.rootViewController = rootController
        
        for subview in self.subviews {
            if String(describing: type(of: subview)).lowercased() == "uitransitionview" {
                subview.removeFromSuperview()
            }
        }
        
        if previousRootViewController != nil {
            previousRootViewController?.dismiss(animated: false, completion: {
                if let view = previousRootViewController?.view {
                    view.removeFromSuperview()
                }
            })
        }
    }
    
    class func getTopControllerWithCompletion(completion: (_ controller: BaseViewController) -> Void) {
        if let rootController = AppDelegate.delegate()!.window?.rootViewController as? UITabBarController {
            if let frontController = rootController.selectedViewController as? UINavigationController {
                let lastController = self.getLastControllerWithCompletion(controller: frontController)
                if let topController = self.getTopPresentedControllerWithCompletion(controller: lastController) {
                    if let baseController = topController as? BaseViewController {
                        completion(baseController)
                    }
                }
            }
        }
        
        if let frontController = AppDelegate.delegate()!.window?.rootViewController as? UINavigationController {
            let lastController = self.getLastControllerWithCompletion(controller: frontController)
            if let topController = self.getTopPresentedControllerWithCompletion(controller: lastController) {
                if let baseController = topController as? BaseViewController {
                    completion(baseController)
                }
            }
        }
    }
    
    class func getLastControllerWithCompletion(controller: UINavigationController?) -> UIViewController? {
        if let last = controller?.viewControllers.last as? UINavigationController {
            return self.getLastControllerWithCompletion(controller: last)
        }
        return controller?.viewControllers.last
    }
    
    class func getTopPresentedControllerWithCompletion(controller: UIViewController?) -> UIViewController? {
        if let presented = controller?.presentedViewController {
            return self.getTopPresentedControllerWithCompletion(controller: presented)
        }
        return controller
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController) as? BaseViewController ?? BaseViewController()
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: CGColor, thickness: CGFloat, width: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: width, height: thickness)
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.bounds.height - thickness, width: width, height: thickness)
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.bounds.height)
        case UIRectEdge.right:
            border.frame = CGRect(x: width - thickness, y: 0, width: thickness, height: self.bounds.height)
        default:
            break
        }
        border.backgroundColor = color
        self.addSublayer(border)
    }
}


extension UITableView {
    func registerNibWithIdentifier(_ identifiers: NSArray) {
        for identifier in identifiers {
            self.register(UINib(nibName: identifier as? String ?? "Cell", bundle: nil), forCellReuseIdentifier: identifier as? String ?? "Cell")
        }
    }
}

