//
//  GalleryManager.swift
//  Kethan
//
//  Created by Apple on 28/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import Photos

public protocol GalleryManagerDelegate: class {
    func didSelect(image: UIImage?)
}

class GalleryManager: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: BaseViewController?
    private weak var delegate: GalleryManagerDelegate?
    
    public init(presentationController: BaseViewController, delegate: GalleryManagerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate
    
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.sourceType = .photoLibrary
        self.pickerController.mediaTypes = ["public.image"]
        self.pickerController.navigationBar.isTranslucent = false
        self.pickerController.navigationBar.barTintColor = APP_COLOR.color1 // Background color
        self.pickerController.navigationBar.tintColor = .white // Cancel button ~ any UITabBarButton items
        self.pickerController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }
    
    public func present() {
        self.presentationController?.present(self.pickerController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image)
    }
}

extension GalleryManager: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return self.pickerController(picker, didSelect: nil)
        }
        self.pickerController(picker, didSelect: image)
    }
}

extension GalleryManager: UINavigationControllerDelegate {
    
}
