//
//  SerachListViewController.swift
//  Kethan
//
//  Created by Apple on 22/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import SkeletonView

class SearchListViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource {
    // @IBOutlet weak var searchVM: SearchVM!
    
    @IBOutlet weak var lblResultCount: CustomLabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewError: UIView!

    var isCalledFrom = 0 //0 coming search by text screen, 1 comming search by Image screen and 2 coming from upload screen
    
    var searchVM = SearchVM()
    
    var menufeacture = ""
    var brandname = ""
    var searchImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.addNavBarWithTitle("Search Results", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeAdd)
        
        self.collectionView.register(UINib(nibName: IDENTIFIERS.SearchListCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: IDENTIFIERS.SearchListCollectionViewCell)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.size.width/2, height: getCalculated(225.0))
        layout.minimumLineSpacing = getCalculated(10.0)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = layout
        
        self.apiCall()
        
    }
    
    override func rightButtonAction() {
        if self.isCalledFrom == 0 {
            if self.brandname.count != 0 && self.menufeacture.count != 0 {
                if searchVM.arrSearchResult.count == 0 {
                    self.addDetailCalling()
                } else {
                    AppConstant.shared.manufactureName = self.menufeacture
                    AppConstant.shared.brandName = self.brandname
                    self.navigationController?.popToRootViewController(animated: false)
                    AppDelegate.delegate()?.tabBarController.selectedIndex = 2
                }
                
            } else {
                AppConstant.shared.manufactureName = self.menufeacture
                AppConstant.shared.brandName = self.brandname
                self.navigationController?.popToRootViewController(animated: false)
                AppDelegate.delegate()?.tabBarController.selectedIndex = 2
            }
        } else if self.isCalledFrom == 1 {
            AppConstant.shared.manufactureName = self.menufeacture
            AppConstant.shared.brandName = self.brandname
            self.navigationController?.popToRootViewController(animated: false)
            AppDelegate.delegate()?.tabBarController.selectedIndex = 2
        } else {
            self.addDetailCalling()
        }
    }
    
    func addDetailCalling() {
        let implantObj = SearchResult()
        implantObj.objectName = self.brandname
        implantObj.implantManufacture = self.menufeacture
        
        if let controller = self.instantiate(AddDetailsViewController.self, storyboard: STORYBOARD.main) as? AddDetailsViewController {
            controller.implantObj = implantObj
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    func gradientSkeltonShowHide( isShow: Bool) {
        DispatchQueue.main.async {
            if isShow {
                self.viewContainer.showAnimatedGradientSkeleton()
                self.viewContainer.startSkeletonAnimation()
            } else {
                self.viewContainer.stopSkeletonAnimation()
                self.viewContainer.hideSkeleton()
            }
        }
    }
    
    // MARK: - Action
    func apiCall() {
        self.searchVM.rootController = self
        
        self.gradientSkeltonShowHide(isShow: true)
        self.viewError.alpha = 0
        if self.isCalledFrom == 1 {
           
            let imageDict  = saveImageInDocumentDict(image: self.searchImage!, imageName: "photo", key: "implantPicture")
            self.searchVM.getSearchByImage(itemArray: [imageDict]) { (error) in
                self.gradientSkeltonShowHide(isShow: false)
                if self.searchVM.arrSearchResult.count == 0 {
                    self.lblResultCount.text = error
                    self.viewError.alpha = 1.0
                    ProgressManager.showError(withStatus: error, on: self.view) {
                    }
                   
                } else {
                    DispatchQueue.main.async {
                        if self.searchVM.arrSearchResult.count == 1 {
                            self.lblResultCount.text = "1 result match to your search by image"
                        } else {
                            self.lblResultCount.text = "\(self.searchVM.arrSearchResult.count) results match to your search by images"
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
        } else {
            self.searchVM.getAllSearchByText(manufecture: self.menufeacture, brandname: self.brandname) { (error) in
                self.gradientSkeltonShowHide(isShow: false)
                if self.searchVM.arrSearchResult.count == 0 {
                    self.lblResultCount.text = error
                    self.viewError.alpha = 1.0
                    ProgressManager.showError(withStatus: error, on: self.view) {
                            
                    }
                } else {
                    DispatchQueue.main.async {
                       
                        if self.searchVM.arrSearchResult.count == 1 {
                            self.lblResultCount.text = "1 result match to your search field"
                        } else {
                            self.lblResultCount.text = "\(self.searchVM.arrSearchResult.count) results match to your search field"
                        }
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - CollectionView Dalegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.searchVM.numberofItems(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IDENTIFIERS.SearchListCollectionViewCell, for: indexPath) as? SearchListCollectionViewCell {

            cell.configuration(obj: self.searchVM.arrSearchResult[indexPath.row])
            
            return cell
        }
        return UICollectionViewCell()
    }
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let controller = self.instantiate(SearchDetailViewController.self, storyboard: STORYBOARD.main) as? SearchDetailViewController {
                controller.detailObj = self.searchVM.arrSearchResult[indexPath.row].copy() as? SearchResult ?? SearchResult()
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: getCalculated(213.0))
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? SearchListCollectionViewCell {
                cell.imgPhoto.transform = .init(scaleX: 0.95, y: 0.95)
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? SearchListCollectionViewCell {
                cell.imgPhoto.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
    
    private func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SearchListCollectionViewCell {
            animateCell(cell: cell)
        }
        
    }

    func animateCell(cell: SearchListCollectionViewCell) {
        let animation = CABasicAnimation(keyPath: "cornerRadius")
        animation.fromValue = 200
        cell.layer.cornerRadius = 0
        animation.toValue = 0
        animation.duration = 1
        cell.layer.add(animation, forKey: animation.keyPath)
    }

    func animateCellAtIndexPath(indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath as IndexPath) else { return }
        animateCell(cell: cell as? SearchListCollectionViewCell ?? SearchListCollectionViewCell())
    }

    private func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        animateCellAtIndexPath(indexPath: indexPath)
    }
    
    // MARK: - SkeltonView Delegate
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return IDENTIFIERS.SearchListCollectionViewCell
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
