//
//  ResponsePopUpViewController.swift
//  Kethan
//
//  Created by Apple on 27/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class ResponsePopUpViewController: BaseViewController {
    
    @IBOutlet weak var viewBlur: UIView!
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var txtView: CustomTextView!
    
    var addCompletion:((_ str: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNormalEditEnabled = true
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func cancelClickAction(_ sender: Any) {
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.addCompletion!("")
            }
        }
    }
    
    @IBAction func addClickAction(_ sender: Any) {
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.view.endEditing(true)
                self.addCompletion!(self.txtView.text!)
            }
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
        
        self.showPopupWithView(viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil)
    }
    
    func dismissWithCompletion(completion: @escaping VoidCompletion) {
        self.dismissPopupWithView(remove: false, viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil) {
            completion()
        }
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
