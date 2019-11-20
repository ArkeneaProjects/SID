//
//  CustomButton.swift
//  VIVA
//
//  Created by Arkenea on 07/07/16.
//  Copyright © 2016 Arkenea. All rights reserved.
//

import UIKit

open class CustomButton: UIButton {

    var indexPath: IndexPath = IndexPath()
   
    
    @IBInspectable var autoFont: Bool = false
    @IBInspectable var fontSize: CGFloat = 0
    
    @IBInspectable var isAttributed: Bool = false
    @IBInspectable var attributedFonts: String = ""
    @IBInspectable var attributedSizes: String = ""
    
    @IBInspectable var titleCentered: Bool = true
    
    @IBInspectable var animateTap: Bool = false
    @IBInspectable var underline: Bool = false
    @IBInspectable var titlePadding: CGFloat = 0
    @IBInspectable var arrangeTitle: Bool = false
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        if autoFont == true {
            if isAttributed == true {
                self.titleLabel!.attributedText = CustomBase.getModifiedAttributedString(self.titleLabel!.attributedText!, withFonts: self.attributedFonts, withSizes: self.attributedSizes, defaultFontSize: self.fontSize)
            } else {
                if isDevice() == DEVICES.iPhoneX || isDevice() == DEVICES.iPhoneXR {
                    let size: CGFloat = safeAreaHeight() * (fontSize / baseHeight)
                    self.titleLabel!.font = UIFont(name: self.titleLabel!.font.fontName, size: size)
                } else {
                    let size: CGFloat =  UIScreen.main.bounds.size.height * (fontSize / baseHeight)
                    self.titleLabel!.font = UIFont(name: self.titleLabel!.font.fontName, size: size)
                }
  
            }
        }
        
        if titleCentered {
            self.titleLabel?.numberOfLines = 0
            self.titleLabel?.textAlignment = NSTextAlignment.center
            self.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        }
        
        if underline {
            let titleString: NSMutableAttributedString = NSMutableAttributedString(string: (self.titleLabel?.text)!)
            titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, (self.titleLabel?.text!.count)!))
            titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: (self.titleLabel?.textColor)!, range: NSMakeRange(0, (self.titleLabel?.text!.count)!))
            self.setAttributedTitle(titleString, for: UIControl.State())
        }
        
        let height = UIScreen.main.bounds.size.height
        self.titleEdgeInsets = UIEdgeInsets(top: height * (self.titleEdgeInsets.top / baseHeight), left: height * (self.titleEdgeInsets.left / baseHeight), bottom: height * (self.titleEdgeInsets.bottom / baseHeight), right: height * (self.titleEdgeInsets.right / baseHeight))
        self.imageEdgeInsets = UIEdgeInsets(top: height * (self.imageEdgeInsets.top / baseHeight), left: height * (self.imageEdgeInsets.left / baseHeight), bottom: height * (self.imageEdgeInsets.bottom / baseHeight), right: height * (self.imageEdgeInsets.right / baseHeight))
        self.contentEdgeInsets = UIEdgeInsets(top: height * (self.contentEdgeInsets.top / baseHeight), left: height * (self.contentEdgeInsets.left / baseHeight), bottom: height * (self.contentEdgeInsets.bottom / baseHeight), right: height * (self.contentEdgeInsets.right / baseHeight))
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        if arrangeTitle == true {
            let kTextTopPadding: CGFloat = UIScreen.main.bounds.size.height * (titlePadding / baseHeight)
            var titleLabelFrame = self.titleLabel!.frame
            let labelSize = titleLabel!.sizeThatFits(CGSize(width: self.contentRect(forBounds: self.bounds).width, height: CGFloat.greatestFiniteMagnitude))
            var imageFrame = self.imageView!.frame
            let fitBoxSize = CGSize(width: max(imageFrame.size.width, labelSize.width), height: labelSize.height + kTextTopPadding + imageFrame.size.height)
            let fitBoxRect = self.bounds.insetBy(dx: (self.bounds.size.width - fitBoxSize.width)/2, dy: (self.bounds.size.height - fitBoxSize.height)/2)
            
            imageFrame.origin.y = fitBoxRect.origin.y
            imageFrame.origin.x = fitBoxRect.midX - (imageFrame.size.width/2)
            self.imageView!.frame = imageFrame
            
            titleLabelFrame.size.width = self.bounds.size.width
            titleLabelFrame.size.height = labelSize.height
            titleLabelFrame.origin.x = 0
            titleLabelFrame.origin.y = fitBoxRect.origin.y + imageFrame.size.height + kTextTopPadding
            self.titleLabel!.frame = titleLabelFrame
            self.titleLabel!.textAlignment = NSTextAlignment.center
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if animateTap == true {
            self.titleLabel!.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        if animateTap == true {
            self.titleLabel!.transform = CGAffineTransform.identity
        }
    }
}
