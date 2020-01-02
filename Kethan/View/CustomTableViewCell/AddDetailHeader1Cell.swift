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
            cell.lblAdd.alpha = 0
            cell.imgPlus.alpha = 0
            cell.btnDelete.alpha = 1.0
            
            if self.arrAllItems[indexPath.item] as? String ?? "" == "lineImage" {
                cell.lblAdd.alpha = 1.0
                cell.imgPlus.alpha = 1.0
                cell.btnDelete.alpha = 0
                cell.imgSelected.image = UIImage(named: self.arrAllItems[indexPath.item] as? String ?? "")
                
            } else {
                cell.imgSelected.image = UIImage(named: self.arrAllItems[indexPath.item] as? String ?? "")
                cell.btnDelete.indexPath = indexPath
                cell.btnDelete.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        if self.arrAllItems[indexPath.item] as? String ?? "" == "lineImage" {
            if self.cellSelectionCompletion != nil {
                self.cellSelectionCompletion!(indexPath)
            }
        } else {
            if let collectionCell = self.collectionView.cellForItem(at: indexPath) as? AddDetail1CollectionViewCell {
                let controller = getTopViewController()
                controller!.openGalleryList(indexpath: indexPath, imgNameArr: NSMutableArray(array: STATICDATA.arrImages), sourceView: collectionCell.imgSelected)
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
