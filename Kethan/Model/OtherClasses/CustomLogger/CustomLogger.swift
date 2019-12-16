//
//  CustomLogger.swift

//
//  Created by Pankaj Patil on 20/04/17.
//  Copyright © 2017 Pankaj Patil. All rights reserved.
//

import UIKit
import Foundation

open class CustomLogger: NSObject, UITextFieldDelegate {
    
//    private static var __once: () = {
//            Static.instance = CustomLogger()
//        }()
    
    var wholeText: String = ""
    var highlightIndex: Int = 0
    var matchCount: Int = 0
    var textField: UITextField!
    var textView: UITextView!
    var constBottom: NSLayoutConstraint!
    var attributedText: NSMutableAttributedString = NSMutableAttributedString()
    
//    class var sharedInstance: CustomLogger {
//        struct Static {
//            static var onceToken: Int = 0
//            static var instance: CustomLogger? = nil
//        }
//        _ = CustomLogger.__once
//        return Static.instance!
//    }
    
     static let sharedInstance = CustomLogger()
    
    // MARK: - Custom Functions -
    
    func getFilePath() -> String {
        let directoryPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let filePath: String = NSString(string: directoryPath).appendingPathComponent("Log.txt")
        return filePath
    }
    
    func setupLogger(_ setup: Bool) {
        do {
            if self.isFileExists() == true {
                try FileManager.default.removeItem(atPath: self.getFilePath())
            }
            if setup == true {
                try "".write(toFile: self.getFilePath(), atomically: true, encoding: String.Encoding.utf8)
            }
        } catch {
            
        }
    }
    
    func displayLog() {
        if self.isFileExists() {
            let viewMain: UIView = UIView(frame: UIScreen.main.bounds)
            viewMain.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
            viewMain.tag = 9999
            
            self.removeDisplay(0)
            
            let margin: CGFloat = 20.0
            let gap: CGFloat = 10.0
            let size: CGFloat = 30.0
            
            let viewContent: UIScrollView = UIScrollView()
            viewContent.backgroundColor = UIColor.white
            viewContent.alpha = 0
            viewContent.layer.cornerRadius = 5.0
            viewContent.layer.masksToBounds = true
            viewContent.tag = 8888
            
            self.wholeText = String(data: try! Data(contentsOf: URL(fileURLWithPath: self.getFilePath())), encoding: String.Encoding.utf8)!
            self.attributedText = NSMutableAttributedString(string: self.wholeText)
            self.textView = UITextView(frame: viewContent.bounds)
            self.textView.attributedText = self.attributedText
            self.textView.isEditable = false
            
            self.textField = UITextField()
            self.textField.backgroundColor = UIColor.white
            self.textField.placeholder = "Search here"
            self.textField.autocorrectionType = UITextAutocorrectionType.no
            self.textField.spellCheckingType = UITextSpellCheckingType.no
            self.textField.returnKeyType = UIReturnKeyType.next
            self.textField.borderStyle = UITextField.BorderStyle.roundedRect
            self.textField.delegate = self
            self.textField.tag = 7777
            
            let btnClose: UIButton = UIButton(type: UIButton.ButtonType.custom)
            btnClose.setTitle("X", for: UIControl.State())
            btnClose.backgroundColor = UIColor.black
            btnClose.frame = CGRect(x: viewMain.bounds.size.width - (size + gap), y: margin + gap, width: size, height: size)
            btnClose.setTitleColor(UIColor.white, for: UIControl.State())
            btnClose.addTarget(self, action: #selector(closeAction(_:)), for: UIControl.Event.touchUpInside)
            btnClose.layer.cornerRadius = size / 2.0
            btnClose.layer.borderWidth = 1.0
            btnClose.layer.borderColor = UIColor.white.cgColor
            btnClose.layer.masksToBounds = true
            btnClose.tag = 6666
            
            let superView = UIApplication.shared.delegate!.window!
            
            superView?.addSubview(viewMain)
            viewMain.translatesAutoresizingMaskIntoConstraints = false
            superView!.addConstraint(NSLayoutConstraint(item: viewMain, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
            superView!.addConstraint(NSLayoutConstraint(item: viewMain, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
            superView!.addConstraint(NSLayoutConstraint(item: viewMain, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
            self.constBottom = NSLayoutConstraint(item: viewMain, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0)
            superView!.addConstraint(self.constBottom)
            
            viewMain.addSubview(viewContent)
            viewContent.translatesAutoresizingMaskIntoConstraints = false
            viewMain.addConstraint(NSLayoutConstraint(item: viewContent, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMain, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: gap))
            viewMain.addConstraint(NSLayoutConstraint(item: viewContent, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMain, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: -gap))
            viewMain.addConstraint(NSLayoutConstraint(item: viewContent, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMain, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: margin + size + gap + gap))
            viewMain.addConstraint(NSLayoutConstraint(item: viewContent, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMain, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: -gap))
            
            viewMain.addSubview(self.textField)
            self.textField.translatesAutoresizingMaskIntoConstraints = false
            self.textField.addConstraint(NSLayoutConstraint(item: self.textField, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: viewMain.bounds.size.width - (size + gap + gap + gap)))
            self.textField.addConstraint(NSLayoutConstraint(item: self.textField, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: size))
            
            viewMain.addConstraint(NSLayoutConstraint(item: self.textField, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMain, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: gap))
            viewMain.addConstraint(NSLayoutConstraint(item: self.textField, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMain, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: -(size + gap + gap)))
            viewMain.addConstraint(NSLayoutConstraint(item: self.textField, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewMain, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: margin + gap))
            viewMain.addConstraint(NSLayoutConstraint(item: viewContent, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.textField, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: gap))
            
            viewContent.addSubview(self.textView)
            self.textView.translatesAutoresizingMaskIntoConstraints = false
            viewContent.addConstraint(NSLayoutConstraint(item: self.textView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContent, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
            viewContent.addConstraint(NSLayoutConstraint(item: self.textView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContent, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
            viewContent.addConstraint(NSLayoutConstraint(item: self.textView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContent, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
            viewContent.addConstraint(NSLayoutConstraint(item: self.textView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContent, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
            
            viewContent.addConstraint(NSLayoutConstraint(item: self.textView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContent, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1.0, constant: 0))
            viewContent.addConstraint(NSLayoutConstraint(item: self.textView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: viewContent, attribute: NSLayoutConstraint.Attribute.height, multiplier: 1.0, constant: 0))
            
            viewMain.addSubview(btnClose)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
           
            viewMain.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.3, animations: {
                viewMain.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
                viewContent.alpha = 1.0
                }, completion: { (finished: Bool) in
                    if finished == true {
                        self.textView.scrollRangeToVisible(NSRange(location: self.textView.text.count, length: 0))
                    }
            })
        }
    }
    
    func logValues(_ stringToWrite: String) {
        if self.isFileExists() == true {
            let data = stringToWrite.data(using: String.Encoding.utf8, allowLossyConversion: false)!
            do {
            let fileHandle = try FileHandle(forWritingTo: URL(string: self.getFilePath())!)
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)
                fileHandle.closeFile()
            } catch {
                
            }
        }
    }
    
    func isShowing() -> Bool {
        return ((UIApplication.shared.delegate!.window!)!.viewWithTag(9999) != nil)
    }
    
    func isFileExists() -> Bool {
        return (FileManager.default.fileExists(atPath: self.getFilePath()) == true)
    }
    
    func removeDisplay(_ duration: Double) {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
       
        if self.isShowing() {
            let viewMain: UIView = ((UIApplication.shared.delegate!.window!)!.viewWithTag(9999))!
            let viewContent: UIView = viewMain.viewWithTag(8888)!
            let textField: UITextField = viewMain.viewWithTag(7777) as? UITextField ?? UITextField()
            let btnClose: UIButton = viewMain.viewWithTag(6666) as? UIButton ?? UIButton()
            UIView.animate(withDuration: duration, animations: {
                textField.alpha = 0
                btnClose.alpha = 0
                viewContent.alpha = 0
                viewMain.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                }, completion: { (_) in
                    viewMain.removeFromSuperview()
            })
        }
    }
    
    func performAttributionAndScroll(_ finalString: String) {
        self.attributedText.removeAttribute(NSAttributedString.Key.backgroundColor, range: NSRange(location: 0, length: self.wholeText.count))
        do {
            let error: NSError? = nil
            let regex = try NSRegularExpression(pattern: finalString, options: NSRegularExpression.Options.caseInsensitive)
            if error == nil {
                self.matchCount = 0
                for match in regex.matches(in: self.wholeText, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: self.wholeText.count)) as [NSTextCheckingResult] {
                    if self.matchCount == self.highlightIndex {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.textView.scrollRangeToVisible(match.range)
                        })
                        self.attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.red, range: match.range)
                    } else {
                        self.attributedText.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.green, range: match.range)
                    }
                    let value = self.matchCount + 1
                    self.matchCount = value
                }
                if self.matchCount == 0 {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.textView.scrollRangeToVisible(NSRange(location: self.wholeText.count, length: 0))
                    })
                }
            } else {
                self.matchCount = 0
                UIView.animate(withDuration: 0.3, animations: {
                    self.textView.scrollRangeToVisible(NSRange(location: self.wholeText.count, length: 0))
                })
            }
        } catch {
            self.matchCount = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.textView.scrollRangeToVisible(NSRange(location: self.wholeText.count, length: 0))
            })
        }
        self.textView.attributedText = self.attributedText
    }
    
    func handleMotion(_ motion: UIEvent.EventSubtype, withEvent event: UIEvent?, controller: UIViewController) {
        if event!.type == .motion && event!.subtype == .motionShake {
            if self.isShowing() == false && self.isFileExists() == true {
                let actionSheetController: UIAlertController = UIAlertController(title: "Alert", message: "Do you want to show log?", preferredStyle: .alert)
                
                let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .default) { _ -> Void in
                    self.displayLog()
                }
                actionSheetController.addAction(nextAction)
                
                let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .cancel) { _ -> Void in
                    
                }
                actionSheetController.addAction(cancelAction)
                
                controller.present(actionSheetController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Keyboard Functions -
    
    @objc func keyboardWasShown(_ aNotification: Notification) {
        if let infoDict: NSDictionary = aNotification.userInfo as NSDictionary? {
        let keyboardHeight = ((infoDict.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as AnyObject).cgRectValue)!.size.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.constBottom.constant = -keyboardHeight
            self.textView.superview?.superview?.superview?.layoutIfNeeded()
        })
        }
    }
    
    @objc func keyboardWillBeHidden(_ aNotification: Notification) {
        UIView.animate(withDuration: 0.3, animations: {
            self.constBottom.constant = 0
            self.textView.superview?.superview?.superview?.layoutIfNeeded()
        }) 
    }
    
    // MARK: - Button Actions -
    
    @IBAction func closeAction(_ sender: AnyObject) {
        self.removeDisplay(0.3)
    }
    
    @IBAction func resignKeyboard(_ sender: AnyObject) {
        self.textField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate -
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let toolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44.0))
        toolbar.isTranslucent = false
        toolbar.tintColor = UIColor.white
        toolbar.barTintColor = UIColor.black
        
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(resignKeyboard(_:)))
        let flexibleButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [flexibleButton, doneButton]
        textField.inputAccessoryView = toolbar
        return true
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.matchCount > self.highlightIndex {
            let value = self.highlightIndex + 1
            self.highlightIndex = value
        }
        self.performAttributionAndScroll(textField.text!)
        return false
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let finalString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        self.attributedText.removeAttribute(NSAttributedString.Key.backgroundColor, range: NSRange(location: 0, length: self.wholeText.count))
        self.highlightIndex = 0
        self.performAttributionAndScroll(finalString)
        
        return true
    }
}
