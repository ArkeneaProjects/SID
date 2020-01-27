//
//  ManufacturesPopUpViewController.swift
//  Kethan
//
//  Created by Apple on 23/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class ManufacturesPopUpViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var viewBlur: UIView!
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var txtField: CustomTextField!
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var btnClose: CustomButton!
    @IBOutlet weak var btnDone: CustomButton!
    
    @IBOutlet weak var lblHeaderName: CustomLabel!
    
    @IBOutlet weak var constTableHeight: NSLayoutConstraint!
    
    var selectedText = ""
    var imageName = ""
    
    var optionArray = [String]()
    var searchArray = [String]()
    
    var addCompletion:((_ selectedText: String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.registerNibWithIdentifier([IDENTIFIERS.CreditTableViewCell])
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = getCalculated(20.0)
        self.tblView.tableFooterView = UIView()
        self.constTableHeight.constant = getCalculated(351.0)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func cancelClickAction(_ sender: Any) {
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.addCompletion!(self.selectedText)
            }
        }
    }
    
    @IBAction func addClickAction(_ sender: Any) {
        
        self.dismiss(text: self.txtField.text!)
    }
    
    func dismiss(text: String) {
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.addCompletion!(text)
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
    
    func showPopup(array: [String], textName: String, isManufacture: Bool) {
        
        self.showPopupWithView(viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil)
        self.lblHeaderName.text = (isManufacture) ?"Manufacture List":"Brand List"
        self.txtField.placeholder = (isManufacture) ?"Search/Add new manufacture":"Search/Add new brand"
        self.selectedText = textName
        self.optionArray = array
        self.searchArray = array
        self.imageName = (isManufacture) ?"manufacturer":"implantIcon"
        self.tblView.reloadData()
    }
    
    func dismissWithCompletion(completion: @escaping VoidCompletion) {
        self.dismissPopupWithView(remove: false, viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil) {
            completion()
        }
    }
    
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return getCalculated(35.0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: CreditTableViewCell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.CreditTableViewCell, for: indexPath) as? CreditTableViewCell {
            cell.lblCredits.text = self.searchArray[indexPath.row]
            cell.imgSelect.alpha = (self.selectedText == cell.lblCredits.text!) ?1.0:0
            cell.imgLogo.image = UIImage(named: self.imageName)
            cell.layoutIfNeeded()
            return cell
        }
        return UITableViewCell()
    }
    
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -200, 0, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0.5

        UIView.animate(withDuration: 0.5) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.selectedText = self.searchArray[indexPath.row]
        self.tblView.reloadData()
        self.dismiss(text: self.selectedText)
    }
    
    // MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let finalText: String = NSString(string: textField.text!).replacingCharacters(in: range, with: string) as String
        if finalText.count == 0 {
            self.searchArray = self.optionArray
            self.tblView.reloadData()
        } else {
            self.filterContentForSearchText(searchText: finalText)
        }
        return true
    }
    
    func filterContentForSearchText(searchText: String) {
        self.searchArray = self.optionArray.filter { item in
            return item.lowercased().contains(searchText.lowercased())
        }
        UIView.animate(withDuration: 0.2) {
            self.constTableHeight.constant = (self.searchArray.count == 0) ?0:getCalculated(351.0)
            self.tblView.reloadData()
            self.view.layoutIfNeeded()
        }
        print(self.searchArray)
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
