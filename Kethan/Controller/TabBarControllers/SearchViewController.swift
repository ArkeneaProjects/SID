//
//  ViewController.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

class SearchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Deals", withLeftButtonType: .buttonTypeMenu, withRightButtonType: .buttonTypeSearch)
        // Do any additional setup after loading the view.
    }
}

