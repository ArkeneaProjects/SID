//
//  SignUpUserGuideViewController.swift
//  Kethan
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SignUpUserGuideViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var btnSkip: CustomButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var isShowNavBar: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isShowNavBar == true {
            self.addNavBarWithTitle("User Guide", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
            self.btnSkip.alpha = 0
        }
        
        //CollectionView
        self.collectionView.register(UINib(nibName: IDENTIFIERS.GuideCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: IDENTIFIERS.GuideCollectionViewCell)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.size.width, height: getCalculated(360.0))
        layout.minimumLineSpacing = getCalculated(0.0)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //Page Control
        self.pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        let image = UIImage.outlinedEllipse(size: CGSize(width: 7.0, height: 7.0), color: .darkGray)
        self.pageControl.pageIndicatorTintColor = UIColor.init(patternImage: image!)
        self.pageControl.currentPageIndicatorTintColor = UIColor(hexString: "#0985E9")
        self.pageControl.numberOfPages = 4
        self.pageControl.currentPage = 0
        self.buttonColorChanged(false)
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func skipClickAction(_ sender: Any) {
        // self.navigateToHome(false, false)
        if let controller = self.instantiate(SubScriptionViewController.self, storyboard: STORYBOARD.signup) as? SubScriptionViewController {
            controller.isComeFromLogin = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func buttonColorChanged(_ isChange: Bool) {
        self.btnSkip.backgroundColor = (isChange == false) ?.clear:APP_COLOR.color2
        self.btnSkip.setTitle((isChange == false) ?"Skip":"Continue", for: .normal)
        self.btnSkip.setTitleColor((isChange == false) ?APP_COLOR.color2:.white, for: .normal)
        self.btnSkip.titleLabel?.font = (isChange == false) ?APP_FONT.regularFont(withSize: 14.0):APP_FONT.boldFont(withSize: 16.0)
    }
    
    // MARK: - CollectionView Dalegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return STATICDATA.arrUserGuide.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GuideCollectionViewCell", for: indexPath) as? GuideCollectionViewCell {
            print(cell.frame.size.height)
            let arr = STATICDATA.arrUserGuide[indexPath.item]
            cell.imgProfile.image = UIImage(named: arr["image"] ?? "")
            cell.lblTitle.text = arr["title"]
            cell.lblSubTitle.text = arr["subtitle"]
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: getCalculated(360.0))
    }
    
    // MARK: - ScrollDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let page = (scrollView.contentOffset.x + (0.5 * width)) / width
        self.pageControl.currentPage = NSInteger(page)
        self.buttonColorChanged((NSInteger(page) == 3) ?true:false)
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
