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
    
    var addCompletion:((_ creditValue: String, _ creditPoints: String) -> Void)?
    
    @IBOutlet weak var btnClose: CustomButton!
    
    var creditsUsed = ""
    var creditValue = ""
    
    var creditDivisionArr = NSMutableArray()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(UITableViewCell.self, forCellReuseIdentifier: "creditCell")
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = getCalculated(20.0)
        self.tblView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        self.getValueForEarned()
    }
    
    func getValueForEarned() {
        let current = "272" //AppConstant.shared.loggedUser.creditPoint //272 points
        self.lblTotalCredits.text = "Total Credits: \(current)"
        let valueForCurrent = current.intValue()/4 // 68 $
        
        let baseUsableValue = valueForCurrent - valueForCurrent % 5 // 65
        for i in 0..<baseUsableValue/5 {
            self.creditDivisionArr.add(["value": (i+1)*5, "points": (i+1)*5*4])
        }
    }
    
    /*
     4 points = 1 $
     20 points = 5$
     */
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
            ProgressManager.showError(withStatus: ERRORS.professionSelect, on: self.view)
            return
        }
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.addCompletion!(self.creditValue, self.creditsUsed)
            }
        }
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.creditDivisionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CreditTableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: CreditTableViewCell.self), for: indexPath) as? CreditTableViewCell {
            let creditsDict: NSDictionary = self.creditDivisionArr[indexPath.row] as! NSDictionary
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
        let creditsDict: NSDictionary = self.creditDivisionArr[indexPath.row] as! NSDictionary
        self.creditsUsed = getValueFromDictionary(dictionary: creditsDict, forKey: "points")
        self.creditValue = getValueFromDictionary(dictionary: creditsDict, forKey: "value")
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
