//
//  SerachListViewController.swift
//  Kethan
//
//  Created by Apple on 22/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SearchListViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   // @IBOutlet weak var searchVM: SearchVM!
    @IBOutlet weak var lblResultCount: CustomLabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var searchVM = SearchVM()
    var menufeacture = ""
    var brandname = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Search Results", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        
        self.collectionView.register(UINib(nibName: IDENTIFIERS.SearchListCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: IDENTIFIERS.SearchListCollectionViewCell)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.size.width/2, height: getCalculated(225.0))
        layout.minimumLineSpacing = getCalculated(10.0)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .vertical
        self.collectionView.collectionViewLayout = layout
       
        self.searchVM.rootController = self
        self.searchVM.getAllSearchResult(manufecture: self.menufeacture, brandname: self.brandname) { (error) in
           
            if error != "" {
                 self.lblResultCount.text = error
            } else {
                DispatchQueue.main.async {
                    if self.searchVM.arrSearchResult.count == 1 {
                        self.lblResultCount.text = "1 result match to your upload"
                    } else {
                        self.lblResultCount.text = "\(self.searchVM.arrSearchResult.count) results match to your upload"
                    }
                        self.collectionView.reloadData()
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
            cell.configuration(model: self.searchVM.arrSearchResult[indexPath.row])
          //  let arr = STATICDATA.arrSearch[indexPath.item]
//            cell.imgPhoto.image = UIImage(named: arr["image"]!)
//            cell.lblTitle.text = arr["title"]
//            cell.lblSubTitle.text = arr["subTitle"]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func configurationCell(cell: SearchListCollectionViewCell, indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        if let controller = self.instantiate(SearchDetailViewController.self, storyboard: STORYBOARD.main) as? SearchDetailViewController {
            controller.detailObj = self.searchVM.arrSearchResult[indexPath.row]
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2, height: getCalculated(225.0))
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
