//
//  CustomTextField.swift
//  Viva
//
//  Created by Arkenea on 07/07/16.
//  Copyright © 2016 Arkenea. All rights reserved.
//

import UIKit

open class CustomTextField: UITextField {

    var indexPath: IndexPath = IndexPath()
    
    @IBInspectable var autoFont: Bool = false
    @IBInspectable var fontSize: CGFloat = 0
    
    @IBInspectable var padding: CGFloat = 0
    
    @IBInspectable var isAttributed: Bool = false
    @IBInspectable var attributedFonts: String = ""
    @IBInspectable var attributedSizes: String = ""
    
    @IBInspectable var optionalRadius: CGFloat = 0
    @IBInspectable var optionalCorner: CGFloat = 0
    
    @IBInspectable var placeColor: UIColor = UIColor.gray
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        if autoFont == true {
            if isAttributed == true {
                self.attributedText = CustomBase.getModifiedAttributedString(self.attributedText!, withFonts: self.attributedFonts, withSizes: self.attributedSizes, defaultFontSize: self.fontSize)
            } else {
                if isDevice() == DEVICES.iPhoneX || isDevice() == DEVICES.iPhoneXR {
                    let size: CGFloat = safeAreaHeight() * (self.fontSize / baseHeight)
                    self.font = UIFont(name: self.font!.fontName, size: size)
                } else {
                    let size: CGFloat = UIScreen.main.bounds.size.height * (self.fontSize / baseHeight)
                    self.font = UIFont(name: self.font!.fontName, size: size)
                }
                
            }
        }
        
        if self.optionalCorner > 0 {
            let corners: UIRectCorner = (optionalCorner == 1) ?UIRectCorner.topLeft:(optionalCorner == 2) ?UIRectCorner.bottomLeft:(optionalCorner == 3) ?UIRectCorner.bottomRight:(optionalCorner == 4) ?UIRectCorner.topRight:(optionalCorner == 12) ?[UIRectCorner.topLeft, UIRectCorner.bottomLeft]:(optionalCorner == 23) ?[UIRectCorner.bottomLeft, UIRectCorner.bottomRight]:(optionalCorner == 34) ?[UIRectCorner.bottomRight, UIRectCorner.topRight]:(optionalCorner == 41) ?[UIRectCorner.topLeft, UIRectCorner.topRight]:(optionalCorner == 123) ?[UIRectCorner.topLeft, UIRectCorner.bottomLeft, UIRectCorner.bottomRight]:(optionalCorner == 234) ?[UIRectCorner.bottomLeft, UIRectCorner.bottomRight, UIRectCorner.topRight]:(optionalCorner == 341) ?[UIRectCorner.bottomRight, UIRectCorner.topRight, UIRectCorner.topLeft]:(optionalCorner == 412) ?[UIRectCorner.topRight, UIRectCorner.topLeft, UIRectCorner.bottomLeft]:UIRectCorner.allCorners
            
            let radius =  UIScreen.main.bounds.size.height * (self.optionalRadius / baseHeight)
            var rect = self.bounds
            rect.size.width = UIScreen.main.bounds.size.width * (rect.size.width / 320.0)
            rect.size.height =  UIScreen.main.bounds.size.height * (rect.size.height / baseHeight)
            let maskPath: UIBezierPath = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer: CAShapeLayer = CAShapeLayer()
            maskLayer.frame = rect
            maskLayer.path = maskPath.cgPath
            self.layer.mask = maskLayer
        }
        
       // self.setValue(placeColor, forKeyPath: "_placeholderLabel.textColor")
        self.reloadPlaceholder()
        
        let oldText = self.text
        self.text = "1"
        self.text = oldText
    }
    
    func reloadPlaceholder() {
        if self.placeholder?.last == "*"{
            let attribute = NSMutableAttributedString.init(string: self.placeholder!)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange((self.placeholder?.count)! - 1, 1))
            //self.attributedPlaceholder = attribute
        }
    }
    
    func addDoneButton(target: UIViewController, selector: Selector) {
        let toolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        toolbar.isTranslucent = false
        toolbar.tintColor = UIColor.white
        toolbar.tintColor = UIColor(red: 218.0/255.0, green: 33.0/255.0, blue: 40.0/255.0, alpha: 1.0)
       // toolbar.barTintColor = UIColor(218, green: 33, blue: 40)
        
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: target, action: selector)
        let flexibleButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [flexibleButton, doneButton]
        self.inputAccessoryView = toolbar
    }
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        if self.textAlignment == .center {
            return super.textRect(forBounds: bounds)
        } else {
            let finalPadding: CGFloat = ((isDevice() == DEVICES.iPhoneX || isDevice() == DEVICES.iPhoneXR) ?safeAreaHeight(): UIScreen.main.bounds.size.height) * (self.padding / baseHeight)
            //return bounds.insetBy(dx: CGFloat(finalPadding), dy: CGFloat(0))
            let padding = UIEdgeInsets(top: 0, left: finalPadding, bottom: 0, right: 0)
            //return UIEdgeInsetsInsetRect(bounds, padding)
            let newCGRect = bounds.inset(by: padding)
            return newCGRect
        }
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        if self.textAlignment == .center {
            return super.textRect(forBounds: bounds)
        } else {
            let finalPadding: CGFloat = ((isDevice() == DEVICES.iPhoneX || isDevice() == DEVICES.iPhoneXR) ?safeAreaHeight(): UIScreen.main.bounds.size.height) * (self.padding / baseHeight)
            //return bounds.insetBy(dx: CGFloat(finalPadding), dy: CGFloat(0))
            let padding = UIEdgeInsets(top: 0, left: finalPadding, bottom: 0, right: 0)
           // return UIEdgeInsetsInsetRect(bounds, padding)
            let newCGRect = bounds.inset(by: padding)
            return newCGRect
        }
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if self.textAlignment == .center {
            return super.textRect(forBounds: bounds)
        } else {
            let finalPadding: CGFloat = ((isDevice() == DEVICES.iPhoneX) ?safeAreaHeight(): UIScreen.main.bounds.size.height) * (self.padding / baseHeight)
            //return bounds.insetBy(dx: CGFloat(finalPadding), dy: CGFloat(0))
            let padding = UIEdgeInsets(top: 0, left: finalPadding, bottom: 0, right: 0)
            // return UIEdgeInsetsInsetRect(bounds, padding)
            let newCGRect = bounds.inset(by: padding)
            return newCGRect
        }
    }
    
    func setBorderToTextField(width: CGFloat, borderColor: CGColor) {
        let border = CALayer()
        border.borderWidth = width
        border.borderColor = borderColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - border.borderWidth, width: self.frame.size.width, height: self.frame.size.height)
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect] {
        // Drawing code
    }
    */

}
