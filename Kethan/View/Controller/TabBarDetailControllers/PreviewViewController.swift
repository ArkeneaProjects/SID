//
//  PreviewViewController.swift
//  Kethan
//
//  Created by Apple on 06/12/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit

class PreviewViewController: BaseViewController {
    
    @IBOutlet weak var cropView: CropPickerView!
    
    var isCrop: Bool = false
    var selectedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBarWithTitle("Preview", withLeftButtonType: .buttonTypeBack, withRightButtonType: (self.isCrop == true) ?.buttonCrop:.buttonTypeNil)
        
        let image = self.selectedImage!.resizeImage(targetSize: CGSize(width: getCalculated(640.0), height: getCalculated(836.0)))
        
        self.cropView.image = image
        self.cropView.isCrop = false
    }
    
    // MARK: - Button Action
    override func rightButtonAction() {
        self.cropView.isCrop = true
    }
    
    @IBAction func uploadClickAction(_ sender: Any) {
        
        print("Dimention==\(cropView.getCropViewDimention().frame)")
        let subscription = SubscriptionVM()
        subscription.checkSubscription(apiCallFrom: 1, manufecture: "", brandname: "", image: self.cropView.image!.resized(withPercentage: 0.4), rootController: self)
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
