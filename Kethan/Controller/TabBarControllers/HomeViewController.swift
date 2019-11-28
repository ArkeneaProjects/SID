//
//  FeaturedViewController.swift
//  YupEasy
//
//  Created by Pankaj on 12/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, GalleryManagerDelegate {
    
    @IBOutlet weak var lblUserName: CustomLabel!
    @IBOutlet weak var lblPermissions: CustomLabel!
    
    @IBOutlet weak var viewCamera: UIView!
    
    let cameraManager = CameraManager()
    
    @IBOutlet weak var cameraButton: UIButton!
   
    var imagePicker: GalleryManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNavBarWithTitle("Home", withLeftButtonType: .buttonTypeMenu, withRightButtonType: .buttonTypeCredit)
        
        // Camera
        cameraManager.shouldEnableExposure = true
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
        cameraManager.cameraOutputMode = CameraOutputMode.stillImage
        cameraManager.cameraOutputQuality = CameraOutputQuality.high
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(askForCameraPermissions))
        lblPermissions.addGestureRecognizer(tapGesture)
        
        //Display User name
        let userName = "Bruce"
        let attributedString = NSMutableAttributedString(string: "Hello \(userName),\rLet\'s get you started! ", attributes: [
            .font: UIFont(name: "HelveticaNeue", size: getCalculated(13.5))!, .foregroundColor: UIColor(white: 1.0, alpha: 1.0)])
        attributedString.addAttribute(.font, value: UIFont(name: "HelveticaNeue", size: getCalculated(15.5))!, range: NSRange(location: 0, length: 5))
        attributedString.addAttribute(.font, value: UIFont(name: "HelveticaNeue-Bold", size: getCalculated(15.5))!, range: NSRange(location: 6, length: userName.count))
        self.lblUserName.attributedText = attributedString
        
        //Gallery
        self.imagePicker = GalleryManager(presentationController: self, delegate: self)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Checking Camera Staus
        let currentCameraState = cameraManager.currentCameraStatus()
        if currentCameraState == .notDetermined {
            self.isPermissionGranted(isTrue: false)
        } else if currentCameraState == .ready {
            self.isPermissionGranted(isTrue: true)
            addCameraToView()
        } else {
            self.isPermissionGranted(isTrue: false)
        }
        //Camera Session
        cameraManager.resumeCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    
    // MARK: - Button Click Action
    override func leftButtonAction() {
        self.revealViewController()?.revealToggle(self.navBar.btnLeft)
    }
    @IBAction func galleryClickAction(_ sender: CustomButton) {
        self.imagePicker.present()
    }
    @IBAction func flashClickAction(_ sender: CustomButton) {
        
    }
    @IBAction func askForCameraPermissions() {
        
        self.cameraManager.askUserForCameraPermission({ permissionGranted in
            
            if permissionGranted {
                self.isPermissionGranted(isTrue: true)
                self.addCameraToView()
            } else {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
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
                        print("Sucess")
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
    
    func isPermissionGranted(isTrue: Bool) {
        
        self.lblPermissions.isUserInteractionEnabled = (isTrue == true) ?false:true
        self.lblPermissions.text = (isTrue == true) ?"Click a picture of the X-Ray to search in our Database":"Tap here to enable camera access and take great pictures"
        self.lblPermissions.textColor = (isTrue == true) ?UIColor.white:UIColor.black
    }
    
    func didSelect(image: UIImage?) {
        print(image)
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
