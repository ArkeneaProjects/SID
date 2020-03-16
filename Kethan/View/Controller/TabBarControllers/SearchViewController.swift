//
//  ViewController.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {
    
    @IBOutlet weak var txtImplant: CustomTextField!
    @IBOutlet weak var txtManufacture: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Search by text", withLeftButtonType: .buttonTypeNil, withRightButtonType: .buttonTypeNil)
        
        self.txtImplant.font = UIFont(name: self.txtImplant.font!.fontName, size: getCalculated(14.0))
        self.txtManufacture.font = UIFont(name: self.txtManufacture.font!.fontName, size: getCalculated(14.0))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let loginVM = LoginViewModel()
        loginVM.callManutactureAPI()
    }
    
    // MARK: - Button Action
    @IBAction func searchClickAction(_ sender: Any) {
        self.txtImplant.text = self.txtImplant.text?.trimmedString()
        self.txtManufacture.text = self.txtManufacture.text?.trimmedString()
        if self.txtImplant.text?.count == 0 && self.txtManufacture.text?.count == 0 {
            ProgressManager.showError(withStatus: MESSAGES.emptySearch, on: self.view)
        } else {
            
            let subscription = SubscriptionVM()
            subscription.checkSubscription(apiCallFrom: 0, manufecture: self.txtManufacture.text ?? "", brandname: self.txtImplant.text ?? "", image: nil, rootController: self)
        }
    }
    
    func getValueFromUserDefault(key: String) -> [NSString] {
        if let arr = getUserDefaultsForKey(key: key) as? [NSString] {
            return arr
        }
        return []
    }
    
    // MARK: - TextField Deleget
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtManufacture {
            if let controller: ManufacturesPopUpViewController = self.instantiate(ManufacturesPopUpViewController.self, storyboard: STORYBOARD.main) as? ManufacturesPopUpViewController {
                controller.preparePopup(controller: self)
                controller.showPopup(array: getValueFromUserDefault(key: UserDefaultsKeys.Manufecture) as [String], textName: self.txtManufacture.text!, isManufacture: true)
                controller.addCompletion = { selectedText in
                    self.txtManufacture.text = selectedText
                }
            }
        } else {
            if let controller: ManufacturesPopUpViewController = self.instantiate(ManufacturesPopUpViewController.self, storyboard: STORYBOARD.main) as? ManufacturesPopUpViewController {
                controller.preparePopup(controller: self)
                controller.showPopup(array: getValueFromUserDefault(key: UserDefaultsKeys.BrandName) as [String], textName: self.txtImplant.text!, isManufacture: false)
                controller.addCompletion = { selectedText in
                    self.txtImplant.text = selectedText
                }
            }
        }
        return false
    }
    
}
