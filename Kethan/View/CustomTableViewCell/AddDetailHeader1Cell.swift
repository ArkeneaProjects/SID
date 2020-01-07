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
            if (arrAllItems.lastObject as? ImageData) != nil || arrAllItems.count == 0 {
                arrAllItems.add(["lineImage"])
            } else {
                if arrAllItems.count > 1 {
                    let totalCount = arrAllItems.count
                    arrAllItems.removeObject(at: totalCount - 2)
                }
            }
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
            cell.lblAdd.alpha = 0
            cell.imgPlus.alpha = 0
            cell.btnDelete.alpha = 0
            cell.imgSelected.clearDrowRectangle()
            
            if let obj = arrAllItems.object(at: indexPath.row) as? ImageData {
                
                cell.imgSelected.sd_setImage(with: URL(string: obj.imageName), placeholderImage: nil, options: .continueInBackground) { (image, error, types, url) in
                    cell.imgSelected.drawRectangle(frameSize: CGSize(width: getCalculated(cell.imgSelected.bounds.width), height: getCalculated(cell.imgSelected.bounds.height)), imageWidth: image?.size.width ?? 0.0, imageHight: image?.size.height ?? 0.0, drawSize: CGRect(x: CGFloat(obj.objectLocation.left.floatValue()), y: CGFloat(obj.objectLocation.top.floatValue()), width: CGFloat(obj.objectLocation.width.floatValue()), height: CGFloat(obj.objectLocation.height.floatValue())))
                }
            } else if let implantObj = self.arrAllItems[indexPath.item] as? ImplantImage {
                cell.imgSelected.image = implantObj.selectedImage
                cell.imgSelected.drawRectangle(frameSize: CGSize(width: cell.imgSelected.frame.width, height: cell.imgSelected.frame.height), imageWidth: CGFloat(implantObj.imageWidth.floatValue()), imageHight: CGFloat(implantObj.imageHeight.floatValue()), drawSize: CGRect(x: CGFloat(implantObj.labelOffsetX.floatValue()), y: CGFloat(implantObj.labelOffsetY.floatValue()), width: CGFloat(implantObj.labelWidth.floatValue()), height: CGFloat(implantObj.labelHeight.floatValue())))
                cell.btnDelete.indexPath = indexPath
                cell.btnDelete.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
                cell.btnDelete.alpha = 1.0
            } else {
                cell.lblAdd.alpha = 1.0
                cell.imgPlus.alpha = 1.0
                cell.btnDelete.alpha = 0
                cell.imgSelected.image = UIImage(named: "lineImage")
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
                        objLocation.actualImageWidth = objRemovalData.imageWidth
                        objLocation.actualImageHeight = objRemovalData.imageHeight
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
