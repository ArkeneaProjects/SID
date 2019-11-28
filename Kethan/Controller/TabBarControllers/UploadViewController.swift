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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Add Image", withLeftButtonType: .buttonTypeNil, withRightButtonType: .buttonTypeNil)
        
        self.txtImplant.font = UIFont(name: self.txtImplant.font!.fontName, size: getCalculated(13.5))
        self.txtManu.font = UIFont(name: self.txtManu.font!.fontName, size: getCalculated(13.5))
        
        self.txtImplant.optionArray = STATICDATA.implantDropDown
        self.txtImplant.didSelect { (selected: String, index: Int, id: Int) in
            self.txtImplant.text = selected
        }
        self.txtImplant.keyboardCompletion = {
            if self.txtImplant.shadow != nil && self.txtImplant.shadow.alpha != 0 {
                self.txtImplant.hideList()
            }
        }
        
        self.txtManu.optionArray = STATICDATA.manufacturerDropDown
        self.txtManu.didSelect { (selected: String, index: Int, id: Int) in
            self.txtManu.text = selected
        }
        self.txtManu.keyboardCompletion = {
            if self.txtManu.shadow != nil && self.txtManu.shadow.alpha != 0 {
                self.txtManu.hideList()
            }
        }
    }
    
    // MARK: - Button Action
    @IBAction func addClickAction(_ sender: Any) {
        if let controller = self.instantiate(AddDetailsViewController.self, storyboard: STORYBOARD.main) as? AddDetailsViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
   /* func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text!.count >= 3 {
           // self.txtImplant.showList()
        }
        return true
    }*/
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
