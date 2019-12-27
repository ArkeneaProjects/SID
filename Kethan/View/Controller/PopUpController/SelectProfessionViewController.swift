//
//  SelectProfessionViewController.swift
//  Kethan
//
//  Created by Apple on 26/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SelectProfessionViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var viewBlur: UIView!
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var tblView: UITableView!
    
    var addCompletion:((_ profession: String) -> Void)?
    
    @IBOutlet weak var btnClose: CustomButton!
    
    var lblProfession = ""

    var arrItem = ["Nurse", "Technical Advisor", "Surgical Advisor", "Doctor/Surgeon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.register(UITableViewCell.self, forCellReuseIdentifier: "professionCell")
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = getCalculated(20.0)
        self.tblView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func cancelClickAction(_ sender: Any) {
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.addCompletion!("")
            }
        }
    }
    
    @IBAction func addClickAction(_ sender: Any) {
        if self.lblProfession.count == 0 {
            ProgressManager.showError(withStatus: ERRORS.professionSelect, on: self.view)
            return
        }
        self.dismissWithCompletion {
            if self.addCompletion != nil {
                self.addCompletion!(self.lblProfession)
            }
        }
    }
    
    // MARK: - Custom Functions -
    func preparePopup(selectedText: String, controller: BaseViewController) {
        self.lblProfession = selectedText
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
        return self.arrItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "professionCell") {
            cell.textLabel?.text = self.arrItem[indexPath.row]
            cell.accessoryType = (self.arrItem[indexPath.row] == self.lblProfession) ?.checkmark:.none
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.tblView.reloadData()
        self.lblProfession = self.arrItem[indexPath.row]
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
