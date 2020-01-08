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
        
        self.addNavBarWithTitle("Removal Process", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        
        self.processTblView.rowHeight = UITableView.automaticDimension
        self.processTblView.estimatedRowHeight = getCalculated(50.0)
    }
    
    @objc func deleteProcess(_ sender: CustomButton) {
        self.showAlert(title: "Delete Process?", message: "", yesTitle: "Delete", noTitle: "Cancel", yesCompletion: {
            if self.saveCompletion != nil {
                self.processArray.removeObject(at: sender.indexPath.row)
                self.processTblView.reloadData()
                self.saveCompletion!( self.processArray)
            }
        }, noCompletion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return processArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell: ProcessListCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProcessListCell.self), for: indexPath) as? ProcessListCell {
            let process: Implant = self.processArray.object(at: indexPath.row) as? Implant ?? Implant()
            cell.lblProcessTitle.text = process.removalProcess
            cell.btnDelete.alpha = (process.isApproved == "0" && process.userId == AppConstant.shared.loggedUser.userId) ?1.0:0
            cell.btnDelete.indexPath = indexPath
            cell.btnDelete.addTarget(self, action: #selector(deleteProcess(_:)), for: .touchUpInside)
            
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
        return UITableViewCell()
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
