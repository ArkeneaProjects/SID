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
            self.layer.cornerRadius = getCalculated(newValue)
            self.layer.masksToBounds = (getCalculated(newValue) > 0)
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = getCalculated(newValue)
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

extension UIPageControl {
    
    func customPageControl(dotFillColor: UIColor, dotBorderColor: UIColor, dotBorderWidth: CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            if self.currentPage == pageIndex {
                dotView.backgroundColor = dotFillColor
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
            } else {
                dotView.backgroundColor = .clear
                dotView.layer.cornerRadius = dotView.frame.size.height / 2
                dotView.layer.borderColor = dotBorderColor.cgColor
                dotView.layer.borderWidth = dotBorderWidth
            }
        }
    }
    
}
extension UIImage {

    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func compressProfileImage(maxWidth: CGFloat, maxHeight: CGFloat) -> UIImage {
        var actualHeight: CGFloat = self.size.height
        var actualWidth: CGFloat = self.size.width
        
        var imgRatio: CGFloat = actualWidth/actualHeight
        let maxRatio: CGFloat = maxWidth/maxHeight
        let compressionQuality: CGFloat = 0.5;//50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            } else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            } else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect: CGRect = CGRect(x: 0, y: 0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        //let imageData: Data = UIImageJPEGRepresentation(img, compressionQuality)!
        let imageData = img.jpegData(compressionQuality: compressionQuality)
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
        
    }
    
    func imageWithImage(scaledToWidth: CGFloat) -> UIImage {
        let oldWidth = self.size.width
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = self.size.height * scaleFactor
        let newWidth = oldWidth * scaleFactor
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func getFileSizeInfo(allowedUnits: ByteCountFormatter.Units = .useMB,
                         countStyle: ByteCountFormatter.CountStyle = .file) -> String? {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = allowedUnits
        formatter.countStyle = countStyle
        return getSizeInfo(formatter: formatter)
    }
    
    func getFileSize(allowedUnits: ByteCountFormatter.Units = .useMB,
                     countStyle: ByteCountFormatter.CountStyle = .memory) -> Double? {
        guard let num = getFileSizeInfo(allowedUnits: allowedUnits, countStyle: countStyle)?.getNumbers().first else {
            return nil
        }
        
        return Double(truncating: num)
    }
    
    func getSizeInfo(formatter: ByteCountFormatter, compressionQuality: CGFloat = 1.0) -> String? {
        guard let imageData = jpegData(compressionQuality: compressionQuality) else { return nil }
        return formatter.string(fromByteCount: Int64(imageData.count))
    }
}

extension String {
    
    func numberFormatDecodedString() -> String {
        return self.replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
    }
    
    var isValidURL: Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    
    func trimmedString() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func base64String() -> String {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        return data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
    }
    
    func base64Decoded() -> Data? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return data
        }
        return nil
    }
    
    func base64Decoded123() -> String? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func jsonObject() -> AnyObject {
        let data = self.data(using: String.Encoding.utf8)
        var anyObj: AnyObject? = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions(rawValue: 0)) as AnyObject
        if anyObj == nil {
            anyObj = NSDictionary()
        }
        return anyObj!
    }
    
    func intValue() -> Int {
        return NSString(string: self).integerValue
    }
    
    func floatValue() -> Float {
        return NSString(string: self).floatValue
    }
    
    func doubleValue() -> Double {
        return NSString(string: self).doubleValue
    }
    
    func isAlphaneumeric() -> Bool {
        let alphabetSet: CharacterSet = CharacterSet(charactersIn: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/")
        let numberSet: CharacterSet = CharacterSet(charactersIn: "0123456789")
        
        let string: NSString = NSString(string: self)
        var range: NSRange = string .rangeOfCharacter(from: alphabetSet)
        
        if range.length > 0 {
            range = string.rangeOfCharacter(from: numberSet)
            if range.length > 0 {
                return true
            }
        }
        return false
    }
    
    func isAlphaNeumeric() -> Bool {
        let characterset = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz/1234567890")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {return false}
        return true
    }
    
    func hasOnlyAlphabets() -> Bool {
        let characterset = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz' ")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {return false}
        return true
    }
    
    func hasOnlySingleWorld() -> Bool {
        let characterset = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {return false}
        return true
    }
    
    func hasOnlyDigits() -> Bool {
        let characterset = NSCharacterSet(charactersIn: "1234567890+")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {return false}
        return true
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func getNumbers() -> [NSNumber] {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let charset = CharacterSet.init(charactersIn: " ,.")
        return matches(for: "[+-]?([0-9]+([., ][0-9]*)*|[.][0-9]+)").compactMap { string in
            return formatter.number(from: string.trimmingCharacters(in: charset))
        }
    }
    
    // https://stackoverflow.com/a/54900097/4488252
    func matches(for regex: String) -> [String] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: [.caseInsensitive]) else { return [] }
        let matches  = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        return matches.compactMap { match in
            guard let range = Range(match.range, in: self) else { return nil }
            return String(self[range])
        }
    }
}
extension UIImage {
    func drawRectangleOnImage(drawSize: CGRect) -> UIImage? {
           let imageSize = self.size
           UIGraphicsBeginImageContextWithOptions(imageSize, false, self.scale)
       
           self.draw(at: CGPoint.zero)
           let color: UIColor = UIColor.red
           let bpath: UIBezierPath = UIBezierPath(rect: drawSize)
            bpath.lineWidth = 3.0
            color.set()
            bpath.stroke()

           let newImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return newImage
              }
}
extension UIImageView {
    
    func drawRectangle(frameSize: CGSize, imageWidth: CGFloat, imageHight: CGFloat, drawSize: CGRect) {
        
        let Width = frameSize.width//getCalculated(self.frame.size.width)
        let Hight = frameSize.height//getCalculated(self.frame.size.height)
        
        let acutalX = (Width * drawSize.origin.x ) / imageWidth
        let actualY = (Hight * drawSize.origin.y) / imageHight
        let actualWidth = (Width * drawSize.size.width)/imageWidth
        let actualHight = (Hight * drawSize.size.height)/imageHight
        
        let d = Draw(frame: CGRect(x: acutalX, y: actualY, width: actualWidth, height: actualHight))
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.addSubview(d)
    }
}

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirURL = FileManager.default.temporaryDirectory
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
            }
        } catch {
           //catch the error somehow
        }
    }
}
