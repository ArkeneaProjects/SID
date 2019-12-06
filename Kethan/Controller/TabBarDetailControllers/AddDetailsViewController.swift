//
//  AddDetailsViewController.swift
//  Kethan
//
//  Created by Apple on 26/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class AddDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, GalleryManagerDelegate {

    @IBOutlet weak var tblView: UITableView!
    
    var imagePicker: GalleryManager!
    
    var arrItem = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Add Details", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        // Do any additional setup after loading the view.
        
        self.arrItem = NSMutableArray(array: STATICDATA.arrProcess)
        self.tblView.registerNibWithIdentifier([IDENTIFIERS.AddDetailHeader1Cell, IDENTIFIERS.AddDetailHeader2Cell, IDENTIFIERS.AddDetailHeader3Cell])
        
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = getCalculated(20.0)
        self.tblView.tableFooterView = UIView()
        
        //Gallery
        self.imagePicker = GalleryManager(presentationController: self, delegate: self)
    }
    
    // MARK: - Button Click Action
    @IBAction func uploadClickAction(_ sender: CustomButton) {
        if let controller = self.instantiate(ThankYouViewController.self, storyboard: STORYBOARD.main) as? ThankYouViewController {
            controller.isComeFromSupport = false
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func addProcess(_ sender: CustomButton) {
        let controller: ResponsePopUpViewController = self.instantiate(ResponsePopUpViewController.self, storyboard: STORYBOARD.main) as? ResponsePopUpViewController ?? ResponsePopUpViewController()
        controller.preparePopup(controller: self)
        controller.showPopup()
        controller.addCompletion = { str in
            if str.count > 0 {
                self.arrItem.insert(str, at: 0)
                if let cell = self.tblView.cellForRow(at: sender.indexPath) as? AddDetailHeader3Cell {
                    cell.arrTableView = self.arrItem
                    cell.populateVehicleListing()
                    cell.viewListing.layoutIfNeeded()
                    cell.layoutIfNeeded()
                    UIView.performWithoutAnimation {
                        let loc = self.tblView.contentOffset
                        self.tblView.reloadRows(at: [sender.indexPath], with: .none)
                        self.tblView.contentOffset = loc
                    }
                }
            }
            print(str)
        }
    }
    @objc func dateBtnClickAction(_ sender: CustomButton) {
        let controller: DatePopUpViewController = self.instantiate(DatePopUpViewController.self, storyboard: STORYBOARD.main) as? DatePopUpViewController ?? DatePopUpViewController()
        controller.preparePopup(controller: self)
        controller.showPopup()
        controller.addCompletion = { date in
            if date.count > 0 {
                if let cell = self.tblView.cellForRow(at: sender.indexPath) as? AddDetailHeader2Cell {
                    cell.btnSurgeryDate.setTitle(date, for: .normal)
                    let indexpath = IndexPath(row: 2, section: 0)
                    UIView.performWithoutAnimation {
                        let loc = self.tblView.contentOffset
                        self.tblView.reloadRows(at: [indexpath], with: .none)
                        self.tblView.contentOffset = loc
                    }
                }
            }
            print(date)
        }
    }
    
    @objc func placeBtnClickAction(_ sender: CustomButton) {
        
    }
    
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return (STATICDATA.arrImagesSmall.count >= 3) ?getCalculated(240.0):getCalculated(130.0)
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.AddDetailHeader1Cell, for: indexPath) as? AddDetailHeader1Cell {
                cell.arrAllItems = NSMutableArray(array: STATICDATA.arrImagesSmall)
                cell.cellSelectionCompletion = { index_Path in
                    self.imagePicker.present()
                }
                return cell
            }
        } else if indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.AddDetailHeader2Cell, for: indexPath) as? AddDetailHeader2Cell {
                
                cell.btnSurgeryDate.indexPath = indexPath
                cell.btnLocation.indexPath = indexPath
                cell.btnSurgeryDate.addTarget(self, action: #selector(dateBtnClickAction(_:)), for: .touchUpInside)
                cell.btnLocation.addTarget(self, action: #selector(placeBtnClickAction(_:)), for: .touchUpInside)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.AddDetailHeader3Cell, for: indexPath) as? AddDetailHeader3Cell {
                cell.arrTableView = self.arrItem
                cell.populateVehicleListing()
                cell.viewListing.layoutIfNeeded()
                cell.layoutIfNeeded()
                cell.selectionStyle = .none
                cell.btnAddResponse.indexPath = indexPath
                cell.btnAddResponse.addTarget(self, action: #selector(addProcess(_:)), for: .touchUpInside)
                cell.cellSelectionCompletion = { tableCell in
                    self.arrItem.removeObject(at: tableCell)
                    UIView.performWithoutAnimation {
                        let loc = self.tblView.contentOffset
                        self.tblView.reloadRows(at: [indexPath], with: .none)
                        self.tblView.contentOffset = loc
                    }
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    // MARK: - Gallery Delegate
    func didSelect(image: UIImage?) {
        print(image)
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
