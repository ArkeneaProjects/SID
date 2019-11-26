//
//  SerachListViewController.swift
//  Kethan
//
//  Created by Apple on 22/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SearchListViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @objc func viewClickAction(_ sender: CustomButton) {
        if let controller = self.instantiate(SearchDetailViewController.self, storyboard: STORYBOARD.main) as? SearchDetailViewController {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - CollectionView Dalegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return STATICDATA.arrSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IDENTIFIERS.SearchListCollectionViewCell, for: indexPath) as? SearchListCollectionViewCell {
            let arr = STATICDATA.arrSearch[indexPath.item]
            cell.imgPhoto.image = UIImage(named: arr["image"]!)
            cell.lblMatch.text = arr["percent"]
            cell.lblTitle.text = arr["title"]
            cell.lblSubTitle.text = arr["subTitle"]
            cell.btnView.indexPath = indexPath
            cell.btnView.addTarget(self, action: #selector(self.viewClickAction(_:)), for: .touchUpInside)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
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
