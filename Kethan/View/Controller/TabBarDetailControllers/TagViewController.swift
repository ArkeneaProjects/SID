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

    override func viewDidLoad() {
        super.viewDidLoad()
         
        self.addNavBarWithTitle("Tag View", withLeftButtonType: .buttonTypeBack, withRightButtonType: .buttonTypeNil)
        self.cropView.image = self.selectedImage
        self.cropView.isCrop = true
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func continuClickAction(_ sender: Any) {
        print("Dimention==\(cropView.getCropViewDimention().frame)")
        if let controller = self.instantiate(AddDetailsViewController.self, storyboard: STORYBOARD.main) as? AddDetailsViewController {
            self.navigationController?.pushViewController(controller, animated: true)
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
