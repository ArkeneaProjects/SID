//
//  CustomLabel.swift
//  Viva
//
//  Created by Arkenea on 07/07/16.
//  Copyright © 2016 Arkenea. All rights reserved.
//

import UIKit

open class CustomLabel: UILabel {
    
    @IBInspectable var autoFont: Bool = false
    @IBInspectable var fontSize: CGFloat = 0
    
    @IBInspectable var isAttributed: Bool = false
    @IBInspectable var attributedFonts: String = ""
    @IBInspectable var attributedSizes: String = ""
    
    @IBInspectable var shouldRotate: Bool = false
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        if autoFont == true {
            if isAttributed == true {
                self.attributedText = CustomBase.getModifiedAttributedString(self.attributedText!, withFonts: self.attributedFonts, withSizes: self.attributedSizes, defaultFontSize: self.fontSize)
            } else {
                if isDevice() == DEVICES.iPhoneX || isDevice() == DEVICES.iPhoneXR {
                    let size: CGFloat = safeAreaHeight() * (fontSize / baseHeight)
                    self.font = UIFont(name: self.font!.fontName, size: size)
                } else {
                    let size: CGFloat =  UIScreen.main.bounds.size.height * (fontSize / baseHeight)
                    self.font = UIFont(name: self.font!.fontName, size: size)
                }
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if shouldRotate == true {
            let context: CGContext = UIGraphicsGetCurrentContext()!
            context.saveGState()
            context.rotate(by: -(CGFloat(Double.pi) / 2.0))
            let style: NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
            style.alignment = self.textAlignment
            let textSize: CGSize = self.text!.size(withAttributes: [NSAttributedString.Key.font: self.font!, NSAttributedString.Key.foregroundColor: self.textColor!, NSAttributedString.Key.paragraphStyle: style])
            let middleY: CGFloat = (self.bounds.size.width - textSize.height) / 2.0
            var marginX: CGFloat = (self.bounds.size.height-textSize.width)/2.0
            if self.textAlignment == NSTextAlignment.left {
                let margin = marginX + marginX
                marginX = margin
            } else if self.textAlignment == NSTextAlignment.right {
                marginX = 0
            }
            self.text!.draw(at: CGPoint(x: -(marginX + textSize.width), y: middleY), withAttributes: ([NSAttributedString.Key.font: self.font!, NSAttributedString.Key.foregroundColor: self.textColor!, NSAttributedString.Key.paragraphStyle: style]))
            context.restoreGState()
        } else {
            super.drawText(in: rect)
        }
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
