//
//  SubScriptionViewController.swift
//  Kethan
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SubScriptionViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnMonthly: CustomButton!
    @IBOutlet weak var btnAnnual: CustomButton!
    
    var isComeFromLogin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Nav Bar
        self.addNavBarWithTitle("Subscription Plans", withLeftButtonType: (self.isComeFromLogin == false) ?.buttonTypeBack:.buttonTypeNil, withRightButtonType: .buttonTypeNil)
        
        //CollectionView
        self.collectionView.register(UINib(nibName: IDENTIFIERS.SubScriptionCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: IDENTIFIERS.SubScriptionCollectionViewCell)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: getCalculated(246.0), height: self.collectionView.frame.size.height)
        layout.minimumLineSpacing = getCalculated(26.0)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: getCalculated(37.0), bottom: 0, right: getCalculated(26.5))
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Button Action
    @IBAction func annualActionClick(_ sender: Any) {
    }
    
    @IBAction func monthlyActionClick(_ sender: Any) {
    }
    
    @objc func planSelection(_ sender: UIButton) {
        if self.isComeFromLogin == true {
            self.navigateToHome(false, false)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    // MARK: - CollectionView Dalegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return STATICDATA.arrSubscription.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IDENTIFIERS.SubScriptionCollectionViewCell, for: indexPath) as? SubScriptionCollectionViewCell {
            print(cell.frame.size.height)
            let arr = STATICDATA.arrSubscription[indexPath.item]
            cell.imgBG.image = UIImage(named: arr["image"] ?? "")
            
            let attributedString = NSMutableAttributedString(string: arr["price"]!, attributes: [
                .font: UIFont(name: "HelveticaNeue-Bold", size: getCalculated(65.0))!,
                .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
            ])
            attributedString.addAttribute(.font, value: UIFont(name: "HelveticaNeue", size: getCalculated(45.0))!, range: NSRange(location: 0, length: 1))
            attributedString.addAttributes([.baselineOffset: 15], range: NSRange(location: 0, length: 1))
            
            cell.lblPrice.attributedText = attributedString
            cell.lblPlan.text = arr["plan"]?.uppercased()
            cell.lblValid.text = arr["valid"]
            
            cell.btnSubscribe.titleLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: getCalculated(17.0))
            cell.btnSubscribe.setTitleColor((arr["type"] == "year") ?APP_COLOR.color3:APP_COLOR.color2, for: .normal)
            cell.btnSubscribe.tag = indexPath.item
            cell.btnSubscribe.addTarget(self, action: #selector(planSelection(_:)), for: .touchUpInside)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getCalculated(246.0), height: self.collectionView.frame.size.height)
    }
    
    // MARK: - ScrollDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let page = (scrollView.contentOffset.x + (0.5 * width)) / width
        if NSInteger(page) == 0 {
            self.btnAnnual.setTitleColor(APP_COLOR.color5, for: .normal)
            self.btnMonthly.setTitleColor(APP_COLOR.color4, for: .normal)
        } else {
            self.btnAnnual.setTitleColor(APP_COLOR.color4, for: .normal)
            self.btnMonthly.setTitleColor(APP_COLOR.color5, for: .normal)
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
