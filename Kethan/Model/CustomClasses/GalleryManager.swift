//
//  GalleryManager.swift
//  Kethan
//
//  Created by Apple on 28/11/19.
//  Copyright © 2019 Arkenea. All rights reserved.
//

import UIKit
import Photos
import CropViewController

public protocol GalleryManagerDelegate: class {
    func didSelect(image: UIImage?)
}

class GalleryManager: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController: BaseViewController?
    private weak var delegate: GalleryManagerDelegate?
    
    var croppingStyle = CropViewCroppingStyle.circular
    var crop: Bool = false
    
    public init(presentationController: BaseViewController, delegate: GalleryManagerDelegate) {
        self.pickerController = UIImagePickerController()
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = false
        self.pickerController.mediaTypes = ["public.image"]
        self.pickerController.navigationBar.isTranslucent = false
        self.pickerController.navigationBar.barTintColor = APP_COLOR.color1 // Background color
        self.pickerController.navigationBar.tintColor = .white // Cancel button ~ any UITabBarButton items
        self.pickerController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
    public func present(croppingStyle: CropViewCroppingStyle, isCrop: Bool, isCamera: Bool) {
        self.crop = isCrop
        self.croppingStyle = croppingStyle
        if isCamera == true {
            self.checkPermission()
        } else {
            self.pickerController.sourceType = .photoLibrary
            self.presentationController!.present(self.pickerController, animated: true)
        }
        
    }
    
    // MARK: - Permission
    func checkPermission() {
        let deviceHasCamera = UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) || UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front)
               if deviceHasCamera {
                   let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
                   let userAgreedToUseIt = authorizationStatus == .authorized
                   if userAgreedToUseIt {
                       self.pickerController.sourceType = .camera
                       self.presentationController!.present(self.pickerController, animated: true)
                   } else if authorizationStatus == AVAuthorizationStatus.notDetermined {
                       self.determinePermission()
                       self.pickerController.sourceType = .camera
                       self.presentationController!.present(self.pickerController, animated: true)
                   } else {
                      let cameraUnavailableAlertController = UIAlertController (title: "Photo Library access is denied", message: "To enable access, go to Settings > Privacy > turn on Photo Library access for this app.", preferredStyle: .alert)
                       
                       let settingsAction = UIAlertAction(title: "Settings", style: .destructive) { (_) -> Void in
                           let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
                           if let url = settingsUrl {
                               UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
                           }
                       }
                       let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                       cameraUnavailableAlertController .addAction(cancelAction)
                       cameraUnavailableAlertController .addAction(settingsAction)
                       self.presentationController!.present(cameraUnavailableAlertController, animated: true, completion: nil)
                   }
               } else {
                  
               }
    }
    
    func determinePermission() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized: break
            // as above
            case .denied, .restricted: break
            // as above
            case .notDetermined: break
                // won't happen but still
            }
        }
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: false) {
            if let imageSelect = image {
                if self.crop == false {
                    self.delegate?.didSelect(image: imageSelect)
                } else {
                    let cropController = CropViewController(croppingStyle: self.croppingStyle, image: imageSelect)
                    // if self.aspectRatioPickerButtonHidden == true {
                         cropController.aspectRatioPreset = .presetSquare
                         cropController.rotateButtonsHidden = true
                         cropController.aspectRatioPickerButtonHidden = true
                         cropController.resetAspectRatioEnabled = false
                         cropController.cropView.cropBoxResizeEnabled = false
                   //  }
                    
                     cropController.delegate = self
                     cropController.title = "Crop Image"
                     cropController.toolbar.doneTextButton.setTitleColor(UIColor.white, for: .normal)
                     cropController.toolbar.cancelTextButton.setTitleColor(UIColor.white, for: .normal)
                       cropController.isAccessibilityElement = true
                     //If profile picture, push onto the same navigation stack
                    if self.croppingStyle == .circular {
                        if controller.sourceType == .camera {
                            self.presentationController!.present(cropController, animated: true, completion: nil)
                         } else {
                             self.presentationController!.present(cropController, animated: true)
                         }
                     } else { //otherwise dismiss, and then present from the main controller
                        self.presentationController!.present(cropController, animated: true, completion: nil)
                     }
                }
            }
            
        }
        
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

extension GalleryManager: CropViewControllerDelegate {
    // MARK: - CropViewControllerDelegate
       func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
           print(cropRect)
           if self.croppingStyle == .circular {
               let crop_Image = image.compressProfileImage(maxWidth: 800.0, maxHeight: 600.0)
               self.delegate?.didSelect(image: crop_Image)
           } else {
                self.delegate?.didSelect(image: image)
           }
           cropViewController.dismiss(animated: true, completion: nil)
       }
       
       func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int) {
           
       }
       
       func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
           cropViewController.dismiss(animated: true, completion: nil)
       }
}

extension GalleryManager: UINavigationControllerDelegate {
    
}
