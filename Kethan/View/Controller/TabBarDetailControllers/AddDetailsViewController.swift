//
//  AddDetailsViewController.swift
//  Kethan
//
//  Created by Apple on 26/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces

class AddDetailsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, GalleryManagerDelegate, GMSAutocompleteViewControllerDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    
    var imagePicker: GalleryManager!
    var implantObj = SearchResult()
    var implantVM = AddImplantVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Add Details", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        // Do any additional setup after loading the view.
        
        implantVM.arrImages = NSMutableArray(array: STATICDATA.arrImagesSmall)
        
        //save self. implant object into VM class implant object
        implantVM.implantObj = self.implantObj
        
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
            controller.isComeFrom = 1
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func addProcess(_ sender: CustomButton) {
        let controller: ResponsePopUpViewController = self.instantiate(ResponsePopUpViewController.self, storyboard: STORYBOARD.main) as? ResponsePopUpViewController ?? ResponsePopUpViewController()
        controller.preparePopup(controller: self)
        controller.showPopup()
        controller.addCompletion = { str in
            if str.count > 0 {
                let removalProcess: NSDictionary = ["removalProcess" : str, "surgeryDate" : "", "surgeryLocation" : ""]
                let implant = Implant(dictionary: removalProcess)
                self.implantVM.implantObj.removImplant.insert(implant, at: 0)
                if let cell = self.tblView.cellForRow(at: sender.indexPath) as? AddDetailHeader3Cell {
                    if self.implantVM.implantObj.removImplant.count > 5 {
                        let tempArray: NSArray = self.implantVM.implantObj.removImplant.subarray(with: NSRange(location: 0, length: 5)) as NSArray
                        cell.arrTableView = NSMutableArray(array: tempArray)
                    } else {
                        cell.arrTableView = self.implantVM.implantObj.removImplant
                    }
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
    
    @objc func seeAllProcesses(_ sender: CustomButton) {
        if let processListVC = self.instantiate(ProcessListViewController.self, storyboard: STORYBOARD.main) as? ProcessListViewController {
            processListVC.processArray = self.implantVM.implantObj.removImplant
            processListVC.saveCompletion = { array in
                self.implantVM.implantObj.removImplant = array
                self.tblView.reloadData()
            }
            self.navigationController?.pushViewController(processListVC, animated: true)
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
//                    self.implantVM.implantObj.surgeryDate = date
                    self.reloadTableView(IndexPath(row: 2, section: 0))
                }
            }
            print(date)
        }
    }
    
    @objc func placeBtnClickAction(_ sender: CustomButton) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        // Specify the place data types to return.
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
            UInt(GMSPlaceField.placeID.rawValue))!
        autocompleteController.placeFields = fields
        
        // Specify a filter.
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        autocompleteController.autocompleteFilter = filter
        
        self.present(autocompleteController, animated: true, completion: nil)
    }
    
    func reloadTableView(_ indexPath: IndexPath) {
        UIView.performWithoutAnimation {
            let loc = self.tblView.contentOffset
            self.tblView.reloadRows(at: [indexPath], with: .none)
            self.tblView.contentOffset = loc
        }
    }
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return (implantVM.arrImages.count > 3) ?getCalculated(240.0):getCalculated(130.0)
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.AddDetailHeader1Cell, for: indexPath) as? AddDetailHeader1Cell {
                cell.arrAllItems = implantVM.arrImages
                cell.btnSeeAll.isHidden = implantVM.arrImages.count < 6
                //Delete Image
                cell.deleteImageCompletion = { index_Path in
                    self.showAlert(title: "", message: "Delete Image?", yesTitle: "Yes", noTitle: "NO", yesCompletion: {
                        self.implantVM.arrImages.removeObject(at: index_Path.item)
                        cell.arrAllItems = self.implantVM.arrImages
                        if cell.arrAllItems.count == 3 {
                            self.reloadTableView(indexPath)
                        }
                    }, noCompletion: nil)
                }
                
                // Image Selection
                cell.cellSelectionCompletion = { index_Path in
                    self.showActionSheet(headerTitle: "Choose Image From", cameraTitle: "Camera", galleryTitle: "Gallery", galleryCompletion: {
                        self.imagePicker.present(croppingStyle: .circular, isCrop: false, isCamera: false)
                    }) {
                        self.imagePicker.present(croppingStyle: .circular, isCrop: false, isCamera: true)
                    }
                }
                
                cell.seeAllImageCompletion = {
            
                }
                
                return cell
            }
        } else if indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.AddDetailHeader2Cell, for: indexPath) as? AddDetailHeader2Cell {
                
                cell.lblImplant.text = self.implantVM.implantObj.objectName
                cell.lblManufacture.text = self.implantVM.implantObj.implantManufacture
                cell.btnSurgeryDate.indexPath = indexPath
                cell.btnLocation.indexPath = indexPath
                cell.btnSurgeryDate.addTarget(self, action: #selector(dateBtnClickAction(_:)), for: .touchUpInside)
                cell.btnLocation.addTarget(self, action: #selector(placeBtnClickAction(_:)), for: .touchUpInside)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.AddDetailHeader3Cell, for: indexPath) as? AddDetailHeader3Cell {
                if implantVM.implantObj.removImplant.count > 5 {
                    let tempArray: NSArray = implantVM.implantObj.removImplant.subarray(with: NSRange(location: 0, length: 5)) as NSArray
                    cell.arrTableView = NSMutableArray(array: tempArray)
                } else {
                    cell.arrTableView = self.implantVM.implantObj.removImplant
                }
                cell.populateVehicleListing()
                cell.viewListing.layoutIfNeeded()
                cell.layoutIfNeeded()
                cell.selectionStyle = .none
                cell.btnAddResponse.indexPath = indexPath
                cell.btnAddResponse.addTarget(self, action: #selector(addProcess(_:)), for: .touchUpInside)
                cell.btnSeeAll.isHidden = self.implantVM.implantObj.removImplant.count < 6
                cell.btnSeeAll.indexPath = indexPath
                cell.btnSeeAll.addTarget(self, action: #selector(seeAllProcesses(_:)), for: .touchUpInside)
                
                //Delete Process
                cell.cellSelectionCompletion = { tableCell in
                    self.showAlert(title: "Delete Process?", message: "", yesTitle: "Delete", noTitle: "Cancel", yesCompletion: {
                        self.implantVM.implantObj.removImplant.removeObject(at: tableCell)
                        self.reloadTableView(indexPath)
                        
                    }, noCompletion: nil)
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
        ProgressManager.show(withStatus: "", on: self.view)
        if let controller = self.instantiate(TagViewController.self, storyboard: STORYBOARD.main) as? TagViewController {
            //Get cordinate value from Tagview controller
            controller.continueCompletion = { cordinate in
                print(cordinate.dictioary())
            }
            
            controller.selectedImage = self.checkImageSize(image!)
            
            ProgressManager.dismiss()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK:- GMSAutocompleteViewControllerDelegate -
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let address = place.name
        let cell = self.tblView.cellForRow(at: IndexPath(row: 1, section: 0)) as! AddDetailHeader2Cell
        cell.btnLocation.setTitle(address, for: .normal)
        //self.implantVM.implantObj.surgeryLocation = address
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
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
