//
//  FeaturedViewController.swift
//  YupEasy
//
//  Created by Pankaj on 12/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit
import CropViewController

class HomeViewController: BaseViewController, GalleryManagerDelegate, CropViewControllerDelegate {
    
    @IBOutlet weak var lblUserName: CustomLabel!
    @IBOutlet weak var lblPermissions: CustomLabel!
    
    @IBOutlet weak var viewCamera: UIView!
    
    let cameraManager = CameraManager()
    
    @IBOutlet weak var cameraButton: UIButton!
    
    var imagePicker: GalleryManager!
    
    @IBOutlet weak var btnCamera: CustomButton!
    @IBOutlet weak var btnFlash: CustomButton!
    @IBOutlet weak var btnGallery: CustomButton!
    
    @IBOutlet weak var viewPermission: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Home", withLeftButtonType: .buttonTypeMenu, withRightButtonType: .buttonTypeCredit)
        
        //Camera Permission
        self.askForCameraPermissions()
        
        // Camera
        cameraManager.shouldEnableExposure = true
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
        cameraManager.cameraOutputMode = CameraOutputMode.stillImage
        cameraManager.cameraOutputQuality = CameraOutputQuality.high
        cameraManager.deviceOrientation = .portrait
        //Gallery
        self.imagePicker = GalleryManager(presentationController: self, delegate: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            let creditVM = CreditVM()
            creditVM.callAPI(self, isShowLoader: false) { (success) in
                self.navBar.btnRight.setTitle("\(AppConstant.shared.loggedUser.creditPoint)", for: .normal)
            }
        }
        //Display User name
//        let userName = AppConstant.shared.loggedUser.name
//        let attributedString = NSMutableAttributedString(string: "Hello \(userName),\rLet\'s get you started! ", attributes: [
//            .font: APP_FONT.regularFont(withSize: 13.5), .foregroundColor: UIColor(white: 1.0, alpha: 1.0)])
//        attributedString.addAttribute(.font, value: APP_FONT.regularFont(withSize: 15.5), range: NSRange(location: 0, length: 5))
//        attributedString.addAttribute(.font, value: APP_FONT.boldFont(withSize: 15.5), range: NSRange(location: 6, length: userName.count))
//        self.lblUserName.attributedText = attributedString
        
        //Camera Session
        cameraManager.resumeCaptureSession()
        
        //Flash Mode
        if cameraManager.flashMode == .off {
            self.btnFlash.setImage(UIImage(named: "flashOff"), for: .normal)
        } else if cameraManager.flashMode == .on {
            self.btnFlash.setImage(UIImage(named: "flashOn"), for: .normal)
        } else {
            self.btnFlash.setImage(UIImage(named: "flashAuto"), for: .normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Checking Camera Staus
        let currentCameraState = cameraManager.currentCameraStatus()
        if currentCameraState == .notDetermined {
            self.viewPermission.alpha = 1.0
            //self.camaraDeneyMsg()
        } else if currentCameraState == .ready {
            self.viewPermission.alpha = 0
            self.isPermissionGranted(isTrue: true)
            addCameraToView()
        } else {
            //self.camaraDeneyMsg()
            self.viewPermission.alpha = 1.0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        #if TARGET_OS_SIMULATOR
        // Simulator-specific code
        cameraManager.stopCaptureSession()
        #else
        // Device-specific code
        cameraManager.stopCaptureSession()
        #endif
        
    }
    
    // MARK: - Button Click Action
    func camaraDeneyMsg() {
        self.showAlert(title: "Unable to access the Camera", message: "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app and take great pictures", yesTitle: "OK", noTitle: "Cancel", yesCompletion: {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        }, noCompletion: {
            self.viewPermission.alpha = 1.0
        })
    }
    
    @IBAction func cameraPermission(_ sender: CustomButton) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    override func leftButtonAction() {
        self.revealViewController()?.revealToggle(self.navBar.btnLeft)
    }
    
    override func rightButtonAction() {
        self.tabBarController?.selectedIndex = 3
    }
    
    @IBAction func galleryClickAction(_ sender: CustomButton) {
        self.imagePicker.present(croppingStyle: .circular, isCrop: false, isCamera: false, showLabel: false)
    }
    
    @IBAction func flashClickAction(_ sender: CustomButton) {
        switch cameraManager.changeFlashMode() {
        case .off:
            self.btnFlash.setImage(UIImage(named: "flashOff"), for: .normal)
        case .on:
            self.btnFlash.setImage(UIImage(named: "flashOn"), for: .normal)
        case .auto:
            self.btnFlash.setImage(UIImage(named: "flashAuto"), for: .normal)
        }
    }
    
    @IBAction func askForCameraPermissions() {
        
        self.cameraManager.askUserForCameraPermission({ permissionGranted in
            
            if permissionGranted {
                self.viewPermission.alpha = 0
                self.isPermissionGranted(isTrue: true)
                self.addCameraToView()
            } else {
                if #available(iOS 10.0, *) {
                   // UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                } else {
                    // Fallback on earlier versions
                }
            }
        })
    }
    
    // MARK: - ViewController
    fileprivate func addCameraToView() {
        cameraManager.addPreviewLayerToView(self.viewCamera, newCameraOutputMode: CameraOutputMode.stillImage)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        
        switch cameraManager.cameraOutputMode {
        case .stillImage:
            cameraManager.capturePictureWithCompletion({ result in
                switch result {
                case .failure:
                    self.cameraManager.showErrorBlock("Error occurred", "Cannot save picture.")
                case .success(let content):
                    if let capturedImage = content.asImage {
                        print("Success")
                        //self.imagePicker.cropImage(image: capturedImage, croppingStyle: .default, isCrop: true)
                        //                        if let controller = self.instantiate(PreviewViewController.self, storyboard: STORYBOARD.main) as? PreviewViewController {
                        //                            controller.selectedImage = capturedImage
                        //                            controller.isCrop = true
                        //                            self.navigationController?.pushViewController(controller, animated: true)
                        //                        }
                        self.cropImageToSquare(capturedImage: capturedImage)
                    }
                }
            })
        case .videoWithMic, .videoOnly:
            cameraButton.isSelected = !cameraButton.isSelected
            cameraButton.setTitle("", for: UIControl.State.selected)
            
            cameraButton.backgroundColor = cameraButton.isSelected ? .red : .blue
            if sender.isSelected {
                cameraManager.startRecordingVideo()
            } else {
                cameraManager.stopVideoRecording({ (videoURL, error) -> Void in
                    if error != nil {
                        self.cameraManager.showErrorBlock("Error occurred", "Cannot save video.")
                    }
                })
            }
        }
    }
    
    func cropImageToSquare(capturedImage: UIImage) {
        let cropController = CropViewController(croppingStyle: .default, image: capturedImage)
        // if self.aspectRatioPickerButtonHidden == true {
        cropController.aspectRatioPreset = .presetCustom
        cropController.rotateButtonsHidden = false
        cropController.aspectRatioPickerButtonHidden = true
        cropController.resetAspectRatioEnabled = false
        cropController.cropView.cropBoxResizeEnabled = true
        cropController.aspectRatioLockEnabled = false
        //  }
        
        cropController.delegate = self
        let instructionLabel = UILabel(frame: CGRect(x: 10, y: 20, width: self.view.frame.size.width-20, height: 70))
        instructionLabel.numberOfLines = 3
        instructionLabel.textAlignment = .center
        instructionLabel.textColor = .white
        instructionLabel.text = "Please crop out the background to focus on the implant "
        cropController.cropView.addSubview(instructionLabel)
        cropController.toolbar.doneTextButton.setTitleColor(UIColor.white, for: .normal)
        cropController.toolbar.cancelTextButton.setTitleColor(UIColor.white, for: .normal)
        cropController.isAccessibilityElement = true
        
        self.present(cropController, animated: true, completion: nil)
    }
    
    func isPermissionGranted(isTrue: Bool) {
        
        self.lblPermissions.isUserInteractionEnabled = (isTrue == true) ?false:true
        self.lblPermissions.text = (isTrue == true) ?"Ensure that the implant is clearly visible in the image and the image itself isn’t blurred.":"Tap here to enable camera access and take great pictures"
        self.lblPermissions.textColor = (isTrue == true) ?UIColor.white:UIColor.black
        self.btnCamera.setImage(UIImage(named: "camera"), for: .normal)
        self.btnCamera.alpha = (isTrue == true) ?1.0:0
        self.btnFlash.alpha = (isTrue == true) ?1.0:0
    }
    
    // MARK: - Gallery Delegate
    func didSelect(image: UIImage?) {
        self.cropImageToSquare(capturedImage: image!)
        //        if let controller = self.instantiate(PreviewViewController.self, storyboard: STORYBOARD.main) as? PreviewViewController {
        //            controller.selectedImage = image
        //            controller.isCrop = true
        //            self.navigationController?.pushViewController(controller, animated: true)
        //        }
    }
    
    // MARK: - CropViewControllerDelegate
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        print(cropRect)
        if let controller = self.instantiate(PreviewViewController.self, storyboard: STORYBOARD.main) as? PreviewViewController {
            controller.selectedImage = image
            controller.isCrop = true
            self.navigationController?.pushViewController(controller, animated: true)
        }
        cropViewController.dismiss(animated: true, completion: nil)

        //        if let controller = self.instantiate(SearchListViewController.self, storyboard: STORYBOARD.main) as? SearchListViewController {
        //            controller.searchImage = image
        //            controller.isCalledFrom = 1
        //            self.navigationController?.pushViewController(controller, animated: true)
        //        }
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropImageToRect rect: CGRect, angle: Int) {
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
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
