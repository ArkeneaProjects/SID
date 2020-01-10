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
    @IBOutlet weak var btnUpload: CustomButton!
    
    var imagePicker: GalleryManager!
    var implantObj = SearchResult()
    var implantVM = AddImplantVM()
    
    var imageArray = NSMutableArray()
    var deletedImageArr = NSMutableArray()
    var deletedProcessArr = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Add Details", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        // Do any additional setup after loading the view.
        
        self.implantVM.implantObj = self.implantObj
        self.imageArray = NSMutableArray(array: self.implantVM.implantObj.imageData)
        self.checkAndAddPulsButton()
        
        self.btnUpload.setTitle((self.implantObj._id.count == 0) ?"Upload for verification":"Update for verification", for: .normal)
        
        self.tblView.registerNibWithIdentifier([IDENTIFIERS.AddDetailHeader1Cell, IDENTIFIERS.AddDetailHeader2Cell, IDENTIFIERS.AddDetailHeader3Cell])
        
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = getCalculated(20.0)
        self.tblView.tableFooterView = UIView()
        
        //Gallery
        self.imagePicker = GalleryManager(presentationController: self, delegate: self)
    }
    
    // MARK: - Button Click Action
    @IBAction func uploadClickAction(_ sender: CustomButton) {
        self.implantVM.uploadImplant(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          self.reloadTableView(IndexPath(item: 0, section: 0))
    }
    
    @objc func addProcess(_ sender: CustomButton) {
        let controller: ResponsePopUpViewController = self.instantiate(ResponsePopUpViewController.self, storyboard: STORYBOARD.main) as? ResponsePopUpViewController ?? ResponsePopUpViewController()
        controller.preparePopup(controller: self)
        controller.showPopup()
        controller.addCompletion = { str, location, date in
            if str.count > 0 {
                let removalProcess: NSDictionary = ["removalProcess": str, "surgeryDate": date, "surgeryLocation": location, "userId": AppConstant.shared.loggedUser.userId, "isApproved": "0"]
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
        }
    }
    
    @objc func seeAllProcesses(_ sender: CustomButton) {
        if let processListVC = self.instantiate(ProcessListViewController.self, storyboard: STORYBOARD.main) as? ProcessListViewController {
            processListVC.processArray = self.implantVM.implantObj.removImplant
            processListVC.saveCompletion = { array in
                self.deletedProcessArr = array
                self.tblView.reloadData()
            }
            self.navigationController?.pushViewController(processListVC, animated: true)
        }
    }
    
    @objc func seeAllImages(_ sender: CustomButton) {
        if let imagesListVC = self.instantiate(ImageListViewController.self, storyboard: STORYBOARD.main) as? ImageListViewController {
            imagesListVC.arrAllItems = self.imageArray
            imagesListVC.saveCompletion = { array, allImagesArray in
                for objImage in array {
                    if let obj = objImage as? ImageData {
                        self.implantVM.arrDeletedImage.add(obj.id)
                    }
                }
                var arrImage = [ImageData]()
                for obj in allImagesArray {
                    if let imgObj = obj as? ImageData {
                        arrImage.append(imgObj)
                    }
                }
                self.implantVM.implantObj.imageData = arrImage
//                self.implantVM.implantObj.imageData = allImagesArray as! [ImageData]
//                self.deletedImageArr = array
                self.tblView.reloadData()
            }
            self.navigationController?.pushViewController(imagesListVC, animated: true)
        }
    }
    
    func reloadTableView(_ indexPath: IndexPath) {
        if indexPath.row == 0 {
            if let cell = self.tblView.cellForRow(at: indexPath) as? AddDetailHeader1Cell {
                cell.collectionView.reloadData()
            }
        }
        
        UIView.performWithoutAnimation {
            let loc = self.tblView.contentOffset
            self.tblView.reloadRows(at: [indexPath], with: .none)
            self.tblView.contentOffset = loc
        }
    }
    
    func checkAndAddPulsButton() {
        if (self.imageArray.lastObject as? ImageData) != nil || self.imageArray.count == 0 {
            if self.imageArray.count >= 4 {
                let arr = NSMutableArray()
                for i in 0..<self.imageArray.count where i <= 4 {
                    arr.add(self.imageArray[i])
                }
                arr.add(["lineImage"])
                self.imageArray = NSMutableArray(array: arr)
            } else {
                self.imageArray.add(["lineImage"])
            }
        } else {
            if (self.imageArray.lastObject as? NSArray) == nil {
                if self.imageArray.count > 1 {
                    let totalCount = self.imageArray.count
                    self.imageArray.removeObject(at: totalCount - 2)
                }
            }
        }
    }
    
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return (self.imageArray.count > 3) ?getCalculated(240.0):getCalculated(130.0)
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.AddDetailHeader1Cell, for: indexPath) as? AddDetailHeader1Cell {
                cell.arrAllItems = self.imageArray
                cell.btnSeeAll.isHidden = (self.imageArray.count < 7) ?true:false
                cell.btnSeeAll.indexPath = indexPath
                cell.btnSeeAll.addTarget(self, action: #selector(seeAllImages(_:)), for: .touchUpInside)
                
                //Delete Image
                cell.deleteImageCompletion = { index_Path in
                    self.showAlert(title: "", message: "Delete Image?", yesTitle: "Yes", noTitle: "NO", yesCompletion: {
                        if let objImage = self.imageArray.object(at: indexPath.row) as? ImageData {
                            self.implantVM.arrDeletedImage.add(objImage.id)
                            self.imageArray.removeObject(at: index_Path.item)
                        }
                        var arrImage = [ImageData]()
                        for obj in self.imageArray {
                            if let imgObj = obj as? ImageData {
                                arrImage.append(imgObj)
                            }
                        }
                        self.implantVM.implantObj.imageData = arrImage
                        self.checkAndAddPulsButton()
                        cell.arrAllItems = self.imageArray
                        
                        if self.imageArray.count == 3 {
                            self.tblView.reloadData()
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
    
                return cell
            }
        } else if indexPath.row == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.AddDetailHeader2Cell, for: indexPath) as? AddDetailHeader2Cell {
                
                cell.lblImplant.text = self.implantVM.implantObj.objectName
                cell.lblManufacture.text = self.implantVM.implantObj.implantManufacture
                //                cell.btnSurgeryDate.addTarget(self, action: #selector(dateBtnClickAction(_:)), for: .touchUpInside)
                //                cell.btnLocation.addTarget(self, action: #selector(placeBtnClickAction(_:)), for: .touchUpInside)
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
                        if let objImplant =  self.implantVM.implantObj.removImplant.object(at: tableCell)  as? Implant {
                            self.implantVM.arrDeletedProcess.add(objImplant.id)
                            self.implantVM.implantObj.removImplant.removeObject(at: tableCell)
                        }
                      
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
            controller.continueCompletion = { implantImageObj in
                print(implantImageObj.dictioary())
                self.imageArray.add(implantImageObj)
                self.checkAndAddPulsButton()
                self.implantVM.implantObj.implantImage = implantImageObj
                self.tblView.reloadData()
            }
            if let size = image!.getFileSize() {
                //check image size is not more than 3 MB
                if size >= 1.0 {
                    controller.selectedImage = image!.imageWithImage(scaledToWidth: 600.0)
                    
                } else {
                    controller.selectedImage = image!
                }
            } else {
                controller.selectedImage = image!
            }
            ProgressManager.dismiss()
            self.navigationController?.pushViewController(controller, animated: true)
        }
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
