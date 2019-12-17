//
//  SearchDetailViewController.swift
//  Kethan
//
//  Created by Apple on 25/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SearchDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Details", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeEdit)
        self.navBar.btnRightEdit.contentHorizontalAlignment = .right

        self.tblView.registerNibWithIdentifier([IDENTIFIERS.DetailRow1TableViewCell, IDENTIFIERS.DetailRow2TableViewCell])
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = getCalculated(20.0)
        self.tblView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    override func rightButtonAction() {
        if let controller = self.instantiate(AddDetailsViewController.self, storyboard: STORYBOARD.main) as? AddDetailsViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.DetailRow1TableViewCell) as? DetailRow1TableViewCell {
                var customCollection: SearchViewCollecction?
                customCollection = SearchViewCollecction.loadInstanceFromNib() as? SearchViewCollecction
                customCollection!.setupWith(superView: cell.viewCollection, controller: self, isview: false)
                customCollection!.pageControl.numberOfPages = STATICDATA.arrImages.count
                customCollection!.arrAllItems =  NSMutableArray(array: STATICDATA.arrSearch)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.DetailRow2TableViewCell) as? DetailRow2TableViewCell {
                cell.lblResponse.text = STATICDATA.arrResponse[indexPath.row-1]
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
