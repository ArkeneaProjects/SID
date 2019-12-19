//
//  Categories.swift
//  Kethan
//
//  Created by Apple on 22/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

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
}

extension UIImage {
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
}
