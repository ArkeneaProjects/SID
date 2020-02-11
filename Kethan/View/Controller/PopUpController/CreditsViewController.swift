//
//  CreditsViewController.swift
//  Kethan
//
//  Created by Ashwini on 15/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class CreditsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var viewBlur: UIView!
    @IBOutlet weak var viewPopup: UIView!
    @IBOutlet weak var lblTotalCredits: CustomLabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnDontUse: CustomButton!
    @IBOutlet weak var btnClose: CustomButton!
    @IBOutlet weak var btnSubscribe: CustomButton!
    
    var creditsUsed = ""
    var creditValue = ""
    var creditDivisionArr = [NSDictionary]()
    var selectedIndex: Int?
    
    var addCompletion:((_ creditValue: String, _ creditPoints: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.registerNibWithIdentifier([IDENTIFIERS.CreditTableViewCell])
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = getCalculated(20.0)
        self.tblView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        self.getValueForEarned()
    }
    
    func getValueForEarned() {
        let creditVM = CreditVM()
        creditVM.callAPI(self) { (success) in
            if success  == true {
                var current = creditVM.totalCreditEarn
                current = current > 200 ? 200 : current //to match credits woth max subscription amount.
                self.lblTotalCredits.text = "Total Credits: \(current)"
                let valueForCurrent = current/4 // 68 $
                
                let baseUsableValue = valueForCurrent - valueForCurrent % 5 // 65
                for i in 0..<baseUsableValue/5 {
                    self.creditDivisionArr.append(["value": (i+1)*5, "points": (i+1)*5*4])
                }
                
                self.btnSubscribe.setTitle(self.creditDivisionArr.count == 0 ? "Subscribe with $50" : "Subscribe", for: .normal)
                self.btnDontUse.isHidden = self.creditDivisionArr.count == 0
                self.creditsUsed = self.creditDivisionArr.count == 0 ? "0" : ""
                self.creditValue = self.creditDivisionArr.count == 0 ? "0" : ""
                self.tblView.reloadData()
            }
        }
    }
    
    // MARK: - Button Action
    @IBAction func cancelClickAction(_ sender: Any) {
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.addCompletion!("", "")
            }
        }
    }
    
    @IBAction func addClickAction(_ sender: Any) {
        if self.creditValue.count == 0 {
            ProgressManager.showError(withStatus: ERRORS.amountSelect, on: self.view)
            return
        }
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.addCompletion!(self.creditValue, self.creditsUsed)
            }
        }
    }
    
    @IBAction func doNotUseAction(_ sender: Any) {
        self.btnDontUse.isSelected = !self.btnDontUse.isSelected
        self.creditsUsed = self.btnDontUse.isSelected ? "0" : ""
        self.creditValue = self.btnDontUse.isSelected ? "0" : ""
        self.btnSubscribe.setTitle(self.btnDontUse.isSelected ? "Subscribe with $50" : "Subscribe", for: .normal)
        self.tblView.reloadData()
        self.selectedIndex = nil
    }
    
    // MARK: - Custom Functions -
    func preparePopup(controller: BaseViewController) {
        if let parent = self.findParentBaseViewController() {
            controller.addViewController(controller: self, view: parent.view, parent: parent)
        } else {
            controller.addViewController(controller: self, view: controller.view, parent: controller)
        }
        self.preparePopupWithView(viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil)
    }
    
    func showPopup() {
        self.showPopupWithView(viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil)
        self.btnClose.alpha = 1.0
    }
    
    func dismissWithCompletion(completion: @escaping VoidCompletion) {
        self.dismissPopupWithView(remove: false, viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil) {
            completion()
        }
    }
    
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCalculated(30.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.creditDivisionArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.creditDivisionArr.count > 0 ? 0.0 : 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
        headerView.backgroundColor = UIColor.white
        let headerLbl: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
        headerLbl.text = "You do not have enough credits"
        headerView.addSubview(headerLbl)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CreditTableViewCell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.CreditTableViewCell, for: indexPath) as? CreditTableViewCell {
            let creditsDict = self.creditDivisionArr[indexPath.row]
            
            let value = "\(getValueFromDictionary(dictionary: creditsDict, forKey: "points")) Credits = $\(getValueFromDictionary(dictionary: creditsDict, forKey: "value"))"
            cell.lblCredits.text = value
            
            cell.lblCredits.textColor = indexPath.row == self.selectedIndex ? UIColor.init(hexCode: 0x0985E9) : UIColor.init(hexCode: 0x333333)
            cell.accessoryType = .none
            cell.imgSelect.alpha = indexPath.row == self.selectedIndex ? 1.0: 0
            cell.selectionStyle = .none
            
            cell.layoutIfNeeded()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.tblView.reloadData()
        self.selectedIndex = indexPath.row
        let creditsDict = self.creditDivisionArr[indexPath.row]
        self.creditsUsed = getValueFromDictionary(dictionary: creditsDict, forKey: "points")
        self.creditValue = getValueFromDictionary(dictionary: creditsDict, forKey: "value")
        if self.creditValue.intValue() == 50 {
            self.btnSubscribe.setTitle("Subscribe", for: .normal)
        } else {
            self.btnSubscribe.setTitle("Subscribe with $\(50 - self.creditValue.intValue())", for: .normal)
        }
        self.btnDontUse.isSelected = false
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
