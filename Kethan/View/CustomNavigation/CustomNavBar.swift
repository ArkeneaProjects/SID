//
//  CustomNavBar.swift
//  YupEasy
//
//  Created by Pankaj on 12/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit
enum ButtonType: NSInteger {
    case buttonTypeNil = 0, buttonTypeBack, buttonTypeCredit, buttonTypeMenu, buttonTypeSave, buttonTypeEdit, buttonCrop, buttonTypeSkip, buttonTypeAdd
}

class CustomNavBar: UIView {
    @IBOutlet weak var viewNavigationBar: UIView!
    
    @IBOutlet weak var btnLeft: CustomButton!
    @IBOutlet weak var btnRight: CustomButton!
    @IBOutlet weak var btnRightEdit: CustomButton!
    
    @IBOutlet weak var lblTitle: CustomLabel!
    
    var leftBarButtonType: ButtonType = .buttonTypeNil
    var rightBarButtonType: ButtonType = .buttonTypeNil
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    func setupWithSuperView(_ superView: UIView, title: String, leftButtonType: ButtonType, rightButtonType: ButtonType, target: AnyObject, leftAction: Selector, rightAction: Selector) {
        superView.addSubview(self)
        
        self.leftBarButtonType = leftButtonType
        self.rightBarButtonType = rightButtonType
        
        //self.btnDropDown.contentVerticalAlignment = .bottom
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: 0.0))
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.trailing, multiplier: 1.0, constant: 0.0))
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 0.0))
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: superView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0))
        
        self.btnLeft.alpha = 0
        self.btnRight.alpha = 0
        self.btnRightEdit.alpha = 0
        //self.const_progressHeight.constant = 0
        //self.const_statusBarHeight.constant = (isDevice() == DEVICES.iPhoneX || isDevice() == DEVICES.iPhoneXR) ?44.0:20
        
        self.backgroundColor = UIColor.white
        self.lblTitle.text = title
        
        if leftButtonType != ButtonType.buttonTypeNil {
            var leftImageName: String = ""
            if leftButtonType == .buttonTypeBack {
                leftImageName = "back"
            } else if leftButtonType == .buttonTypeMenu {
                leftImageName = "menu"
            } else if leftButtonType == .buttonTypeSave {
                leftImageName = "tik"
            }
            if leftImageName.count > 0 {
                self.btnLeft.alpha = 1.0
                self.btnLeft.setImage(UIImage(named: leftImageName), for: .normal)
                self.btnLeft.addTarget(target, action: leftAction, for: UIControl.Event.touchUpInside)
            }
        }
        
        if rightButtonType != ButtonType.buttonTypeNil {
            var rightImageName: String = ""
            if rightButtonType == .buttonTypeBack {
                rightImageName = "back"
            } else if rightButtonType == .buttonTypeMenu {
                rightImageName = "list"
            } else if rightButtonType == .buttonTypeAdd {
                self.btnRightEdit.alpha = 1.0
                self.btnRightEdit.setImage(UIImage(named: "add"), for: .normal)
                self.btnRightEdit.addTarget(target, action: rightAction, for: UIControl.Event.touchUpInside)
            } else if rightButtonType == .buttonTypeCredit {
                self.btnRight.alpha = 1.0
                self.btnRight.layer.cornerRadius = getCalculated(9.0)
                self.btnRight.backgroundColor = .white
                self.btnRight.setTitle("$ 50", for: .normal)
            } else if rightButtonType == .buttonTypeEdit {
                self.btnRightEdit.alpha = 1.0
                self.btnRightEdit.setImage(UIImage(named: "pencil"), for: .normal)
                self.btnRightEdit.addTarget(target, action: rightAction, for: UIControl.Event.touchUpInside)
            } else if rightButtonType == .buttonTypeSkip {
                self.btnRightEdit.alpha = 1.0
                self.btnRightEdit.setTitle("Skip", for: .normal)
                self.btnRightEdit.addTarget(target, action: rightAction, for: UIControl.Event.touchUpInside)
            }
            if rightImageName.count > 0 {
                self.btnRight.alpha = 1.0
                self.btnRight.setImage(UIImage(named: rightImageName), for: .normal)
            }
            
            self.btnRight.addTarget(target, action: rightAction, for: UIControl.Event.touchUpInside)
            self.layoutIfNeeded()
        }
        
        //        if AppConstant.shared.totalImageCount > 0 {
        //            self.addProgress()
        //        }
        
    }
}
