//
//  ReportViewController.swift
//  Kethan
//
//  Created by Ashwini on 13/03/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class ReportViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var viewBlur: UIView!
    @IBOutlet weak var viewPopup: UIView!
    
    @IBOutlet weak var txtView: CustomTextView!
    @IBOutlet weak var txtImplant: CustomTextField!
    var addCompletion:((_ str: String, _ location: String, _ selectedImageArray: NSArray) -> Void)?
    
    @IBOutlet weak var btnClose: CustomButton!
    @IBOutlet weak var collectionView: UICollectionView!
       
    var arrAllItems = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNormalEditEnabled = false
        self.btnClose.alpha = 0
        self.txtImplant.font = UIFont(name: self.txtImplant.font!.fontName, size: getCalculated(14.0))
        // Do any additional setup after loading the view.
        
        self.collectionView.register(UINib(nibName: IDENTIFIERS.AddDetail1CollectionViewCell, bundle: nil), forCellWithReuseIdentifier: IDENTIFIERS.AddDetail1CollectionViewCell)
               
               let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
               layout.itemSize = CGSize(width: getCalculated(95.0), height: getCalculated(95.0))
               layout.minimumLineSpacing = getCalculated(4.0)
               layout.minimumInteritemSpacing = 0
               layout.sectionInset = UIEdgeInsets.zero
               layout.scrollDirection = .vertical
               self.collectionView.collectionViewLayout = layout
    }
    
    // MARK: - Button Action
    @IBAction func cancelClickAction(_ sender: Any) {
        self.showAlert(title: "", message: "Do you want to exit without reporting? Selections you made so far will not be saved.", yesTitle: "Yes", noTitle: "No", yesCompletion: {
             self.dismissWithCompletion {
                       if self.addCompletion != nil {
                           self.addCompletion!("", "", self.arrAllItems)
                       }
                   }
        }, noCompletion: nil)
    }
    
    @IBAction func addClickAction(_ sender: Any) {
        if !self.txtView.text.isEmpty {
            self.dismissWithCompletion {
                if self.addCompletion != nil {
                    self.view.endEditing(true)
                    self.addCompletion!(self.txtView.text!, self.txtImplant.text!, self.arrAllItems)
                }
            }
        } else {
             ProgressManager.showError(withStatus: "Please add a reason for reporting", on: self.view)
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
        
        self.showPopupWithView(viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: self.btnClose)
        self.btnClose.alpha = 1.0
    }
    
    func dismissWithCompletion(completion: @escaping VoidCompletion) {
        self.dismissPopupWithView(remove: false, viewPopup: self.viewPopup, viewContainer: self.view, viewBlur: self.viewBlur, btnClose: nil) {
            completion()
        }
    }
    
    @objc func deleteImage(_ sender: CustomButton) {
           self.showAlert(title: "", message: "Do you want to remove this image from set of concerned images?", yesTitle: "Yes", noTitle: "No", yesCompletion: {
               if self.arrAllItems.count > 0 {
                   self.arrAllItems.removeObject(at: sender.indexPath.item)
                   self.collectionView.reloadData()
               }
           }, noCompletion: nil)
       }
    
    func getValueFromUserDefault(key: String) -> [NSString] {
        if let arr = getUserDefaultsForKey(key: key) as? [NSString] {
            return arr
        }
        return []
    }
    
    override func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let controller: ManufacturesPopUpViewController = self.instantiate(ManufacturesPopUpViewController.self, storyboard: STORYBOARD.main) as? ManufacturesPopUpViewController {
            controller.preparePopup(controller: self)
            controller.showPopup(array: getValueFromUserDefault(key: UserDefaultsKeys.BrandName) as [String], textName: self.txtImplant.text!, isManufacture: false)
            controller.addCompletion = { selectedText in
                self.txtImplant.text = selectedText
            }
        }
        return false
    }
    
    // MARK: - CollectionView Dalegate and DataSource
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return arrAllItems.count
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddDetail1CollectionViewCell", for: indexPath) as? AddDetail1CollectionViewCell {
               cell.lblAdd.alpha = 0
               cell.imgPlus.alpha = 0
               
            let obj = ImageData(dictionary: arrAllItems[indexPath.row] as! NSDictionary)
                   cell.btnDelete.alpha = 1.0
                   cell.layoutIfNeeded()
                   cell.imgSelected.setImageWithPlaceHolderImage(obj.imageName, true, true, PLACEHOLDERS.small) {
                       if obj.objectLocation.imageWidth.count != 0 || obj.objectLocation.imageHeight.count != 0 {
                           cell.imgSelected.drawRectangle(frameSize: CGSize(width: cell.imgSelected.bounds.width, height: cell.imgSelected.bounds.height), imageWidth: CGFloat(obj.objectLocation.imageWidth.floatValue()), imageHight: CGFloat(obj.objectLocation.imageHeight.floatValue()), drawSize: CGRect(x: CGFloat(obj.objectLocation.left.floatValue()), y: CGFloat(obj.objectLocation.top.floatValue()), width: CGFloat(obj.objectLocation.width.floatValue()), height: CGFloat(obj.objectLocation.height.floatValue())))
                       }
                   }
               cell.btnDelete.indexPath = indexPath
               cell.btnDelete.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
               return cell
           }
           return UICollectionViewCell()
       }
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
         
//           if let collectionCell = self.collectionView.cellForItem(at: indexPath) as? AddDetail1CollectionViewCell {
//               let controller = getTopViewController()
//               controller!.openGalleryList(indexpath: indexPath, imgNameArr: NSMutableArray(array: STATICDATA.arrImages), sourceView: collectionCell.imgSelected)
//           }
       }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           return CGSize(width: getCalculated(95.0), height: getCalculated(95.0))
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
