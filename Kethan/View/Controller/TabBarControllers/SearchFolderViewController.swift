//
//  SearchFolderViewController.swift
//  Kethan
//
//  Created by Apple on 06/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SearchFolderViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Search Folders", withLeftButtonType: .buttonTypeNil, withRightButtonType: .buttonTypeNil)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
     @IBAction func btnhClickAction(_ sender: Any) {
        if let controller = self.instantiate(SearchViewController.self, storyboard: STORYBOARD.main) as? SearchViewController {
            self.navigationController?.pushViewController(controller, animated: true)
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
