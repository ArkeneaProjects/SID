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
        
        if let size = self.selectedImage!.getFileSize() {
            //check image size is not more than 3 MB
            if size >= 3.0 {
                self.compressImage(image: self.selectedImage!)
            } else {
                self.cropView.image = self.selectedImage
                self.cropView.isCrop = false
            }
        }
    }
    
    func compressImage(image: UIImage) {
        let image = self.selectedImage!.imageWithImage(scaledToWidth: image.size.width / 2)
        let imageSize = image.getFileSize()
        print("imageSize \(imageSize!)")
        if Double(imageSize!) <= 3.0 {
            self.cropView.image = image
            self.cropView.isCrop = false
        } else {
            self.compressImage(image: image)
        }
    }
    
    // MARK: - Button Action
    override func rightButtonAction() {
        self.cropView.isCrop = true
    }
    
    @IBAction func uploadClickAction(_ sender: Any) {
        
        print("Dimention==\(cropView.getCropViewDimention().frame)")
        
//        ProgressManager.show(withStatus: "Searching our database...", on: self.view)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//            ProgressManager.dismiss()
//            if let controller = self.instantiate(SearchListViewController.self, storyboard: STORYBOARD.main) as? SearchListViewController {
//                       self.navigationController?.pushViewController(controller, animated: true)
//                   }
//        }
        let imageDict  = saveImageInDocumentDict(image: self.cropView.image!, imageName: "profile_photo")

        let imageVM = ImageSearchVM()
        imageVM.searchImage(images: [imageDict])
        
        
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
