//
//  ViewController.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit
import iOSDropDown

class SearchViewController: BaseViewController {

    @IBOutlet weak var txtImplant: DropDown!
    @IBOutlet weak var txtManufacturer: DropDown!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Search by text", withLeftButtonType: .buttonTypeNil, withRightButtonType: .buttonTypeNil)
        // Do any additional setup after loading the view.
        self.txtImplant.font = UIFont(name: self.txtImplant.font!.fontName, size: getCalculated(14.0))
        self.txtManufacturer.font = UIFont(name: self.txtImplant.font!.fontName, size: getCalculated(14.0))
        
        self.txtImplant.optionArray = STATICDATA.implantDropDown
        self.txtImplant.didSelect { (selected: String, index: Int, id: Int) in
            self.txtImplant.text = selected
        }
        
        self.txtManufacturer.optionArray = STATICDATA.manufacturerDropDown
        self.txtManufacturer.didSelect { (selected: String, index: Int, id: Int) in
            self.txtManufacturer.text = selected
        }
    }
    
    // MARK: - Button Action
    @IBAction func searchClickAction(_ sender: Any) {
        if let controller = self.instantiate(SearchListViewController.self, storyboard: STORYBOARD.main) as? SearchListViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
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
}
