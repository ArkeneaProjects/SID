//
//  SearchDetailViewController.swift
//  Kethan
//
//  Created by Apple on 25/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class SearchDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    var detailObj = SearchResult()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Details", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeReport)
        self.navBar.btnRightEdit.contentHorizontalAlignment = .right
        
        self.tblView.registerNibWithIdentifier([IDENTIFIERS.DetailRow1TableViewCell, IDENTIFIERS.DetailRow2TableViewCell])
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = getCalculated(35.0)
        self.tblView.tableFooterView = UIView()
        
        let searchVM = SearchVM()
        //searchVM.sendEmail(implantId: detailObj._id)
        // Do any additional setup after loading the view.
    }
    
    override func rightButtonAction() {
        self.report(imageData: "")
    }
    
    func openGalleryListReport(indexpath: IndexPath, imgNameArr: NSMutableArray, sourceView: UIImageView, isProfile: Bool = false, isdelete: Bool = false) {
        
        var items = [SKPhoto]()
        var arr = [ObjectLocation]()
        for item in imgNameArr {
            if let object = item as? ImageData {
                arr.append(object.objectLocation)
                if let image = object.image {
                    let item = SKPhoto.photoWithImage(image, object: object.objectLocation)
                    items.append(item)
                } else {
                    let item = SKPhoto.photoWithImageURL(object.imageName, object: object.objectLocation, imageData: item as? ImageData)
                    items.append(item)
                }
            } else if let url = item as? String {
                let item = SKPhoto.profilePhotoURL(url, holder: UIImage(named: "default-user"))
                items.append(item)
            }
        }
        
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: items, imageDataArray: imgNameArr, showReportButtons : true)
        browser.initializePageIndex(indexpath.row)
        browser.cordinate = arr
        browser.addCompletion = { imageArr in
            print(imageArr)
            self.report(imageData: imageArr.jsonString())
        }
        present(browser, animated: true, completion: {})
    }
    
    func report(imageData: String) {
        let controller: ReportViewController = self.instantiate(ReportViewController.self, storyboard: STORYBOARD.main) as? ReportViewController ?? ReportViewController()
        controller.preparePopup(controller: self)
        controller.showPopup()
        controller.addCompletion = { str, brand in
            if str.count > 0 {
                let dict = ["implantId": self.detailObj._id,
                            "suggestedImplantId": brand,
                            "comment": str,
                            "imageData": imageData]
                
                AFManager.sendPostRequestWithParameters(method: .post, urlSuffix: SUFFIX_URL.addReporting, parameters: dict as NSDictionary, serviceCount: 0) { (response: AnyObject?, error: String?, errorCode: String?) in
                    if error == nil {
                        ProgressManager.showSuccess(withStatus: "Your concern has been raised successfully", on: self.view) {
                            
                        }
                    } else {
                        ProgressManager.showError(withStatus: error, on: self.view)
                    }
                }
            }
        }
    }
    
    // MARK: - Button Action
    @IBAction func edittButtonAction() {
        if let controller = self.instantiate(AddDetailsViewController.self, storyboard: STORYBOARD.main) as? AddDetailsViewController {
            controller.implantObj = detailObj
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - UITabelVieeDelegate, UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return getCalculated(400.0)
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailObj.removImplant.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.DetailRow1TableViewCell) as? DetailRow1TableViewCell {
                var customCollection: SearchViewCollecction?
                customCollection = SearchViewCollecction.loadInstanceFromNib() as? SearchViewCollecction
                cell.lblTitle.text = detailObj.objectName
                cell.lblDiscription.text = detailObj.implantManufacture
                customCollection!.setupWith(superView: cell.viewCollection, controller: self, isview: false)
                customCollection!.lblImageCount.alpha = (self.detailObj.imageData.count > 1) ?1.0:0
                customCollection!.lblImageCount.text = "1/\(self.detailObj.imageData.count)"
                customCollection!.arrAllItems =  NSMutableArray(array: self.detailObj.imageData)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: IDENTIFIERS.DetailRow2TableViewCell) as? DetailRow2TableViewCell {
                cell.lblResponse.text = (detailObj.removImplant[indexPath.row - 1] as? Implant ?? Implant()).removalProcess
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
