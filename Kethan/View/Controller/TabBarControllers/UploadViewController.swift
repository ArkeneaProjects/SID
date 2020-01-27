//
//  FavoritesViewController.swift
//  YupEasy
//
//  Created by Pankaj on 12/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

class UploadViewController: BaseViewController {
    
    @IBOutlet weak var txtImplant: CustomTextField!
    @IBOutlet weak var txtManu: CustomTextField!
    
    @IBOutlet weak var btnAdd: CustomButton!
    
    var implantObj = SearchResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Add Image", withLeftButtonType: .buttonTypeNil, withRightButtonType: .buttonTypeNil)
        
        self.txtImplant.font = UIFont(name: self.txtImplant.font!.fontName, size: getCalculated(14.0))
        self.txtManu.font = UIFont(name: self.txtManu.font!.fontName, size: getCalculated(14.0))
        
        self.txtManu.text = ""
        self.txtImplant.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           if AppConstant.shared.manufactureName.count != 0 {
               self.txtManu.text = AppConstant.shared.manufactureName
               AppConstant.shared.manufactureName = ""
           }
           
           if AppConstant.shared.brandName.count != 0 {
               self.txtImplant.text = AppConstant.shared.brandName
               AppConstant.shared.brandName = ""
           }
       }
    
    func getManufatureName() -> [String] {
        //Manufacture
        if let arrManufacture = getUserDefaultsForKey(key: UserDefaultsKeys.ManufectureUpload) as? [NSDictionary] {
            let arr = arrManufacture.map { (obj) -> String in
                return getValueFromDictionary(dictionary: obj, forKey: ENTITIES.implantManufacture)
            }
            return arr
        }
        return []
    }
    
    func getBrandName() -> [String] {
        //Brand
        if let arrManufacture = getUserDefaultsForKey(key: UserDefaultsKeys.ManufectureUpload) as? [NSDictionary] {
            
            let arritem = NSMutableArray(array: arrManufacture)
            let arr = arritem.filtered(using: NSPredicate(format: "\(ENTITIES.implantManufacture) == %@", argumentArray: [self.txtManu.text!]))
            if arr.count > 0 {
                if let manuDict = arr.last as? NSDictionary {
                    return manuDict.object(forKey: ENTITIES.brand) as? [String] ?? []
                }
            }
        }
        return []
    }
    
    // MARK: - Button Action
    @IBAction func addClickAction(_ sender: Any) {
        self.implantObj.objectName = self.txtImplant.text!
        self.implantObj.implantManufacture = self.txtManu.text!
        
        //Check Duplicate Manufacture
        let searchVM = SearchVM()
        searchVM.checkDuplicateManufacture(manufactureName: self.txtManu.text!, brandName: self.txtImplant.text!, rootController: self)
    }
       
    // MARK: - TextField Deleget
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.txtManu {
            if let controller: ManufacturesPopUpViewController = self.instantiate(ManufacturesPopUpViewController.self, storyboard: STORYBOARD.main) as? ManufacturesPopUpViewController {
                controller.preparePopup(controller: self)
                controller.showPopup(array: self.getManufatureName(), textName: self.txtManu.text!, isManufacture: true)
                controller.addCompletion = { selectedText in
                    self.txtManu.text = selectedText
                }
            }
        } else {
           return true
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
