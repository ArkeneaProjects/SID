//
//  ImageListViewController.swift
//  Kethan
//
//  Created by Ashwini on 08/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class ImageListViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var arrAllItems = NSMutableArray()
    var deletedImageArr = NSMutableArray()

    var imagePicker: GalleryManager!
    
    var isNewUpload: Bool = false
    
    var saveCompletion: ((_ deletedImageArray: NSMutableArray, _ allImageArray: NSMutableArray) -> Void)? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Implant Images", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        
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
                self.deletedImageArr.add(self.arrAllItems[sender.indexPath.item])
                self.arrAllItems.removeObject(at: sender.indexPath.item)
                if self.saveCompletion != nil {
                    self.saveCompletion!( self.deletedImageArr, self.arrAllItems)
                }
                self.collectionView.reloadData()
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
            
            if let obj = arrAllItems[indexPath.row] as? ImageData {
                cell.btnDelete.alpha = (obj.isApproved == "0" && obj.userId == AppConstant.shared.loggedUser.userId) ?1.0:0
                cell.layoutIfNeeded()
                cell.imgSelected.sd_setImage(with: URL(string: obj.imageName), placeholderImage: UIImage(named: "placeholder_smaller"), options: .continueInBackground) { (image, error, types, url) in
                    if obj.objectLocation.imageWidth.count != 0 || obj.objectLocation.imageHeight.count != 0 {
                        cell.imgSelected.drawRectangle(frameSize: CGSize(width: cell.imgSelected.bounds.width, height: cell.imgSelected.bounds.height), imageWidth: CGFloat(obj.objectLocation.imageWidth.floatValue()), imageHight: CGFloat(obj.objectLocation.imageHeight.floatValue()), drawSize: CGRect(x: CGFloat(obj.objectLocation.left.floatValue()), y: CGFloat(obj.objectLocation.top.floatValue()), width: CGFloat(obj.objectLocation.width.floatValue()), height: CGFloat(obj.objectLocation.height.floatValue())))
                    }
                }
            } else if let implantObj = self.arrAllItems[indexPath.item] as? ImplantImage {
                cell.imgSelected.image = implantObj.selectedImage
                cell.layoutIfNeeded()
                cell.imgSelected.drawRectangle(frameSize: CGSize(width: cell.imgSelected.frame.width, height: cell.imgSelected.frame.height), imageWidth: CGFloat(implantObj.imageWidth.floatValue()), imageHight: CGFloat(implantObj.imageHeight.floatValue()), drawSize: CGRect(x: CGFloat(implantObj.labelOffsetX.floatValue()), y: CGFloat(implantObj.labelOffsetY.floatValue()), width: CGFloat(implantObj.labelWidth.floatValue()), height: CGFloat(implantObj.labelHeight.floatValue())))
                cell.btnDelete.indexPath = indexPath
                cell.btnDelete.alpha = 1.0
            }
            cell.btnDelete.indexPath = indexPath
            cell.btnDelete.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
      
        if let collectionCell = self.collectionView.cellForItem(at: indexPath) as? AddDetail1CollectionViewCell {
            let controller = getTopViewController()
            controller!.openGalleryList(indexpath: indexPath, imgNameArr: NSMutableArray(array: STATICDATA.arrImages), sourceView: collectionCell.imgSelected)
        }
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
