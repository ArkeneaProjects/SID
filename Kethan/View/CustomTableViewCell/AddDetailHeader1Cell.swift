//
//  AddDetailHeader1Cell.swift
//  Kethan
//
//  Created by Apple on 26/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class AddDetailHeader1Cell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var constCollectionHeight: CustomConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnSeeAll: CustomButton!
    var isNewUpload: Bool = false
    
    var arrAllItems: NSMutableArray = NSMutableArray() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var cellSelectionCompletion:((_ index_Path: IndexPath) -> Void)?
    var deleteImageCompletion:((_ index_Path: IndexPath) -> Void)?
    var seeAllImageCompletion:(() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
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
        if self.deleteImageCompletion != nil {
            self.deleteImageCompletion!(sender.indexPath)
        }
    }
    
    @objc func seeAllImageCompletion(_ sender: CustomButton) {
        if self.seeAllImageCompletion != nil {
            self.seeAllImageCompletion!()
        }
    }
    
    // MARK: - CollectionView Dalegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAllItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddDetail1CollectionViewCell", for: indexPath) as? AddDetail1CollectionViewCell {
            cell.imgSelected.alpha = 1.0
            cell.lblAdd.alpha = 0
            cell.imgPlus.alpha = 0
            cell.btnDelete.alpha = 0
            cell.imgBorder.alpha = 0
            cell.btnDelete.indexPath = indexPath
            cell.btnDelete.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
            cell.imgSelected.clearDrowRectangle()

            if let obj = arrAllItems.object(at: indexPath.item) as? ImageData {
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
            } else {
                cell.imgSelected.image = nil
                cell.imgSelected.alpha = 0
                cell.lblAdd.alpha = 1.0
                cell.imgPlus.alpha = 1.0
                cell.btnDelete.alpha = 0
                cell.imgBorder.alpha = 1.0
                cell.imgBorder.image = UIImage(named: "lineImage")
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        if (self.arrAllItems[indexPath.item] as? NSArray) != nil {
            if self.cellSelectionCompletion != nil {
                self.cellSelectionCompletion!(indexPath)
            }
        } else {
            if let collectionCell = self.collectionView.cellForItem(at: indexPath) as? AddDetail1CollectionViewCell {
                let controller = getTopViewController()
                let arr: NSMutableArray = NSMutableArray()
                for item in self.arrAllItems {
                    if let objItemData = item as? ImageData {
                        arr.add(objItemData)
                    } else if let objRemovalData = item as? ImplantImage {
                        let imageData = ImageData()
                        let objLocation = ObjectLocation()
                        objLocation.top = objRemovalData.labelOffsetY
                        objLocation.left = objRemovalData.labelOffsetX
                        objLocation.width = objRemovalData.labelWidth
                        objLocation.height = objRemovalData.labelHeight
                        objLocation.imageWidth = objRemovalData.imageWidth
                        objLocation.imageHeight = objRemovalData.imageHeight
                        imageData.objectLocation = objLocation
                        imageData.image = objRemovalData.selectedImage
                        arr.add(imageData)
                    }
                }
                controller!.openGalleryList(indexpath: indexPath, imgNameArr: arr, sourceView: collectionCell.imgSelected)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getCalculated(92.0), height: getCalculated(92.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
           UIView.animate(withDuration: 0.5) {
               if let cell = collectionView.cellForItem(at: indexPath) as? AddDetail1CollectionViewCell {
                   cell.imgSelected.transform = .init(scaleX: 0.95, y: 0.95)
                   cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
               }
           }
       }

       func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
           UIView.animate(withDuration: 0.5) {
               if let cell = collectionView.cellForItem(at: indexPath) as? AddDetail1CollectionViewCell {
                   cell.imgSelected.transform = .identity
                   cell.contentView.backgroundColor = .clear
               }
           }
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
