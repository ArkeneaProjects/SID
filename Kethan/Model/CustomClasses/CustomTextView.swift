//
//  CustomTextView.swift
//  Viva
//
//  Created by Arkenea on 19/07/16.
//  Copyright © 2016 Arkenea. All rights reserved.
//

import UIKit

open class CustomTextView: UITextView {

    var indexPath: IndexPath = IndexPath()
    
    @IBInspectable var autoFont: Bool = false
    @IBInspectable var fontSize: CGFloat = 0
    
    @IBInspectable var autoSize: Bool = false
    @IBInspectable var maxLines: Int = 0
    
    @IBInspectable var isAttributed: Bool = false
    @IBInspectable var attributedFonts: String = ""
    @IBInspectable var attributedSizes: String = ""
    @IBInspectable var placeholderfontSize: CGFloat = 0
    private var placeholderLabel: UILabel = UILabel()
    
    private var placeholderLabelConstraints = [NSLayoutConstraint]()
    @IBInspectable public var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    @IBInspectable var placeholderColor: UIColor! {
        didSet {
            placeholderLabel.textColor = placeholderColor
        }
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        if autoFont == true && self.isSelectable == true {
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
        
       // self.setValue(placeholderColor, forKeyPath: "_placeholderLabel.textColor")
//        var placeholderAttributedString = NSMutableAttributedString(attributedString: self.placeholderLabel.attributedPlaceholder)
//       placeholderAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: self.placeholderLabel.length))
//       self.placeholderLabel.attributedPlaceholder = placeholderAttributedString
        
        
    }
    private struct Constants {
        static let defaultiOSPlaceholderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0980392, alpha: 0.22)
    }
    override open func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        if self.autoSize == true {
            var constraintHeight: NSLayoutConstraint! = nil
            for constraint in self.constraints {
                if constraint.firstAttribute == NSLayoutConstraint.Attribute.height {
                    constraintHeight = constraint
                    break
                } else {
                    
                }
            }
            
            if constraintHeight != nil {
                if self.font != nil {
                    if self.contentSize.height > self.frame.size.height && (self.font?.lineHeight)! * CGFloat(self.maxLines) > self.frame.size.height {
                        constraintHeight.constant = (self.font?.lineHeight)! * CGFloat(self.maxLines)
                    } else {
                        constraintHeight.constant = self.contentSize.height
                    }
                } else {
                    if self.contentSize.height > self.frame.size.height && (self.fontSize + 8.0) * CGFloat(self.maxLines) > self.frame.size.height {
                        constraintHeight.constant = (self.fontSize + 8.0) * CGFloat(self.maxLines)
                    } else {
                        constraintHeight.constant = self.contentSize.height
                    }
                }
            }
        }
    }
    
    func numberOfLines() -> Int {
        if let fontUnwrapped = self.font {
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
    func addDoneButton(_ target: UIViewController, selector: Selector) {
        self.inputAccessoryView = CustomBase.getDoneButton(nil, textView: self, target: target, selector: selector)
    }
    
    //Place Holder
    override open var font: UIFont! {
        didSet {
            if isDevice() == DEVICES.iPhoneX || isDevice() == DEVICES.iPhoneXR {
                let size: CGFloat = safeAreaHeight() * (placeholderfontSize / 568.0)
                placeholderLabel.font = UIFont(name: self.font!.fontName, size: size)
            } else {
                let size: CGFloat = UIScreen.main.bounds.size.height * (placeholderfontSize / 568.0)
                placeholderLabel.font = UIFont(name: self.font!.fontName, size: size)
            }
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            placeholderLabel.textAlignment = textAlignment
        }
    }
    
    override open var text: String! {
        didSet {
            textDidChange()
        }
    }
    
    override open var attributedText: NSAttributedString! {
        didSet {
            textDidChange()
        }
    }
    
    override open var textContainerInset: UIEdgeInsets {
        didSet {
            updateConstraintsForPlaceholderLabel()
        }
    }
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textDidChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
        
        placeholderLabel.font = font
        placeholderLabel.textColor = placeholderColor
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.text = placeholder
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = UIColor.clear
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(placeholderLabel)
        updateConstraintsForPlaceholderLabel()
    }
    
    private func updateConstraintsForPlaceholderLabel() {
        var newConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(\(textContainerInset.left + 10.0))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-(\(textContainerInset.top))-[placeholder]",
            options: [],
            metrics: nil,
            views: ["placeholder": placeholderLabel])
        newConstraints.append(NSLayoutConstraint(
            item: placeholderLabel,
            attribute: .width,
            relatedBy: .equal,
            toItem: self,
            attribute: .width,
            multiplier: 1.0,
            constant: -(textContainerInset.left + textContainerInset.right + 10.0 * 2.0)
        ))
        removeConstraints(placeholderLabelConstraints)
        addConstraints(newConstraints)
        placeholderLabelConstraints = newConstraints
    }
    
    @objc private func textDidChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - 10.0 * 2.0
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: UITextView.textDidChangeNotification,
                                                  object: nil)
    }
    
    func addDoneButtonInTextView(target: UIViewController, selector: Selector) {
        let toolbar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        toolbar.isTranslucent = false
        toolbar.tintColor = UIColor.white
        toolbar.barTintColor = UIColor(red: 9.0/255.0, green: 133.0/255.0, blue: 233.0/255.0, alpha: 1.0)
        //toolbar.barTintColor = UIColor(218, green: 33, blue: 40)
        
        let doneButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: target, action: selector)
        let flexibleButton = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [flexibleButton, doneButton]
        self.inputAccessoryView = toolbar
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
