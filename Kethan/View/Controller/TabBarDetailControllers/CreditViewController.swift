//
//  CreditViewController.swift
//  Kethan
//
//  Created by Apple on 31/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class CreditViewController: BaseViewController {

    @IBOutlet weak var tblView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Credits", withLeftButtonType: .buttonTypeNil, withRightButtonType: .buttonTypeNil)

        //TableView
               self.tblView.registerNibWithIdentifier([IDENTIFIERS.CreditHistoryTableViewCell])
               self.tblView.rowHeight = UITableView.automaticDimension
               self.tblView.estimatedRowHeight = getCalculated(80.0)
               self.tblView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
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
