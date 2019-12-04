//
//  SettingsViewController.swift
//  YupEasy
//
//  Created by Pankaj on 12/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

class PurchesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var btnCredit: CustomButton!
    @IBOutlet weak var btnReferral: CustomButton!
    
    @IBOutlet weak var imgUpArrow: UIImageView!
    
    @IBOutlet weak var viewCredits: UIView!
    
    @IBOutlet weak var constViewTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Credits", withLeftButtonType: .buttonTypeNil, withRightButtonType: .buttonTypeNil)
        
        let referralNumber = "(hd09w7r)"
        let attributedString = NSMutableAttributedString(string: "Referral Code \(referralNumber) ", attributes: [
          .font: UIFont(name: "HelveticaNeue-Medium", size: getCalculated(16.75))!,
          .foregroundColor: UIColor(red: 9.0 / 255.0, green: 133.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
        ])
        attributedString.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Medium", size: getCalculated(13.5))!, range: NSRange(location: 14, length: referralNumber.count))
        self.btnReferral.setAttributedTitle(attributedString, for: .normal)
        
        //Credit
        let creditPoints = "(0)"
        let credit_attributedString = NSMutableAttributedString(string: "Credit History \(creditPoints)", attributes: [
          .font: UIFont(name: "HelveticaNeue-Bold", size: getCalculated(13.5))!,
          .foregroundColor: UIColor(red: 9.0 / 255.0, green: 133.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
        ])
        credit_attributedString.addAttribute(.font, value: UIFont(name: "HelveticaNeue", size: getCalculated(13.5))!, range: NSRange(location: 15, length: creditPoints.count))
        self.btnCredit.setAttributedTitle(credit_attributedString, for: .normal)
        
        //TableView
        self.tblView.registerNibWithIdentifier([IDENTIFIERS.CreditHistoryTableViewCell])
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = getCalculated(80.0)
        self.tblView.tableFooterView = UIView()
        
    }
    
    @IBAction func referralClickAction(_ sender: Any) {
    }
    
    @IBAction func uploadImageClickAction(_ sender: Any) {
    }
    
    @IBAction func creditActionClick(_ sender: Any) {
        if self.constViewTableHeight.constant == 0 {
            UIView.animate(withDuration: 0.3) {
                self.viewCredits.alpha = 0
                self.constViewTableHeight.constant = (self.viewCredits.frame.size.height - getCalculated(43.0))
                self.imgUpArrow.image = UIImage(named: "droparrow")
                self.btnCredit.setTitle("Credit History ($190)", for: .normal)
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.viewCredits.alpha = 1.0
                self.constViewTableHeight.constant = getCalculated(0.0)
                self.imgUpArrow.image = UIImage(named: "upArrow")
                self.btnCredit.setTitle("Credit History (0)", for: .normal)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return STATICDATA.arrCreditHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.CreditHistoryTableViewCell, for: indexPath) as? CreditHistoryTableViewCell {
            let arr = STATICDATA.arrCreditHistory[indexPath.row]
            cell.imgReferral.image = UIImage(named: arr["image"] ?? "")
            cell.lblTitle.text = arr["title"]
            cell.lblDate.text = arr["date"]
            cell.lblAmount.text = arr["amount"]
            cell.lblDiscription.text = arr["description"]
            cell.lblAmount.textColor = (arr["amount"] == "- $ 120") ?APP_COLOR.color7:APP_COLOR.color6
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
