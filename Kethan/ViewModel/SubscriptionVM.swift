//
//  SubscriptionVM.swift
//  Kethan
//
//  Created by Ashwini on 14/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

class SubscriptionVM: NSObject {
    
    var planArray: NSMutableArray = NSMutableArray()
    let productIdArr: NSMutableArray = NSMutableArray()
    var ProductArr = [SKProduct]()
    var selectedIndex = 0
    var rootController: BaseViewController?
    
    func getPlanInfo(_ controller: BaseViewController) {
        self.rootController = controller
        for product in STATICDATA.arrSubscription {
            let iapProduct = IAPProduct(dictionary: product as NSDictionary) as IAPProduct
            planArray.add(iapProduct)
        }
        
        productIdArr.add(SubscriptionPlans.Monitor50Patients)
        productIdArr.add(SubscriptionPlans.Monitor125Patients)
        
        for p in productIdArr {
            retriveProductInfo(pName: p as! String)
            // self.verifyPurchase(pName: p as! String)
        }
    }
    
    func retriveProductInfo(pName: String) {
        ProgressManager.show(withStatus: "", on: self.rootController?.view)
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.retrieveProductsInfo([/*appBundleId + "." + */pName]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if result.retrievedProducts.count > 0 {
                self.ProductArr.append(result.retrievedProducts.first!)
            }
            // set info in labels
            if self.ProductArr.count > 0 {
                for i in 0 ..< self.ProductArr.count {
                    if let currencyCode: String = CFLocaleGetValue(self.ProductArr[i].priceLocale as CFLocale, CFLocaleKey.currencyCode) as? String {
                        let locale: NSLocale? = NSLocale(localeIdentifier: currencyCode)
                        let currencySymbol: String = (locale?.displayName(forKey: .currencySymbol, value: currencyCode))!
                        
                        let currentPrice = currencySymbol + String(describing: self.ProductArr[i].price)
                        
                        (self.planArray.object(at: i) as? IAPProduct)?.plan = currentPrice
                        
                        let attributedString = NSMutableAttributedString(string: (self.planArray.object(at: i) as? IAPProduct)!.plan, attributes: [
                            .font: APP_FONT.boldFont(withSize: 45.0),
                            .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
                        ])
                        attributedString.addAttribute(.font, value: APP_FONT.regularFont(withSize: 30.0), range: NSRange(location: 0, length: 1))
                        attributedString.addAttributes([.baselineOffset: 15], range: NSRange(location: 0, length: 1))
                        
                        if let cell: SubScriptionCollectionViewCell = (self.rootController as? SubScriptionViewController)?.collectionView.cellForItem(at: IndexPath(item: i, section: 0)) as? SubScriptionCollectionViewCell {
                            cell.lblPrice.attributedText = attributedString
                        }
                    }
                    
                }
                
                DispatchQueue.main.async {
                    if let controller: SubScriptionViewController = self.rootController as? SubScriptionViewController {
                        controller.collectionView.reloadData()
                    }
                }
                ProgressManager.dismiss()
            }
            
            // self.showAlert(self.alertForProductRetrievalInfo(result))
        }
        
    }
    
    func subscribe() {
        self.rootController?.showAlert(title: "Confirm?", message: "Are you sure you want to purchase this?", yesTitle: "Yes", noTitle: "No", yesCompletion: {
            ProgressManager.show(withStatus: "Subscribing..", on: self.rootController?.view)
            self.purchase(pName: self.productIdArr[self.selectedIndex] as! String, completion: { result, pName in
                if let alert = self.rootController?.alertForPurchaseResult(result as PurchaseResult) {
                    self.rootController?.showAlert(alert)
                    switch result {
                    case .success( _):
                        self.verifyPurchase(pName: pName, tag: self.selectedIndex)
                    case .error:
                        ProgressManager.dismiss()
                    }
                }
            })
        }, noCompletion: nil)
    }
    
    func purchase(pName: String, completion: @escaping ((_ result: PurchaseResult, _ pName: String) -> Void)) {
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
    
    func restoreSubscription() {
        ProgressManager.show(withStatus: "Restoring your subscription..", on: self.rootController?.view)
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            for purchase in results.restoredPurchases where purchase.needsFinishTransaction {
                SwiftyStoreKit.finishTransaction(purchase.transaction)
            }
            self.rootController?.present((self.rootController?.alertForRestorePurchases(results))!, animated: true, completion: nil)
        }
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: "70f21ec0aea3416d98a15f3d0b7c9418")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    //verify current product status from itunes
    func verifyPurchase(pName: String, tag: Int) {
        ProgressManager.show(withStatus: "Verifying purchase..", on: self.rootController?.view)
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                ProgressManager.dismiss()
                //  let productId = self.appBundleId + "." + purchase.rawValue
                let productId = pName
                /* if let latestReceipt: NSArray = (receipt as NSDictionary).object(forKey: "latest_receipt_info") as? NSArray {
                 let expiryDateValue = latestReceipt.object(at: latestReceipt.count-1)
                 let expiryDate = getValueFromDictionary(dictionary: expiryDateValue as! NSDictionary, forKey: "expires_date")
                 let convertedDate = expiryDate.convertStringToDate(actualFormat: DATEFORMATTERS.YYYYMMDD, expectedFormat: DATEFORMATTERS.YYYYMMDD)
                 }*/
                
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: tag == 0 ? .autoRenewable : .nonRenewing(validDuration: 3600 * 24 * 365),
                    productId: productId,
                    inReceipt: receipt,
                    validUntil: Date()
                )
                //  print(receipt)
                // print(purchaseResult)
                
                //                let receiptData: Data = try! JSONSerialization.data(withJSONObject: receipt, options: JSONSerialization.WritingOptions.prettyPrinted)
                //                let receiptDataBase64 = receiptData.base64EncodedString()
                
                /* let str = ((self.planArray[self.selectedIndex] as? IAPProduct)!.plan)
                 let PatientCountArr: [String] = str.components(separatedBy: " ")
                 if let data: IAPProduct = self.planArray.object(at: tag) as? IAPProduct {
                 print(PatientCountArr, data)
                 }
                 
                 self.updatePurchaseStatusOnServer(price: (self.planArray[self.selectedIndexPath.row] as! IAPProduct).planAmount, planName: (self.planArray[self.selectedIndexPath.row] as! IAPProduct).patients, planStatus: "", allowedPatientCount: PatientCountArr[1], receipt: receiptDataBase64, plan_title: data.planTitle, perpatient_cost:data.detailPlan )
                 */
                
                self.setStatus(result: purchaseResult, name: pName)
                self.rootController?.showAlert((self.rootController?.alertForVerifySubscription(purchaseResult))!)
                
            case .error:
                ProgressManager.dismiss()
                self.rootController?.present((self.rootController?.alertForVerifyReceipt(result))!, animated: true, completion: nil)
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
}
