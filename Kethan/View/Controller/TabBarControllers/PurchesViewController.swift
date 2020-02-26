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
    
    @IBOutlet weak var lblCredit: CustomLabel!
    
    @IBOutlet weak var imgUpArrow: UIImageView!
    
    @IBOutlet weak var viewCredits: UIView!
    
    @IBOutlet weak var constViewTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tblView: UITableView!
    
    var isCameFromNotification: Bool = false
    var isShowBackBtn: Bool = false

    var creditVM = CreditVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Credits", withLeftButtonType: (self.isCameFromNotification == false && self.isShowBackBtn == false) ?.buttonTypeNil:.buttonTypeBack, withRightButtonType: .buttonTypeNil)
        
        //TableView
        self.tblView.registerNibWithIdentifier([IDENTIFIERS.CreditHistoryTableViewCell])
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = getCalculated(80.0)
        self.tblView.tableFooterView = UIView()
        
        //Check the condition, is coming form notification or tab
        if self.isCameFromNotification == false { 
            let referralNumber = AppConstant.shared.loggedUser.referralCode
            let attributedString = NSMutableAttributedString(string: "Referral Code \(referralNumber) ", attributes: [
                .font: UIFont(name: "HelveticaNeue-Medium", size: getCalculated(16.75))!,
                .foregroundColor: UIColor(red: 9.0 / 255.0, green: 133.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
            ])
            attributedString.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Medium", size: getCalculated(13.5))!, range: NSRange(location: 14, length: referralNumber.count))
            self.btnReferral.setAttributedTitle(attributedString, for: .normal)
            self.btnCredit.isUserInteractionEnabled = (self.creditVM.totalCreditEarn == 0) ?true:false
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.viewCredits.alpha = 0
                self.constViewTableHeight.constant = (self.viewCredits.frame.size.height - getCalculated(43.0))
                self.imgUpArrow.image = UIImage(named: "droparrow")
                self.btnCredit.isUserInteractionEnabled = false
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.creditVM.callAPI(self) { (success) in
            if success  == true {
                self.creditPoints("(\(self.creditVM.totalCreditEarn))")
                self.lblCredit.text = (self.creditVM.totalCreditEarn == 0) ?"\(self.creditVM.totalCreditEarn) Credit":"\(self.creditVM.totalCreditEarn) Credits"
                self.tblView.reloadData()
            }
        }
    }
    
    // MARK: - Button Action
    @IBAction func referralClickAction(_ sender: Any) {
        
        // text to share
        let text = "Hey, your friend \(AppConstant.shared.loggedUser.name) has recommended you to sign-up on Spinal Implant Database application by using code \(AppConstant.shared.loggedUser.referralCode). To download app: https://www.google.com"
        // let text = "Hey there, please sign-up using the code \(AppConstant.shared.loggedUser.referralCode) to receive credits that can be redeemed against annual subscription. Download app: \("https://www.google.com")"
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func uploadImageClickAction(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    
    @IBAction func creditActionClick(_ sender: Any) {
        if self.constViewTableHeight.constant == 0 {
            UIView.animate(withDuration: 0.3) {
                self.viewCredits.alpha = 0
                self.constViewTableHeight.constant = (self.viewCredits.frame.size.height - getCalculated(43.0))
                self.imgUpArrow.image = UIImage(named: "droparrow")
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.viewCredits.alpha = 1.0
                self.constViewTableHeight.constant = getCalculated(0.0)
                self.imgUpArrow.image = UIImage(named: "upArrow")
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func creditPoints(_ points: String) {
        //Credit
        let credit_attributedString = NSMutableAttributedString(string: "Credit History \(points)", attributes: [
            .font: UIFont(name: "HelveticaNeue-Bold", size: getCalculated(13.5))!,
            .foregroundColor: UIColor(red: 9.0 / 255.0, green: 133.0 / 255.0, blue: 233.0 / 255.0, alpha: 1.0)
        ])
        credit_attributedString.addAttribute(.font, value: UIFont(name: "HelveticaNeue", size: getCalculated(13.5))!, range: NSRange(location: 15, length: points.count))
        self.btnCredit.setAttributedTitle(credit_attributedString, for: .normal)
    }
    
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.creditVM.arrCredit.count
        //return STATICDATA.arrCreditHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.CreditHistoryTableViewCell, for: indexPath) as? CreditHistoryTableViewCell {
            let obj = self.creditVM.arrCredit[indexPath.row] as? Credit ?? Credit()
            cell.imgReferral.image = UIImage(named: obj.image)
            cell.lblTitle.text = obj.title
            cell.lblDate.text = obj.isApprovedDate
            cell.lblAmount.text = "+ \(obj.creditPoints)"
            cell.lblDiscription.text = obj.msg
            cell.lblAmount.textColor = APP_COLOR.color6
            
            return cell
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
