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
    
    var planArray: NSMutableArray = NSMutableArray()
    let productIdArr: NSMutableArray = NSMutableArray()
    var ProductArr = [SKProduct]()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Nav Bar
        self.addNavBarWithTitle("Subscription Plans", withLeftButtonType: (self.isComeFromLogin == false) ?.buttonTypeBack:.buttonTypeNil, withRightButtonType: (self.isComeFromLogin == true) ?.buttonTypeSkip:.buttonTypeNil)
        
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
        
        for product in STATICDATA.arrSubscription {
            let iapProduct = IAPProduct(dictionary: product as NSDictionary) as IAPProduct
            planArray.add(iapProduct)
        }
        
        productIdArr.add(SubscriptionPlans.Monitor50Patients)
//        productIdArr.add(SubscriptionPlans.Monitor125Patients)
        
        for p in productIdArr {
            retriveProductInfo(pName: p as! String)
            
            // self.verifyPurchase(pName: p as! String)
        }
    }
    
    func retriveProductInfo(pName: String) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([/*appBundleId + "." + */pName]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if result.retrievedProducts.count > 0 {
                self.ProductArr.append(result.retrievedProducts.first!)
            }
            // set info in labels
            if self.ProductArr.count > 0 {
                for p in self.ProductArr {
                    let currencyCode: String = CFLocaleGetValue(p.priceLocale as CFLocale, CFLocaleKey.currencyCode)! as! String
                    let locale: NSLocale? = NSLocale(localeIdentifier: currencyCode)
                    let currencySymbol: String = (locale?.displayName(forKey: .currencySymbol, value: currencyCode))!
                    
                    let currentPrice = currencySymbol + " " + String(describing: p.price)
                    
                    (self.planArray.object(at: 0) as! IAPProduct).plan = currentPrice
                    
                    let attributedString = NSMutableAttributedString(string: (self.planArray.object(at: 0) as! IAPProduct).plan, attributes: [
                        .font: APP_FONT.boldFont(withSize: 45.0),
                        .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
                    ])
                    attributedString.addAttribute(.font, value: APP_FONT.regularFont(withSize: 30.0), range: NSRange(location: 0, length: 1))
                    attributedString.addAttributes([.baselineOffset: 15], range: NSRange(location: 0, length: 1))
                    
                    if let cell: SubScriptionCollectionViewCell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? SubScriptionCollectionViewCell {
                        cell.lblPrice.attributedText = attributedString
                    }
                    
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                ProgressManager.dismiss()
            }
            
            // self.showAlert(self.alertForProductRetrievalInfo(result))
        }
        
    }
    // MARK: - Button Action
    override func rightButtonAction() {
        self.navigateToHome(false, false)
    }
    
    @IBAction func annualActionClick(_ sender: Any) {
        self.selectedIndex = 1
    }
    
    @IBAction func monthlyActionClick(_ sender: Any) {
       
    }
    
    func purchase(pName: String, completion: @escaping ((_ result:PurchaseResult, _ pName:String) -> Void)) {
           NetworkActivityIndicatorManager.networkOperationStarted()
           SwiftyStoreKit.purchaseProduct (pName, atomically: true) { result in
               NetworkActivityIndicatorManager.networkOperationFinished()
               
               if case .success(let purchase) = result {
                   // Deliver content from server, then:
                   if purchase.needsFinishTransaction {
                       SwiftyStoreKit.finishTransaction(purchase.transaction)
                   }
                   
                   //self.verifyPurchase(pName: pName)
                   
               }
               completion(result, pName)
           }
       }
       
       func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
           
           let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: "70f21ec0aea3416d98a15f3d0b7c9418")
           SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
       }
       
       //verify current product status from itunes
       func verifyPurchase(pName: String, tag:Int) {
           ProgressManager.show(withStatus: "Verifying purchase..", on: self.view)
           
           NetworkActivityIndicatorManager.networkOperationStarted()
           verifyReceipt { result in
               NetworkActivityIndicatorManager.networkOperationFinished()
               
               switch result {
               case .success(let receipt):
                   
                   //  let productId = self.appBundleId + "." + purchase.rawValue
                   let productId = pName
                   
                   let purchaseResult = SwiftyStoreKit.verifySubscription(
                       ofType: .autoRenewable,
                       productId: productId,
                       inReceipt: receipt,
                       validUntil: Date()
                   )
                   //  print(receipt)
                   // print(purchaseResult)
                   
                   
                   let receiptData: Data = try! JSONSerialization.data(withJSONObject:receipt,options: JSONSerialization.WritingOptions.prettyPrinted)
                   let receiptDataBase64 = receiptData.base64EncodedString()
     
                   let str = ((self.planArray[self.selectedIndex] as? IAPProduct)!.plan)
                   let PatientCountArr: [String] = str.components(separatedBy: " ")
                   let data: IAPProduct = self.planArray.object(at: tag) as! IAPProduct

//                   self.updatePurchaseStatusOnServer(price: (self.planArray[self.selectedIndexPath.row] as! IAPProduct).planAmount, planName: (self.planArray[self.selectedIndexPath.row] as! IAPProduct).patients, planStatus: "", allowedPatientCount: PatientCountArr[1], receipt: receiptDataBase64, plan_title: data.planTitle, perpatient_cost:data.detailPlan )
                   
                   self.setStatus(result: purchaseResult, name: pName)
                   //  self.showAlert(self.alertForVerifySubscription(purchaseResult))
                   
               case .error:
                   ProgressManager.dismiss()
                   self.present(self.alertForVerifyReceipt(result), animated: true, completion: nil)
               }
           }
           
       }
    
    func setStatus(result: VerifySubscriptionResult, name: String) {
        if name == SubscriptionPlans.Monitor50Patients {
            switch result {
            case.purchased(let expiryDate):
                print("Monitor50Patients is valid until \(expiryDate)")
            case.expired(let expiryDate):
                print("Monitor50Patients is expired since \(expiryDate)")
            case .notPurchased:
                print("Monitor50Patients has never been purchased")
            }
        }
    }
    @objc func planSelection(_ sender: UIButton) {
        if self.isComeFromLogin == true {
            self.navigateToHome(false, false)
        } else {
           
            self.selectedIndex = 0
                   self.showAlert(title: "Confirm?", message: "Are you sure you want to purchase this?", yesTitle: "Yes", noTitle: "No", yesCompletion: {
                       ProgressManager.show(withStatus: "Subscribing..", on: self.view)
                       self.purchase(pName: self.productIdArr[0] as! String, completion: { result, pName in
                           if let alert = self.alertForPurchaseResult(result) {
                               self.showAlert(alert)
                               
                               switch result {
                               case .success( _):
                                   self.verifyPurchase(pName: pName, tag: 0)
                                   
                               case .error:
                                   ProgressManager.dismiss()
                                   break
                               }
                           }
                       })
                   }, noCompletion: nil)
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
            
//            let attributedString = NSMutableAttributedString(string: arr["price"]!, attributes: [
//                .font: APP_FONT.boldFont(withSize: 45.0),
//                .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
//            ])
//            attributedString.addAttribute(.font, value: APP_FONT.regularFont(withSize: 30.0), range: NSRange(location: 0, length: 1))
//            attributedString.addAttributes([.baselineOffset: 15], range: NSRange(location: 0, length: 1))
//
//            cell.lblPrice.attributedText = attributedString
            cell.lblPlan.text = arr["plan"]?.uppercased()
            cell.lblValid.text = arr["valid"]
            
            cell.btnSubscribe.titleLabel?.font = APP_FONT.mediumFont(withSize: 17.0)
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
           return alertWithTitle("Product is purchased", message: "Product is valid until \(expiryDate)")
       case .expired(let expiryDate):
           print("Product is expired since \(expiryDate)")
           return alertWithTitle("Product expired", message: "Product is expired since \(expiryDate)")
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
