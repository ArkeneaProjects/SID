//
//  ViewController.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    @IBOutlet weak var txtImplant: CustomDropDown!
    
    @IBOutlet weak var txtManufacture: CustomDropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Search by text", withLeftButtonType: .buttonTypeNil, withRightButtonType: .buttonTypeNil)
       
        self.txtImplant.font = UIFont(name: self.txtImplant.font!.fontName, size: getCalculated(14.0))
        self.txtManufacture.font = UIFont(name: self.txtManufacture.font!.fontName, size: getCalculated(14.0))
        
        //Brand
        if let arrBrand = getUserDefaultsForKey(key: UserDefaultsKeys.BrandName) as? NSMutableArray {
            self.txtImplant.optionArray = arrBrand as! [String]
                   self.txtImplant.didSelect { (selected: String, index: Int, id: Int) in
                       self.txtImplant.text = selected
                   }
                   self.txtImplant.keyboardCompletion = {
                       if self.txtImplant.shadow != nil && self.txtImplant.shadow.alpha != 0 {
                           self.txtImplant.hideList()
                       }
                   }
        }
        
        //Manufacture
        if let arrManufacture = getUserDefaultsForKey(key: UserDefaultsKeys.Manufecture) as? NSMutableArray {
            self.txtManufacture.optionArray = arrManufacture as! [String]
            self.txtManufacture.didSelect { (selected: String, index: Int, id: Int) in
                self.txtManufacture.text = selected
            }
            self.txtManufacture.keyboardCompletion = {
                if self.txtManufacture.shadow != nil && self.txtManufacture.shadow.alpha != 0 {
                    self.txtManufacture.hideList()
                }
            }
        }
    }
    
    // MARK: - Button Action
    @IBAction func searchClickAction(_ sender: Any) {
        self.txtImplant.text = self.txtImplant.text?.trimmedString()
        self.txtManufacture.text = self.txtManufacture.text?.trimmedString()
        if self.txtImplant.text?.count == 0 && self.txtManufacture.text?.count == 0 {
            ProgressManager.showError(withStatus: MESSAGES.emptySearch, on: self.view)
        } else {
        
        if let controller = self.instantiate(SearchListViewController.self, storyboard: STORYBOARD.main) as? SearchListViewController {
            controller.menufeacture = self.txtManufacture.text ?? ""
             controller.brandname = self.txtImplant.text ?? ""
            self.navigationController?.pushViewController(controller, animated: true)
        }
        }
    }
    
    // MARK: - TextField Delegate
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if self.txtImplant.shadow != nil && self.txtImplant.shadow.alpha != 0 {
            self.txtImplant.hideList()
        }
        if self.txtManufacture.shadow != nil && self.txtManufacture.shadow.alpha != 0 {
            self.txtManufacture.hideList()
        }
        return true
    }
}
