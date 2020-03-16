//
//  ReportViewController.swift
//  Kethan
//
//  Created by Ashwini on 13/03/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class ReportViewController: BaseViewController {
    
    @IBOutlet weak var viewBlur: UIView!
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var txtView: CustomTextView!
    @IBOutlet weak var txtImplant: CustomTextField!
    var addCompletion:((_ str: String, _ location: String) -> Void)?
    
    @IBOutlet weak var btnClose: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNormalEditEnabled = false
        self.btnClose.alpha = 0
        self.txtImplant.font = UIFont(name: self.txtImplant.font!.fontName, size: getCalculated(14.0))
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func cancelClickAction(_ sender: Any) {
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.addCompletion!("", "")
            }
        }
    }
    
    @IBAction func addClickAction(_ sender: Any) {
        if !self.txtView.text.isEmpty {
            self.dismissWithCompletion {
                if self.addCompletion != nil {
                    self.view.endEditing(true)
                    self.addCompletion!(self.txtView.text!, self.txtImplant.text!)
                }
            }
        } else {
             ProgressManager.showError(withStatus: "Please add a reason for reporting", on: self.view)
        }
    }
    
    // MARK: - Custom Functions -
    func preparePopup(controller: BaseViewController) {
        if let parent = self.findParentBaseViewController() {
            controller.addViewController(controller: self, view: parent.view, parent: parent)
        } else {
            controller.addViewController(controller: self, view: controller.view, parent: controller)
        }
        self.preparePopupWithView(viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil)
    }
    
    func showPopup() {
        
        self.showPopupWithView(viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: self.btnClose)
        self.btnClose.alpha = 1.0
    }
    
    func dismissWithCompletion(completion: @escaping VoidCompletion) {
        self.dismissPopupWithView(remove: false, viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil) {
            completion()
        }
    }
    
    func getValueFromUserDefault(key: String) -> [NSString] {
        if let arr = getUserDefaultsForKey(key: key) as? [NSString] {
            return arr
        }
        return []
    }
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let controller: ManufacturesPopUpViewController = self.instantiate(ManufacturesPopUpViewController.self, storyboard: STORYBOARD.main) as? ManufacturesPopUpViewController {
            controller.preparePopup(controller: self)
            controller.showPopup(array: getValueFromUserDefault(key: UserDefaultsKeys.BrandName) as [String], textName: self.txtImplant.text!, isManufacture: false)
            controller.addCompletion = { selectedText in
                self.txtImplant.text = selectedText
            }
        }
        return false
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
