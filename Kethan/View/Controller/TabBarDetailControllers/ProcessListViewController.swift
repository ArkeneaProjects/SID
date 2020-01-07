//
//  ProcessListViewController.swift
//  Kethan
//
//  Created by Ashwini on 02/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class ProcessListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var processTblView: UITableView!
    @IBOutlet weak var btnAddProcess: CustomButton!
    
    var processArray = NSMutableArray()
    var saveCompletion: ((_ processArray:NSMutableArray) -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Removal Process", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeSave)
        
        self.processTblView.rowHeight = UITableView.automaticDimension
        self.processTblView.estimatedRowHeight = getCalculated(50.0)
    }
    
    override func rightButtonAction() {
        self.saveCompletion!(self.processArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddProcessClicked(_ sender: CustomButton) {
        let controller: ResponsePopUpViewController = self.instantiate(ResponsePopUpViewController.self, storyboard: STORYBOARD.main) as? ResponsePopUpViewController ?? ResponsePopUpViewController()
        controller.preparePopup(controller: self)
        controller.showPopup()
        controller.addCompletion = { str, location, date in
            if str.count > 0 {
                let removalProcess:NSDictionary = ["removalProcess" : str, "surgeryDate" : date, "surgeryLocation" : location]
                let implant = Implant(dictionary: removalProcess)
                self.processArray.insert(implant, at: 0)
                self.processTblView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return processArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let process: Implant = self.processArray.object(at: indexPath.row) as! Implant
        let cell: ProcessListCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProcessListCell.self), for: indexPath) as! ProcessListCell
        cell.lblProcessTitle.text = process.removalProcess
        if process.surgeryDate.count > 0 {
            cell.lblSurgeryDate.text = process.surgeryDate.convertLocalTimeZoneToUTC(actualFormat: "yyyy-MM-dd HH:mm", expectedFormat: "dd/MM/yyyy", actualZone: TimeZone(identifier: "UTC")!, expectedZone: NSTimeZone.local)
            cell.constDateHeight.constant = 18.0
        } else {
            cell.constDateHeight.constant = 0.0
            cell.constSurgeryDateTop.constant = 0.0
        }
        
        if process.surgeryLocation.count > 0 {
            cell.lblLocation.text = process.surgeryLocation
            cell.constLocationImgHeight.constant = 18.0
        } else {
            cell.constLocationImgHeight.constant = 0.0
            cell.constSurgeryDateBottom.constant = 0.0
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            self.showAlert(title: "Delete Removal Process?", message: "", yesTitle: "Delete", noTitle: "Cancel", yesCompletion: {
                self.processArray.removeObject(at: index.row)
                self.processTblView.reloadData()
                
            }, noCompletion: nil)
        }
        delete.backgroundColor = UIColor.red
        return [delete]
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
