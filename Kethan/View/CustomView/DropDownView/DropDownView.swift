//
//  DropDownView.swift
//  Kethan
//
//  Created by Apple on 23/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class DropDownView: UIView, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblView: UITableView!
       
       var viewController: BaseViewController?

       var arrAllItems: NSMutableArray = NSMutableArray() {
           didSet {
               self.tblView.reloadData()
           }
       }
    
    func setupWith(superView: UIView, controller: BaseViewController) {
        
        viewController = controller
        
        superView.addSubview(self)
        
        //SetUp SubView
        self.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0))
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1.0, constant: 0))
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: superView, attribute: .width, multiplier: 1.0, constant: 0))
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: superView, attribute: .height, multiplier: 1.0, constant: 0))
        superView.layoutIfNeeded()
        
        //TableView
        self.tblView.registerNibWithIdentifier([IDENTIFIERS.CreditTableViewCell])
        
    }
    
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCalculated(40.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrAllItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.CreditTableViewCell, for: indexPath) as? CreditTableViewCell {
            cell.backgroundColor = UIColor.init(hexCode: 0xF9F8F9)
            cell.lblCredits.text = self.arrAllItems[indexPath.row] as! String
            cell.lblCredits.textColor = UIColor.init(hexCode: 0x333333)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
