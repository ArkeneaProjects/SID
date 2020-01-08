//
//  ImageListViewController.swift
//  Kethan
//
//  Created by Ashwini on 08/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class ImageListViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, GalleryManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var arrAllItems = NSMutableArray()
    var imagePicker: GalleryManager!
    var isNewUpload: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Implant Images", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeSave)
        
        self.collectionView.register(UINib(nibName: IDENTIFIERS.AddDetail1CollectionViewCell, bundle: nil), forCellWithReuseIdentifier: IDENTIFIERS.AddDetail1CollectionViewCell)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: getCalculated(92.0), height: getCalculated(92.0))
        layout.minimumLineSpacing = getCalculated(8.0)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = layout
        
    }
    
    @objc func deleteImage(_ sender: CustomButton) {
        self.showAlert(title: "", message: "Delete Image?", yesTitle: "Yes", noTitle: "NO", yesCompletion: {
            if self.arrAllItems.count > 0 {
                self.arrAllItems.removeObject(at: sender.indexPath.item)
            } else {
               
            }
            
        }, noCompletion: nil)
    }
    
    // MARK: - CollectionView Dalegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAllItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddDetail1CollectionViewCell", for: indexPath) as? AddDetail1CollectionViewCell {
            cell.lblAdd.alpha = 0
            cell.imgPlus.alpha = 0
            cell.btnDelete.alpha = 1.0
            
//            if self.arrAllItems[indexPath.item] as? String ?? "" == "lineImage" {
//                cell.lblAdd.alpha = 1.0
//                cell.imgPlus.alpha = 1.0
//                cell.btnDelete.alpha = 0
//                cell.imgSelected.image = UIImage(named: self.arrAllItems[indexPath.item] as? String ?? "")
//
//            } else {
                if self.isNewUpload {
                    if let implantObj = self.arrAllItems[indexPath.item] as? ImplantImage {
                        cell.imgSelected.image = implantObj.selectedImage
                        
                        cell.imgSelected.drawRectangle(frameSize: CGSize(width: cell.imgSelected.frame.width, height: cell.imgSelected.frame.height), imageWidth: CGFloat(implantObj.imageWidth.floatValue()), imageHight: CGFloat(implantObj.imageHeight.floatValue()), drawSize: CGRect(x: CGFloat(implantObj.labelOffsetX.floatValue()), y: CGFloat(implantObj.labelOffsetY.floatValue()), width: CGFloat(implantObj.labelWidth.floatValue()), height: CGFloat(implantObj.labelHeight.floatValue())))
                        
                    }
                } else {
                    cell.imgSelected.image = UIImage(named: self.arrAllItems[indexPath.item] as? String ?? "")
                }
                cell.btnDelete.indexPath = indexPath
                cell.btnDelete.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
//            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
//        if self.arrAllItems[indexPath.item] as? String ?? "" == "lineImage" {
//            self.showActionSheet(headerTitle: "Choose Image From", cameraTitle: "Camera", galleryTitle: "Gallery", galleryCompletion: {
//                self.imagePicker.present(croppingStyle: .circular, isCrop: false, isCamera: false)
//            }) {
//                self.imagePicker.present(croppingStyle: .circular, isCrop: false, isCamera: true)
//            }
//        } else {
            if let collectionCell = self.collectionView.cellForItem(at: indexPath) as? AddDetail1CollectionViewCell {
                let controller = getTopViewController()
                controller!.openGalleryList(indexpath: indexPath, imgNameArr: NSMutableArray(array: STATICDATA.arrImages), sourceView: collectionCell.imgSelected)
            }
//        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getCalculated(92.0), height: getCalculated(92.0))
    }
    
    // MARK: - Gallery Delegate
    func didSelect(image: UIImage?) {
        ProgressManager.show(withStatus: "", on: self.view)
        if let controller = self.instantiate(TagViewController.self, storyboard: STORYBOARD.main) as? TagViewController {
            //Get cordinate value from Tagview controller
            controller.continueCompletion = { implantImageObj in
                print(implantImageObj.dictioary())
                self.arrAllItems.add(implantImageObj)
                self.collectionView.reloadData()
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
