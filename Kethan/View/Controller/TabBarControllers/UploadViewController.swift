//
//  FavoritesViewController.swift
//  YupEasy
//
//  Created by Pankaj on 12/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

class UploadViewController: BaseViewController {
    
    @IBOutlet weak var txtImplant: CustomDropDown!
    @IBOutlet weak var txtManu: CustomDropDown!
    var implantObj = SearchResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Add Image", withLeftButtonType: .buttonTypeNil, withRightButtonType: .buttonTypeNil)
        
        self.txtImplant.font = UIFont(name: self.txtImplant.font!.fontName, size: getCalculated(14.0))
        self.txtManu.font = UIFont(name: self.txtManu.font!.fontName, size: getCalculated(14.0))
        self.txtManu.text = ""
        self.txtImplant.text = ""
        if AppConstant.shared.manufactureName.count != 0 {
            self.txtManu.text = AppConstant.shared.manufactureName
            AppConstant.shared.manufactureName = ""
        }
        
        if AppConstant.shared.brandName.count != 0 {
            self.txtImplant.text = AppConstant.shared.brandName
            AppConstant.shared.brandName = ""
        }
        
        //Brand
        if let arrBrand = getUserDefaultsForKey(key: UserDefaultsKeys.BrandName) as? [NSString] {
            self.txtImplant.optionArray = arrBrand as [String]
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
        if let arrManufacture = getUserDefaultsForKey(key: UserDefaultsKeys.Manufecture) as? [NSString] {
            self.txtManu.optionArray = arrManufacture as [String]
            self.txtManu.didSelect { (selected: String, index: Int, id: Int) in
                self.txtManu.text = selected
            }
            self.txtManu.keyboardCompletion = {
                if self.txtManu.shadow != nil && self.txtManu.shadow.alpha != 0 {
                    self.txtManu.hideList()
                }
            }
        }
    }
    
    // MARK: - Button Action
    @IBAction func addClickAction(_ sender: Any) {
        self.implantObj.objectName = self.txtImplant.text!
        self.implantObj.implantManufacture = self.txtManu.text!

        if self.implantObj.objectName.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.EmptyBrandName, on: self.view)
            return
        } else if self.implantObj.implantManufacture.trimmedString().count == 0 {
            ProgressManager.showError(withStatus: ERRORS.EmptyManufacturer, on: self.view)
            return
        } else {
//            if let controller = self.instantiate(AddDetailsViewController.self, storyboard: STORYBOARD.main) as? AddDetailsViewController {
//                controller.implantObj = self.implantObj
//                self.navigationController?.pushViewController(controller, animated: true)
//            }
            if let controller = self.instantiate(SearchListViewController.self, storyboard: STORYBOARD.main) as? SearchListViewController {
                controller.menufeacture = self.txtManu.text ?? ""
                controller.brandname = self.txtImplant.text ?? ""
                controller.isCalledFrom = 2
                self.navigationController?.pushViewController(controller, animated: true)
            }
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
