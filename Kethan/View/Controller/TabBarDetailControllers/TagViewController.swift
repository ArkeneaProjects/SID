//
//  TagViewController.swift
//  Kethan
//
//  Created by Apple on 02/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//

import UIKit

class TagViewController: BaseViewController {

    @IBOutlet weak var cropView: CropPickerView!
    var selectedImage: UIImage?
    var isComeFromCreate: Bool = true
    var continueCompletion: ((_ cordinate: ImplantImage) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.addNavBarWithTitle("Tag View", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        self.cropView.image = self.selectedImage
        self.cropView.isCrop = true
        
        // Do any additional setup after loading the view.
    }

    @IBAction func continuClickAction(_ sender: Any) {
        print("Dimention==\(cropView.getCropViewDimention().frame)")
        if self.continueCompletion != nil {
            let impantObj = ImplantImage()
            impantObj.imageWidth = "\(String(describing: self.cropView.image!.size.width))"
            impantObj.imageHeight = "\(String(describing: self.cropView.image!.size.height))"
            impantObj.labelOffsetX = "\(String(describing: cropView.getCropViewDimention().frame.minX))"
            impantObj.labelOffsetY = "\(String(describing: cropView.getCropViewDimention().frame.minY))"
            impantObj.labelWidth = "\(String(describing: cropView.getCropViewDimention().frame.width))"
            impantObj.labelHeight = "\(String(describing: cropView.getCropViewDimention().frame.height))"
            impantObj.selectedImage = self.cropView.image
            
            self.continueCompletion!(impantObj)
            self.navigationController?.popViewController(animated: true)
        } else {
            if let controller = self.instantiate(AddDetailsViewController.self, storyboard: STORYBOARD.main) as? AddDetailsViewController {
                       self.navigationController?.pushViewController(controller, animated: true)
            }
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
