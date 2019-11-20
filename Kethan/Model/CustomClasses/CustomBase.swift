//
//  CustomBase.swift
//  Viva
//
//  Created by Arkenea on 22/07/16.
//  Copyright © 2016 Arkenea. All rights reserved.
//

import UIKit

let baseHeight: CGFloat = (((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)) ?1024.0:568.0)

open class CustomBase: NSObject {
    
    static func getModifiedAttributedString(_ attributedString: NSAttributedString, withFonts attributedFonts: String, withSizes attributedSizes: String, defaultFontSize: CGFloat) -> NSAttributedString {
//        var index = 0
//        let attrStr: NSMutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
//        
////        let fontNames: NSArray!
////        let fontSizes: NSArray!
//        
////        if(attributedFonts.count > 0)
////        {
////           let fontNames = attributedFonts.components(separatedBy: ",")
////           let fontSizes = attributedSizes.components(separatedBy: ",")
////        }
////        else
////        {
////            let fontNames = NSArray()
////            let fontSizes = NSArray()
////            
////        }
//         let fontNames: NSArray = (attributedFonts.count > 0) ? attributedFonts.components(separatedBy: ",") : [String]
//        let fontSizes: NSArray = (attributedSizes.count > 0) ? attributedSizes.components(separatedBy: ",") : [String]
//        
////        attrStr.enumerateAttributes(in: NSMakeRange(0, attrStr.string.count), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired, using: {
//        // (attributes: [String :AnyObject], range: NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
//
//        attrStr.enumerateAttributes(in: NSMakeRange(0, attrStr.string.count), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired, using: {
//            (attributes : [String : Any], range:NSRange, stop: UnsafeMutablePointer<ObjCBool>) in
//            
//            
//            let mutableAttributes: NSMutableDictionary = NSMutableDictionary(dictionary: attribute_set)
//            let currentFont: UIFont = (mutableAttributes.value(forKey: NSFontAttributeName) as! UIFont)
//            let currentSize: CGFloat = (fontSizes.count > index) ? CGFloat(Float(fontSizes.object(at: index) as! String)!) : defaultFontSize
//            let newFontSize: CGFloat = UIScreen.main.bounds.size.height * (currentSize / baseHeight)
//            
//            let customName: String = (fontNames.count > index) ?(fontNames.count > index) ?(fontNames.object(at: index) as! String):currentFont.fontName:currentFont.fontName
//            let newFontName: String = (customName == currentFont.fontName) ?customName:(currentFont.fontName.replacingOccurrences(of: "Regular", with: customName))
//            let newFont: UIFont = UIFont(name: newFontName, size: newFontSize)!
//            
//            mutableAttributes.setValue(newFont, forKey: NSFontAttributeName)
//            attrStr.setAttributes(NSDictionary(dictionary: mutableAttributes) as? [String : AnyObject], range: range)
//            
//            index += 1
//        })
//
//        
//        return NSAttributedString(attributedString: attrStr)
    
    return NSAttributedString(attributedString: attributedString)
    }
    
    static func getDoneButton(_ textField: UITextField!, textView: UITextView!, target: UIViewController, selector: Selector) -> UIToolbar {
        let toolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44.0))
        toolbar.isTranslucent = false
        toolbar.tintColor = UIColor.white
        toolbar.barTintColor = UIColor.clear
        
        let doneButton = CustomBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: target, action: selector)
        doneButton.textField = textField
        doneButton.textView = textView
        let flexibleButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [flexibleButton, doneButton]
        return toolbar
    }
}
