//
//  FavoritesViewController.swift
//  YupEasy
//
//  Created by Pankaj on 12/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit
import iOSDropDown

class UploadViewController: BaseViewController {

    @IBOutlet weak var txtImplant: DropDown!
    @IBOutlet weak var txtManufacturer: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Add Image", withLeftButtonType: .buttonTypeNil, withRightButtonType: .buttonTypeNil)
        
        self.txtImplant.optionArray = STATICDATA.implantDropDown
        self.txtImplant.didSelect { (selected: String, index: Int, id: Int) in
            self.txtImplant.text = selected
        }
        
        self.txtManufacturer.optionArray = STATICDATA.manufacturerDropDown
        self.txtManufacturer.didSelect { (selected: String, index: Int, id: Int) in
            self.txtManufacturer.text = selected
        }
        // Do any additional setup after loading the view.
    }
    
 // MARK: - TextField Delegate
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if self.txtImplant.shadow != nil && self.txtImplant.shadow.alpha != 0 {
            self.txtImplant.hideList()
        }
        if self.txtManufacturer.shadow != nil && self.txtManufacturer.shadow.alpha != 0 {
            self.txtManufacturer.hideList()
        }
        return true
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
