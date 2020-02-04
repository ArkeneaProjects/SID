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
    var creditedPoint = ""
    var creditedValue = ""
    
    func getPlanInfo(_ controller: BaseViewController) {
        self.rootController = controller
        
        //used for display purpose(only 2)
        planArray.add(SubscriptionPlans.Monthly)
        planArray.add(SubscriptionPlans.AnnuallyFull)
        for p in planArray {
            if let productId: String = p as? String {
                retriveProductInfo(pName: productId)
            }
        }
        
        //actual product ids array
        productIdArr.add(SubscriptionPlans.Monthly)
        for i in 0..<10 {
            productIdArr.add("com.kethan.\((i+1)*5)")
        }
    }
    
    func retriveProductInfo(pName: String) {
        ProgressManager.show(withStatus: "", on: self.rootController!.view)
        NetworkActivityIndicatorManager.networkOperationStarted()
        
        SwiftyStoreKit.retrieveProductsInfo([pName]) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if result.retrievedProducts.count > 0 {
                self.ProductArr.append(result.retrievedProducts.first!)
            }
            if self.ProductArr.count > 0 {
                for i in 0 ..< self.ProductArr.count {
                    if let currencyCode: String = CFLocaleGetValue(self.ProductArr[i].priceLocale as CFLocale, CFLocaleKey.currencyCode) as? String {
                        let locale: NSLocale? = NSLocale(localeIdentifier: currencyCode)
                        let currencySymbol: String = (locale?.displayName(forKey: .currencySymbol, value: currencyCode))!
                        
                        let currentPrice = currencySymbol + String(describing: self.ProductArr[i].price)
                        
                        //                        (self.planArray.object(at: i) as? IAPProduct)?.plan = currentPrice
                        
                        let attributedString = NSMutableAttributedString(string: currentPrice, attributes: [
                            .font: APP_FONT.boldFont(withSize: 45.0),
                            .foregroundColor: UIColor(white: 1.0, alpha: 1.0)
                        ])
                        attributedString.addAttribute(.font, value: APP_FONT.regularFont(withSize: 30.0), range: NSRange(location: 0, length: 1))
                        attributedString.addAttributes([.baselineOffset: 15], range: NSRange(location: 0, length: 1))
                        
                        if let cell: SubScriptionCollectionViewCell = (self.rootController as? SubScriptionViewController)?.collectionView.cellForItem(at: IndexPath(item: pName == SubscriptionPlans.Monthly ? 0 : 1, section: 0)) as? SubScriptionCollectionViewCell {
                            cell.lblPrice.attributedText = attributedString
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    if let controller: SubScriptionViewController = self.rootController as? SubScriptionViewController {
                        controller.collectionView.reloadData()
                    }
                }
            }
        }
        ProgressManager.dismiss()
    }
    
    func subscribe() {
        let controller: BaseViewController  = getTopViewController()!
        controller.showAlert(title: "Confirm?", message: "Are you sure you want to purchase this?", yesTitle: "Yes", noTitle: "No", yesCompletion: {
            ProgressManager.show(withStatus: "Subscribing..", on: self.rootController!.view)
            self.purchase(pName: self.productIdArr[self.selectedIndex] as! String, completion: { result, pName in
                if let alert = self.rootController?.alertForPurchaseResult(result as PurchaseResult) {
                    self.rootController?.showAlert(alert)
                    switch result {
                    case .success( _):
                        ProgressManager.dismiss()
                        self.verifyPurchase(pName: pName, tag: self.selectedIndex)
                    case .error:
                        ProgressManager.dismiss()
                    }
                }
            })
        }, noCompletion: nil)
    }
    
    func checkForIdentifire() {
        let finalIdentifire = self.getIdentifire()
        self.rootController?.showAlert(title: "Confirm?", message: "Are you sure you want to purchase this?", yesTitle: "Yes", noTitle: "No", yesCompletion: {
            ProgressManager.show(withStatus: "Subscribing..", on: self.rootController?.view)
            self.purchase(pName: finalIdentifire, completion: { result, pName in
                if let alert = self.rootController?.alertForPurchaseResult(result as PurchaseResult) {
                    self.rootController?.showAlert(alert)
                    switch result {
                    case .success(let purchase):
                        ProgressManager.dismiss()
                        self.verifyPurchase(pName: pName, tag: self.selectedIndex)
                    case .error:
                        ProgressManager.dismiss()
                    }
                }
            })
        }, noCompletion: nil)
    }
    
    func getIdentifire() -> String {
        let finalValue =  50-self.creditedValue.intValue()
        return "com.kethan.\(finalValue)"
    }
    
    func purchase(pName: String, completion: @escaping ((_ result: PurchaseResult, _ pName: String) -> Void)) {
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.purchaseProduct (pName, atomically: true) { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            if case .success(let purchase) = result {
                ProgressManager.dismiss()
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
        ProgressManager.show(withStatus: "Restoring your subscription..", on: self.rootController!.view)
        NetworkActivityIndicatorManager.networkOperationStarted()
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            NetworkActivityIndicatorManager.networkOperationFinished()
            ProgressManager.dismiss()
            for purchase in results.restoredPurchases where purchase.needsFinishTransaction {
                SwiftyStoreKit.finishTransaction(purchase.transaction)
            }
            self.rootController?.present((self.rootController?.alertForRestorePurchases(results))!, animated: true, completion: nil)
        }
    }
    
    func verifyReceipt(completion: @escaping (VerifyReceiptResult) -> Void) {
        let appleValidator = AppleReceiptValidator(service: .sandbox, sharedSecret: "fbd3d76eb62d42319eb197c83267bd33")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, completion: completion)
    }
    
    //verify current product status from itunes
    func verifyPurchase(pName: String, tag: Int) {
        ProgressManager.show(withStatus: "Verifying purchase..", on: self.rootController!.view)
        
        NetworkActivityIndicatorManager.networkOperationStarted()
        verifyReceipt { result in
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            switch result {
            case .success(let receipt):
                ProgressManager.dismiss()
                let productId = pName
                let purchaseResult = SwiftyStoreKit.verifySubscription(
                    ofType: tag == 0 ? .autoRenewable : .nonRenewing(validDuration: 3600 * 24 * 365),
                    productId: productId,
                    inReceipt: receipt,
                    validUntil: Date()
                )
                
                //                let str = ((self.planArray[self.selectedIndex] as? IAPProduct)!.plan)
                //                let PatientCountArr: [String] = str.components(separatedBy: " ")
                //                if let data: IAPProduct = self.planArray.object(at: tag) as? IAPProduct {
                //                    print(PatientCountArr, data)
                //                }
                
                let expiryDate: Date = (tag == 0 ? Date(timeInterval: 3600 * 24 * 30, since: Date()) : Date(timeInterval: 3600 * 24 * 365, since: Date()))
                let renewalDate: Date = (tag == 0 ? Date(timeInterval: 3600 * 24 * 31, since: Date()) : Date(timeInterval: 3600 * 24 * 366, since: Date()))
                
                let parameters = ["creditPointRedeem": tag == 0 ? "" : self.creditedPoint, "startDate": Date().convertDateToString(), "endDate": expiryDate.convertDateToString(), "subscriptionType": tag == 0 ? "Monthly" : "Yearly", "subscriptionRenewalDate": tag == 0 ? renewalDate.convertDateToString() : ""]
                
                self.updatePurchaseStatusOnServer(parameters: parameters as NSDictionary)
                
                self.setStatus(result: purchaseResult, name: pName)
                self.rootController?.showAlert((self.rootController?.alertForVerifySubscription(purchaseResult))!)
                
            case .error:
                ProgressManager.dismiss()
                self.rootController?.present((self.rootController?.alertForVerifyReceipt(result))!, animated: true, completion: nil)
            }
        }
    }
    
    func updatePurchaseStatusOnServer(parameters: NSDictionary) {
        AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.subscriptionUpdate, parameters: parameters, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
            if error == nil {
                //Delete Below
                // ProgressManager.dismiss()
                // ProgressManager.showSuccess(withStatus: "Subscription Successfull", on: self.rootController!.view)
            } else {
                ProgressManager.dismiss()
                ProgressManager.showError(withStatus: error, on: self.rootController!.view)
            }
        }
    }
    
    func setStatus(result: VerifySubscriptionResult, name: String) {
        switch result {
        case.purchased(let expiryDate, let items):
            print("SubscriptionPlans is valid until \(expiryDate) \(items)")
        case.expired(let expiryDate):
            print("SubscriptionPlans is expired since \(expiryDate)")
        case .notPurchased:
            print("SubscriptionPlans has never been purchased")
        }
    }
}
