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
    
    var arrUpoading = NSMutableArray()
    var imageArray = NSMutableArray()
    var deletedImageArr = NSMutableArray()
    var deletedProcessArr = NSMutableArray()
    
    var isCameFromImageScreen: Bool = false  //User came from search image screen
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Add Details", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        // Do any additional setup after loading the view.
        
        self.implantVM.implantObj = self.implantObj
       // if isCameFromImageScreen == false {
            self.imageArray = NSMutableArray(array: self.implantVM.implantObj.imageData)
            self.arrUpoading = NSMutableArray(array: self.implantVM.implantObj.imageData)
     //   }

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
                let removalProcess: NSDictionary = ["removalProcess": str.encodeEmoji(), "surgeryDate": date, "surgeryLocation": location, "userId": AppConstant.shared.loggedUser.userId, "isApproved": "0"]
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
            imagesListVC.arrAllItems = self.arrUpoading
            imagesListVC.saveCompletion = { array, allImagesArray in
                for objImage in array {
                    if let obj = objImage as? ImageData {
                        //Save deleted image id
                        self.implantVM.arrDeletedImage.add(obj.id)
                        
                        //Delete Image
                        for item in self.imageArray {
                            if let itemObj = item as? ImageData {
                                if itemObj.id == obj.id {
                                    self.imageArray.remove(itemObj)
                                    let arr = self.arrUpoading.filtered(using: NSPredicate(format: "id == %@", argumentArray: [itemObj.id]))
                                    if arr.count > 0 {
                                        self.arrUpoading.remove(arr.last!)
                                    }
                                }
                            }
                        }
                    }
                }
                self.checkAndAddPulsButton()
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
            if self.arrUpoading.count >= 4 {
                let arr = NSMutableArray()
                for i in 0..<self.arrUpoading.count where i <= 4 {
                    arr.add(self.arrUpoading[i])
                }
                if let imageObj = self.arrUpoading.lastObject as? ImplantImage {
                    arr.add(imageObj)
                } else {
                    arr.add(["lineImage"])
                }
                self.imageArray = NSMutableArray(array: arr)
            } else {
               if (self.imageArray.lastObject as? ImplantImage) != nil || (self.imageArray.lastObject as? NSArray) != nil {
                    
                } else {
                    self.imageArray.add(["lineImage"])
                }
            }
        }
    
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return (self.imageArray.count > 3) ? getCalculated(240.0) : getCalculated(130.0)
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.AddDetailHeader1Cell, for: indexPath) as? AddDetailHeader1Cell {
                cell.layoutIfNeeded()
                cell.arrAllItems = self.imageArray
                cell.btnSeeAll.isHidden = (self.imageArray.count > 5) ?false:true
                cell.btnSeeAll.indexPath = indexPath
                cell.btnSeeAll.addTarget(self, action: #selector(seeAllImages(_:)), for: .touchUpInside)
                
                //Delete Image
                cell.deleteImageCompletion = { index_Path in
                    self.showAlert(title: "", message: "Delete Image?", yesTitle: "Yes", noTitle: "NO", yesCompletion: {
                        if let objImage = self.imageArray[index_Path.row] as? ImageData {
                            self.implantVM.arrDeletedImage.add(objImage.id)
                            self.imageArray.removeObject(at: index_Path.item)
                            
                            let arr = self.arrUpoading.filtered(using: NSPredicate(format: "id == %@", argumentArray: [objImage.id]))
                            if arr.count > 0 {
                                self.arrUpoading.remove(arr.last!)
                            }
                        } else {
                            self.imageArray.removeObject(at: index_Path.item)
                            self.implantVM.implantObj.implantImage = ImplantImage()
                            self.arrUpoading.removeLastObject()
                        }
                       
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
                        self.imagePicker.present(croppingStyle: .default, isCrop: true, isCamera: false)
                    }) {
                        self.imagePicker.present(croppingStyle: .default, isCrop: true, isCamera: true)
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
                self.imageArray.removeLastObject()
                self.imageArray.add(implantImageObj)
                self.arrUpoading.add(implantImageObj)
                self.implantVM.implantObj.implantImage = implantImageObj
                self.tblView.reloadData()
            }
            
           // controller.selectedImage = self.resizeImageWithAspect(image: image!, scaledToMaxWidth: getCalculated(640.0), maxHeight: getCalculated(854.0))
            controller.selectedImage = image!.resizeImage(targetSize: CGSize(width: getCalculated(640.0), height: getCalculated(854.0)))

            ProgressManager.dismiss()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func imageWithSize(image: UIImage, size: CGSize) -> UIImage {
        if UIScreen.main.responds(to: #selector(NSDecimalNumberBehaviors.scale)) {
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        } else {
             UIGraphicsBeginImageContext(size)
        }
        image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        //image.draw(in: CGRectMake(0, 0, size.width, size.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }

    //Summon this function VVV
    func resizeImageWithAspect(image: UIImage, scaledToMaxWidth width: CGFloat, maxHeight height :CGFloat) -> UIImage {
        let oldWidth = image.size.width
        let oldHeight = image.size.height

        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight

        let newHeight = oldHeight * scaleFactor
        let newWidth = oldWidth * scaleFactor
        let newSize = CGSize(width: newWidth, height: newHeight)
       // let newSize = CGSizeMake(newWidth, newHeight);

        return imageWithSize(image: image, size: newSize)
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
