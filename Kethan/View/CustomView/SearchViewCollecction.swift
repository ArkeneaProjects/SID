//
//  SearchViewCollecction.swift
//  Kethan
//
//  Created by Apple on 25/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SearchViewCollecction: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var lblImageCount: CustomLabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewController: BaseViewController?
    
    var arrAllItems: NSMutableArray = NSMutableArray() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    func setupWith(superView: UIView, controller: BaseViewController, isview: Bool) {
        
        viewController = controller
        superView.addSubview(self)
        
        //ColeationView
        self.collectionView.register(UINib(nibName: IDENTIFIERS.CustomCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: IDENTIFIERS.CustomCollectionViewCell)
        
        //SetUp SubView
        self.translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: superView, attribute: .centerX, multiplier: 1.0, constant: 0))
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1.0, constant: 0))
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: superView, attribute: .width, multiplier: 1.0, constant: 0))
        superView.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: superView, attribute: .height, multiplier: 1.0, constant: 0))
        superView.layoutIfNeeded()
        
        //CollectionView
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: getCalculated(320.0), height: getCalculated(295.0))
        layout.minimumLineSpacing = getCalculated(0.0)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
//        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
    }
    
    // MARK: - CollectionView Dalegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrAllItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as? CustomCollectionViewCell {
            print("cell==\(cell.frame.size.width)")
            if let obj = arrAllItems.object(at: indexPath.row) as? ImageData {
                cell.layoutIfNeeded()
                cell.imgPhoto.setImageWithPlaceHolderImage(obj.imageName, true, true, PLACEHOLDERS.large) {
                    if obj.objectLocation.imageWidth.count != 0 || obj.objectLocation.imageHeight.count != 0 {
                        cell.imgPhoto.drawRectangle(frameSize: CGSize(width: cell.imgPhoto.bounds.width, height: cell.imgPhoto.bounds.height), imageWidth: CGFloat(obj.objectLocation.imageWidth.floatValue()), imageHight: CGFloat(obj.objectLocation.imageHeight.floatValue()), drawSize: CGRect(x: CGFloat(obj.objectLocation.left.floatValue()), y: CGFloat(obj.objectLocation.top.floatValue()), width: CGFloat(obj.objectLocation.width.floatValue()), height: CGFloat(obj.objectLocation.height.floatValue())))
                    }
                }
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        if let collectionCell = self.collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell {
            
            self.viewController?.openGalleryList(indexpath: indexPath, imgNameArr: self.arrAllItems, sourceView: collectionCell.imgPhoto)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getCalculated(320.0), height: getCalculated(405.0))
    }
    
    // MARK: - ScrollDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        print(scrollView.contentOffset.x)
        let page = (scrollView.contentOffset.x + (0.5 * width)) / width
        self.lblImageCount.text = "\(NSInteger(page) + 1)/\(self.arrAllItems.count)"
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
