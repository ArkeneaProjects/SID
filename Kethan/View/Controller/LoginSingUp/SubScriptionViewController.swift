//
//  SubScriptionViewController.swift
//  Kethan
//
//  Created by Apple on 03/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

class SubScriptionViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var btnMonthly: CustomButton!
    @IBOutlet weak var btnAnnual: CustomButton!
    
    var isComeFromLogin: Bool = false
    var subscriptionVmObj = SubscriptionVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Nav Bar
        self.addNavBarWithTitle("Subscription Plans", withLeftButtonType: (self.isComeFromLogin == false) ?.buttonTypeBack:.buttonTypeSkip, withRightButtonType: .buttonTypeRestore)
        
        //       self.addNavBarWithTitle("Subscription Plans", withLeftButtonType: (self.isComeFromLogin == true) ?.buttonTypeNil:.buttonTypeBack, withRightButtonType: (self.isComeFromLogin == false) ?.buttonTypeNil:.buttonTypeSkip)
        
        //CollectionView
        self.collectionView.register(UINib(nibName: IDENTIFIERS.SubScriptionCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: IDENTIFIERS.SubScriptionCollectionViewCell)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: getCalculated(260.0), height: self.collectionView.frame.size.height)
        layout.minimumLineSpacing = getCalculated(26.0)
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets.zero
        layout.scrollDirection = .horizontal
        self.collectionView.collectionViewLayout = layout
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: getCalculated(25.0), bottom: 0, right: getCalculated(20.5))
        
        self.subscriptionVmObj.rootController = self
        self.subscriptionVmObj.getPlanInfo(self)
    }
    
    // MARK: - Button Action
    override func leftButtonAction() {
        if self.isComeFromLogin == true {
            self.navigateToHome(false, false)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    override func rightButtonAction() {
        self.subscriptionVmObj.restoreSubscription()
        //        self.navigateToHome(false, false)
    }
    
    @IBAction func annualActionClick(_ sender: Any) {   }
    
    @IBAction func monthlyActionClick(_ sender: Any) {
        
    }
    
    @objc func planSelection(_ sender: CustomButton) {
        //        if self.isComeFromLogin == true {
        //            self.navigateToHome(false, false)
        //        } else {
        if sender.indexPath.item == 0 {
            self.subscriptionVmObj.selectedIndex = sender.indexPath.item
            self.subscriptionVmObj.subscribe()
        } else {
            if AppConstant.shared.loggedUser.creditPoint == "0" {
                self.subscriptionVmObj.creditedPoint = "0"
                self.subscriptionVmObj.creditedValue = "0"
                self.subscriptionVmObj.selectedIndex = 1
                self.subscriptionVmObj.checkForIdentifire()
            } else {
                let controller: CreditsViewController = self.instantiate(CreditsViewController.self, storyboard: STORYBOARD.main) as? CreditsViewController ?? CreditsViewController()
                controller.preparePopup(controller: self)
                controller.showPopup()
                controller.addCompletion = { creditValue, creditedPoints in
                    self.subscriptionVmObj.creditedPoint = creditedPoints
                    self.subscriptionVmObj.creditedValue = creditValue
                    self.subscriptionVmObj.selectedIndex = sender.indexPath.item
                    self.subscriptionVmObj.checkForIdentifire()
                }
            }
        }
        //}
    }
    
    @objc func termsSelection(_ sender: CustomButton) {
        if let controller = self.instantiate(TermsConditionViewController.self, storyboard: STORYBOARD.leftMenu) as? TermsConditionViewController {
            controller.isPage = 0
            controller.urlString = "https://www.google.com/"
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc func privacySelection(_ sender: CustomButton) {
        if let controller = self.instantiate(TermsConditionViewController.self, storyboard: STORYBOARD.leftMenu) as? TermsConditionViewController {
            controller.isPage = 1
            controller.urlString = "https://www.google.com/"
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - CollectionView Dalegate and DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return STATICDATA.arrSubscription.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IDENTIFIERS.SubScriptionCollectionViewCell, for: indexPath) as? SubScriptionCollectionViewCell {
//            print(cell.frame.size.height)
            let arr = STATICDATA.arrSubscription[indexPath.item]
            cell.imgBG.image = UIImage(named: arr["image"] ?? "")
            
            cell.lblPlan.text = arr["plan"]?.uppercased()
            cell.lblValid.text = arr["valid"]
            
            cell.btnSubscribe.titleLabel?.font = APP_FONT.mediumFont(withSize: 17.0)
            cell.btnSubscribe.setTitleColor((arr["type"] == "year") ?APP_COLOR.color3:APP_COLOR.color2, for: .normal)
            cell.btnSubscribe.indexPath = indexPath
            cell.btnSubscribe.addTarget(self, action: #selector(planSelection(_:)), for: .touchUpInside)
            cell.btnTerms.addTarget(self, action: #selector(termsSelection(_:)), for: .touchUpInside)
            cell.btnPrivacy.addTarget(self, action: #selector(privacySelection(_:)), for: .touchUpInside)
            print(AppConstant.shared.loggedUser.subscriptionStatus)
            if AppConstant.shared.loggedUser.subscriptionType == "Monthly" && AppConstant.shared.loggedUser.subscriptionStatus == "1" && indexPath.item == 0 {
                cell.imgActive.isHidden = false
            } else if AppConstant.shared.loggedUser.subscriptionType == "Yearly" && AppConstant.shared.loggedUser.subscriptionStatus == "1" && indexPath.item == 1 {
                cell.imgActive.isHidden = false
            } else {
                cell.imgActive.isHidden = true
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: getCalculated(260.0), height: self.collectionView.frame.size.height)
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

// MARK: - User facing alerts
extension UIViewController {
    
    func alertWithTitle(_ title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        return alert
    }
    
    func showAlert(_ alert: UIAlertController) {
        guard self.presentedViewController != nil else {
            self.present(alert, animated: true, completion: nil)
            return
        }
    }
    
    func alertForProductRetrievalInfo(_ result: RetrieveResults) -> UIAlertController {
        if let product = result.retrievedProducts.first {
            let priceString = product.localizedPrice!
            return alertWithTitle(product.localizedTitle, message: "\(product.localizedDescription) - \(priceString)")
        } else if let invalidProductId = result.invalidProductIDs.first {
            return alertWithTitle("Could not retrieve product info", message: "Invalid product identifier: \(invalidProductId)")
        } else {
            let errorString = result.error?.localizedDescription ?? "Unknown error. Please contact support"
            return alertWithTitle("Could not retrieve product info", message: errorString)
        }
    }
    
    func alertForPurchaseResult(_ result: PurchaseResult) -> UIAlertController? {
        switch result {
        case .success(let purchase):
            print("Purchase Success: \(purchase.productId)")
            return alertWithTitle("Thank You", message: "Purchase completed")
        case .error(let error):
            //ProgressManager.showError(withStatus: error.localizedDescription, on: self.view)
            print("Purchase Failed: \(error)")
            switch error.code {
            case .unknown:
                return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .clientInvalid: // client is not allowed to issue the request, etc.
                return alertWithTitle("Purchase failed", message: "Not allowed to make the payment")
            case .paymentCancelled: // user cancelled the request, etc.
                return nil
            case .paymentInvalid: // purchase identifier was invalid, etc.
                return alertWithTitle("Purchase failed", message: "The purchase identifier was invalid")
            case .paymentNotAllowed: // this device is not allowed to make the payment
                return alertWithTitle("Purchase failed", message: "The device is not allowed to make the payment")
            case .storeProductNotAvailable: // Product is not available in the current storefront
                return alertWithTitle("Purchase failed", message: "The product is not available in the current storefront")
            case .cloudServicePermissionDenied: // user has not allowed access to cloud service information
                return alertWithTitle("Purchase failed", message: "Access to cloud service information is not allowed")
            case .cloudServiceNetworkConnectionFailed: // the device could not connect to the nework
                return alertWithTitle("Purchase failed", message: "Could not connect to the network")
            case .cloudServiceRevoked: // user has revoked permission to use this cloud service
                return alertWithTitle("Purchase failed", message: "Cloud service was revoked")
            case .privacyAcknowledgementRequired:
                return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .unauthorizedRequestData:
                return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .invalidOfferIdentifier:
                return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .invalidSignature:
                return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .missingOfferParams:
                return alertWithTitle("Purchase failed", message: error.localizedDescription)
            case .invalidOfferPrice:
                return alertWithTitle("Purchase failed", message: error.localizedDescription)
            @unknown default:
                return alertWithTitle("Purchase failed", message: error.localizedDescription)
            }
        }
    }
    
    func alertForRestorePurchases(_ results: RestoreResults) -> UIAlertController {
        ProgressManager.dismiss()
        if results.restoreFailedPurchases.count > 0 {
            print("Restore Failed: \(results.restoreFailedPurchases)")
            return alertWithTitle("Restore failed", message: "Unknown error. Please contact support")
        } else if results.restoredPurchases.count > 0 {
            print("Restore Success: \(results.restoredPurchases)")
            return alertWithTitle("Purchases Restored", message: "All purchases have been restored")
        } else {
            print("Nothing to Restore")
            return alertWithTitle("Nothing to restore", message: "No previous purchases were found")
        }
    }
    
    func alertForVerifyReceipt(_ result: VerifyReceiptResult) -> UIAlertController {
        switch result {
        case .success(let receipt):
            print("Verify receipt Success: \(receipt)")
            return alertWithTitle("Receipt verified", message: "Receipt verified remotely")
        case .error(let error):
            print("Verify receipt Failed: \(error)")
            switch error {
            case .noReceiptData:
                return alertWithTitle("Receipt verification", message: "No receipt data. Try again.")
            case .networkError(let error):
                return alertWithTitle("Receipt verification", message: "Network error while verifying receipt: \(error)")
            default:
                return alertWithTitle("Receipt verification", message: "Receipt verification failed: \(error)")
            }
        }
    }
    
    func alertForVerifySubscription(_ result: VerifySubscriptionResult) -> UIAlertController {
        switch result {
        case .purchased(let expiryDate):
            print("Product is valid until \(expiryDate)")
            return alertWithTitle("Product is purchased", message: "Product is valid until \(expiryDate.expiryDate)")
        case .expired(let expiryDate):
            print("Product is expired since \(expiryDate)")
            return alertWithTitle("Product expired", message: "Product is expired since \(expiryDate.expiryDate)")
        case .notPurchased:
            print("This product has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
    
    func alertForVerifyPurchase(_ result: VerifyPurchaseResult) -> UIAlertController {
        switch result {
        case .purchased:
            print("Product is purchased")
            return alertWithTitle("Product is purchased", message: "Product will not expire")
        case .notPurchased:
            print("This product has never been purchased")
            return alertWithTitle("Not purchased", message: "This product has never been purchased")
        }
    }
}
