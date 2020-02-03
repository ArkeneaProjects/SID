//
//  BaseViewController.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit
import GoogleSignIn

class BaseViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, SWRevealViewControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet var viewNavBar: UIView!
    
    @IBOutlet weak var constScreenTop: NSLayoutConstraint!
    @IBOutlet weak var constPopupBottom: NSLayoutConstraint!
    @IBOutlet weak var constScreenBottom: NSLayoutConstraint!
    @IBOutlet weak var const_NavbarHeight: NSLayoutConstraint!
    
    var navBar: CustomNavBar!
    var revealViewController: SWRevealViewController!
    
    var isPopupScreenType: Bool = false
    var isEditingEnabled: Bool = false
    var isPopupEnabled: Bool = false
    var isNormalEditEnabled: Bool = false
    var isScrollEditEnabled: Bool = false
    var isForceDisableScroll: Bool = false
    
    var currentTextField: UITextField?
    var currentTextView: UITextView?
    var scrollTextField: UITextField?
    var scrollTextView: UITextView?
    
    var keyboardHeight: CGFloat = 0
    
    let navHeight: CGFloat = 64.0
    
    // MARK: - View DidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check RevelView initialize
        if self.revealViewController() != nil {
            if self.navigationController != nil {
                if self.navigationController?.viewControllers.count == 1 {
                    //let reveal: SWRevealViewController = self.revealViewController()
                    //reveal.panGestureRecognizer()
                    //reveal.tapGestureRecognizer()
                    //self.revealViewController().delegate = self
                    self.revealViewController()?.rearViewRevealWidth = getCalculated(270.0)
                    self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                }
            }
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
        //TabBar button Hide/Show
        if self.tabBarController != nil {
            if self.navigationController != nil {
                if self.navigationController!.viewControllers.count > 1 {
                    self.hidesBottomBarWhenPushed = true
                    self.tabBarController?.tabBar.isHidden = true
                } else {
                    self.tabBarController?.tabBar.isHidden = false
                }
            }
        }
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
 
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController != nil {
            if self.navigationController!.viewControllers.count > 1 {
                return true
            }
        }
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.revealViewController() != nil {
            if self.navigationController?.viewControllers.first?.isKind(of: self.classForCoder) == false {
                self.revealViewController().panGestureRecognizer().isEnabled = false
            }
        }
        
        //Navigation Controller initialize
        if self.navigationController != nil {
            self.navigationController?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (self is TagViewController) ?false:true
        }
        
        //TabBar button Hide/Show
        if self.isPopupScreenType {
            if self.tabBarController != nil {
                //self.tabBarController?.tabBar.isHidden = true
            }
        } else {
            if self.tabBarController != nil {
                if self.navigationController != nil {
                    if self.navigationController!.viewControllers.count == 1 {
                        self.tabBarController?.tabBar.isHidden = false
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.revealViewController() != nil {
            if self.navigationController?.viewControllers.first?.isKind(of: self.classForCoder) == true {
                self.revealViewController().panGestureRecognizer().isEnabled = true
            }
        }
        
        //TabBar button Hide/Show
        if self.tabBarController != nil {
            if self.navigationController != nil {
                if self.navigationController!.viewControllers.count > 1 {
                    self.tabBarController?.tabBar.isHidden = true
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        //TabBar button Hide/Show
        if self.isPopupScreenType {
            if self.tabBarController != nil {
                if self.navigationController != nil {
                    if self.navigationController!.viewControllers.count == 1 {
                        self.tabBarController?.tabBar.isHidden = false
                    }
                }
            }
        } else {
            if self.tabBarController != nil {
                if self.navigationController != nil {
                    if self.navigationController!.viewControllers.count > 1 {
                        self.tabBarController?.tabBar.isHidden = true
                    }
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Add Custom Nav Bar
    func addNavBarWithTitle(_ title: String, withLeftButtonType leftButtonType: ButtonType, withRightButtonType rightButtonType: ButtonType) {
        self.navBar = CustomNavBar.mk_loadInstanceFromNib() as? CustomNavBar ?? CustomNavBar()
        
        self.navBar.setupWithSuperView(self.viewNavBar, title: title, leftButtonType: leftButtonType, rightButtonType: rightButtonType, target: self, leftAction: #selector(BaseViewController.leftButtonAction), rightAction: #selector(BaseViewController.rightButtonAction))
        self.view.bringSubviewToFront(self.navBar)
        
        self.const_NavbarHeight.constant = (isDevice() == DEVICES.iPhoneX || isDevice() == DEVICES.iPhoneXR) ?88.0:self.navHeight
        
    }
    
    // MARK: - Navigation Item button action
    @IBAction func leftButtonAction() {
        for controller in self.children {
            controller.view.removeFromSuperview()
            controller.removeFromParent()
        }
        
        if self.navigationController != nil {
            self.navigationController!.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func rightButtonAction() {
        
    }
    
    // MARK: - Navigation to Home, false for login, true for login
    func navigateToHome(_ withLoggedIn: Bool, _ loginAnimated: Bool) {
        
      //  DispatchQueue.main.asyncAfter(deadline: .now()) {
            //Display screen accroding to user login
            if withLoggedIn == true {
                let login = self.instantiateNav("LoginViewController", storyboard: STORYBOARD.signup )
                self.setAsRootScreen(login)
            } else {
                let tabBarViewController: BaseTabBarViewController = BaseTabBarViewController()
                let tabBarAppearence = UITabBar.appearance()
                tabBarAppearence.isTranslucent = true
                tabBarAppearence.barStyle = UIBarStyle.black
                tabBarAppearence.tintColor = UIColor.white
                tabBarAppearence.barTintColor = UIColor.white
                tabBarAppearence.backgroundColor = UIColor.white
                tabBarAppearence.itemWidth = UIScreen.main.bounds.size.width / 3.0
                tabBarAppearence.itemPositioning = UITabBar.ItemPositioning.fill
                tabBarAppearence.itemSpacing = 0
                
                let search = self.instantiateNav("SearchViewController", storyboard: STORYBOARD.main )
                search.tabBarItem = self.getTabBarButtonWithTitle(title: "", imageName: "tab1_deactive", selectedImageName: "tab1_active")
                
                let home = self.instantiateNav("HomeViewController", storyboard: STORYBOARD.main)
                home.tabBarItem = self.getTabBarButtonWithTitle(title: "", imageName: "tab2_deactive", selectedImageName: "tab2_active")
                
                let upload = self.instantiateNav("UploadViewController", storyboard: STORYBOARD.main)
                upload.tabBarItem = self.getTabBarButtonWithTitle(title: "", imageName: "tab3_deactive", selectedImageName: "tab3_active")
                
                let purchase = self.instantiateNav("PurchesViewController", storyboard: STORYBOARD.main)
                purchase.tabBarItem = self.getTabBarButtonWithTitle(title: "", imageName: "tab4_deactive", selectedImageName: "tab4_active")
                
                tabBarViewController.viewControllers = [search, home, upload, purchase]
                tabBarViewController.delegate = AppDelegate.delegate()?.tabBarDelegate
                
                self.setAsRootScreen(tabBarViewController)
                tabBarViewController.selectedIndex = 1
                AppDelegate.delegate()?.tabBarController = tabBarViewController
            }
        //}
        
    }
    
    func instantiate(_ value: AnyClass, storyboard: String) -> UIViewController {
          let storyboard: UIStoryboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
          return (storyboard.instantiateViewController(withIdentifier: String(describing: value))) as UIViewController
    }
    
    func getTabBarButtonWithTitle(title: String?, imageName: String, selectedImageName: String?) -> UITabBarItem {
        let tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: ((selectedImageName != nil) ?UIImage(named: selectedImageName!)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal):nil))
        tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        tabBarItem.title = nil
        return tabBarItem
    }
    
    // MARK: - Instantiate Navigation Controller
    func instantiateNav(_ identifier: String, storyboard: String) -> UINavigationController {
        let storyboard: UIStoryboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        let controller = (storyboard.instantiateViewController(withIdentifier: identifier)) as? BaseViewController ?? BaseViewController()
        if identifier == "HomeViewController" {
            let storyboardLeftMenu: UIStoryboard = UIStoryboard(name: STORYBOARD.leftMenu, bundle: Bundle.main)
            let sideMenuController: LeftMenuViewController = storyboardLeftMenu.instantiateViewController(withIdentifier: "LeftMenuViewController") as? LeftMenuViewController ?? LeftMenuViewController()
            
            let rearNavigationController: UINavigationController = UINavigationController(rootViewController: sideMenuController)
            rearNavigationController.navigationItem.hidesBackButton = true
            rearNavigationController.isNavigationBarHidden = true
            
            let frontNavigationController: UINavigationController = UINavigationController(rootViewController: controller)
            frontNavigationController.navigationItem.hidesBackButton = true
            frontNavigationController.isNavigationBarHidden = true
            
            controller.revealViewController = SWRevealViewController(rearViewController: rearNavigationController, frontViewController: frontNavigationController)
            controller.revealViewController()?.setFront(controller, animated: false)
            controller.revealViewController()?.setFrontViewPosition(.left, animated: false)
            
        }
        let navigation = UINavigationController(rootViewController: (identifier == "HomeViewController") ?controller.revealViewController:controller)
       // let navigation = UINavigationController(rootViewController: controller)
        navigation.restorationIdentifier = String(format: "Nav_%@", identifier)
        navigation.isNavigationBarHidden = true
        return navigation
    }
    
    func setAsRootScreen(_ controller: UIViewController) {
        // AppDelegate.delegate()!.window?.setWindowRootViewController(rootController: controller)
        AppDelegate.delegate()?.window?.rootViewController = controller
        AppDelegate.delegate()?.window?.makeKeyAndVisible()
        
    }
    
    // MARK: - UITextFieldDelegate -
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
                
        if textField.isKind(of: CustomTextField.classForCoder()) == true {
            if textField.keyboardType == UIKeyboardType.numberPad || textField.keyboardType == UIKeyboardType.decimalPad || textField.keyboardType == UIKeyboardType.phonePad {
                  (textField as? CustomTextField ?? CustomTextField()).addDoneButton(target: self, selector: #selector(self.resignKeyboard))
            }
        } else if textField.isKind(of: SkyFloatingLabelTextField.classForCoder()) == true {
            //            if textField.keyboardType == UIKeyboardType.numberPad || textField.keyboardType == UIKeyboardType.decimalPad || textField.keyboardType == UIKeyboardType.phonePad || textField.keyboardType == UIKeyboardType.numbersAndPunctuation {
            //                (textField as? SkyFloatingLabelTextField ?? SkyFloatingLabelTextField()).addDoneButton(target: self, selector: #selector(self.resignKeyboard))
            //            }
            if textField.keyboardType == UIKeyboardType.numberPad || textField.keyboardType == UIKeyboardType.decimalPad || textField.keyboardType == UIKeyboardType.phonePad || textField.keyboardType == UIKeyboardType.emailAddress {
                //  (textField as? CustomTextField ?? CustomTextField()).addDoneButton(target: self, selector: #selector(self.resignKeyboard))
            }
        }
        
        return true
    }
    // MARK: - TextViewDelegate -
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.isScrollEditEnabled == true {
            self.scrollTextField = nil
            self.scrollTextView = textView
        } else if self.isNormalEditEnabled == true {
            self.currentTextField = nil
            self.currentTextView = textView
            if textView.isKind(of: CustomTextView.classForCoder()) == true {
                            if textView.keyboardType == UIKeyboardType.default {
                                (textView as? CustomTextView ?? CustomTextView()).addDoneButtonInTextView(target: self, selector: #selector(self.resignKeyboard))
                            }
            }
        }
        return true
    }
    
    @objc func resignKeyboard(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        if let parent = self.parent {
            parent.view.endEditing(true)
        }
    }
    
    // MARK: - Show ActionSheet
    func showActionSheet(headerTitle: String, cameraTitle: String, galleryTitle: String, galleryCompletion: (() -> Void)?, cameraCompletion: (() -> Void)?) {
        let alert = UIAlertController(title: headerTitle, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: cameraTitle, style: .default, handler: { _ in
            if cameraCompletion != nil {
                cameraCompletion!()
            }
        }))
        
        alert.addAction(UIAlertAction(title: galleryTitle, style: .default, handler: { _ in
            if galleryCompletion != nil {
                galleryCompletion!()
            }
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Show alert -
    func showAlert(title: String, message: String, yesTitle: String?, noTitle: String?, yesCompletion: (() -> Void)?, noCompletion: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        if yesTitle != nil {
            if (yesTitle?.count)! > 0 {
                alert.addAction(UIAlertAction(title: yesTitle, style: UIAlertAction.Style.default, handler: { (_) -> Void in
                    if yesCompletion != nil {
                        yesCompletion!()
                    }
                }))
            }
        }
        if noTitle != nil {
            if (noTitle?.count)! > 0 {
                alert.addAction(UIAlertAction(title: noTitle, style: UIAlertAction.Style.cancel, handler: { (_) -> Void in
                    if noCompletion != nil {
                        noCompletion!()
                    }
                }))
            }
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Logout
    func authenticationFailed() {
        
        self.showAlert(title: "", message: "Authentication failed try to re login", yesTitle: nil, noTitle: "OK", yesCompletion: nil) {
            self.logoutFromApp()
        }
    }
    
    func logoutFromApp() {
        FacebookManager.logoutUser()
        GIDSignIn.sharedInstance()?.signOut()
        AppConstant.shared.loggedUser = User()
        deleteUserDefaultsForKey(key: UserDefaultsKeys.LoggedUser)
        isLoginViewAnimated = false
        self.navigateToHome(true, false)
    }
    
    func openGalleryList(indexpath: IndexPath, imgNameArr: NSMutableArray, sourceView: UIImageView, isProfile: Bool = false, isdelete: Bool = false) {
    
        var items = [SKPhoto]()
        var arr = [ObjectLocation]()
        for item in imgNameArr {
            if let object = item as? ImageData {
                arr.append(object.objectLocation)
                if let image = object.image {
                    let item = SKPhoto.photoWithImage(image, object: object.objectLocation)
                    items.append(item)
                } else {
                    let item = SKPhoto.photoWithImageURL(object.imageName, object: object.objectLocation)
                    items.append(item)
                }
            } else if let url = item as? String {
                let item = SKPhoto.profilePhotoURL(url, holder: UIImage(named: "default-user"))
                items.append(item)
            }
        }
        
        // 2. create PhotoBrowser Instance, and present.
        let browser = SKPhotoBrowser(photos: items)
        
        browser.initializePageIndex(indexpath.row)
        browser.cordinate = arr
        present(browser, animated: true, completion: {})
        
    }
    
    // MARK: - Popup Functions -
    func showPopupWithView(viewPopup: UIView, viewContainer: UIView, viewBlur: UIView, btnClose: CustomButton?) {
        if self.navigationController != nil {
            self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        }
        
        self.view.endEditing(true)
        self.isPopupEnabled = true
        
        if viewContainer.superview != nil {
            viewContainer.superview?.bringSubviewToFront(viewContainer)
        }
        
        if self.parent != nil {
            self.parent?.view.bringSubviewToFront(self.view)
        }
        
        if self.parent?.parent != nil {
            self.parent?.parent?.view.bringSubviewToFront((self.parent?.view)!)
        }
        
        viewContainer.alpha = 1.0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {() -> Void in
            viewBlur.alpha = 1.0
            viewPopup.alpha = 1.0
            viewPopup.transform = CGAffineTransform.identity
            
            if btnClose != nil {
                btnClose!.alpha = 1.0
            }
            
        }, completion: {(_ finished: Bool) -> Void in
            
        })
    }
    
    func preparePopupWithView(viewPopup: UIView, viewContainer: UIView, viewBlur: UIView, btnClose: CustomButton?) {
        self.isPopupEnabled = false
        
        if viewContainer.superview != nil {
            viewContainer.superview?.sendSubviewToBack(viewContainer)
        }
        
        viewPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        
        viewBlur.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        viewContainer.backgroundColor = UIColor.clear
        
        viewBlur.alpha = 0
        viewPopup.alpha = 0
        viewContainer.alpha = 0
        
        if btnClose != nil {
            btnClose!.alpha = 0
        }
    }
    
    func dismissPopupWithView(remove: Bool, viewPopup: UIView, viewContainer: UIView, viewBlur: UIView, btnClose: CustomButton?) {
        dismissPopupWithView(remove: remove, viewPopup: viewPopup, viewContainer: viewContainer, viewBlur: viewBlur, btnClose: btnClose, withCompletion: nil)
    }
    
    func dismissPopupWithView(remove: Bool, viewPopup: UIView, viewContainer: UIView, viewBlur: UIView, btnClose: CustomButton?, withCompletion completion: VoidCompletion?) {
        self.view.endEditing(true)
        self.isPopupEnabled = false
        
        viewPopup.alpha = 1.0
        viewPopup.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            viewBlur.alpha = 0
            viewPopup.alpha = 0
            viewPopup.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            
            if btnClose != nil {
                btnClose!.alpha = 0
            }
        }) { (_ finished: Bool) in
            if finished == true {
                viewContainer.superview!.sendSubviewToBack(viewContainer)
                viewContainer.alpha = 0
                
                if let parent = self.findParentBaseViewController() {
                    parent.checkForGesture(parent)
                }
                
                if remove == true {
                    if let superView = viewContainer.superview {
                        superView.alpha = 0
                        superView.removeFromSuperview()
                        if let controller = superView.next as? UIViewController {
                            controller.removeFromParent()
                        }
                    }
                }
                
                if completion != nil {
                    completion!()
                }
            }
        }
    }
    
    func findParentBaseViewController() -> BaseViewController? {
        if let parent = self.parent as? BaseViewController {
            return parent
        } else if let parent = self.parent as? UINavigationController {
            if parent.viewControllers.count > 1 {
                if let controller = parent.viewControllers.last as? BaseViewController {
                    if controller.isPopupScreenType == false {
                        return controller
                    } else if let previous = parent.viewControllers[parent.viewControllers.count-2] as? BaseViewController {
                        return previous
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                if let controller = parent.viewControllers.last as? BaseViewController {
                    return controller
                } else {
                    return nil
                }
            }
        } else if let parent = self.parent as? UITabBarController {
            if let navigation = parent.selectedViewController as? UINavigationController {
                if navigation.viewControllers.count > 1 {
                    if let controller = navigation.viewControllers.last as? BaseViewController {
                        if controller.isPopupScreenType == false {
                            return controller
                        } else if let previous = navigation.viewControllers[navigation.viewControllers.count-2] as? BaseViewController {
                            return previous
                        } else {
                            return nil
                        }
                    } else {
                        return nil
                    }
                } else {
                    if let controller = navigation.viewControllers.last as? BaseViewController {
                        return controller
                    } else {
                        return nil
                    }
                }
            } else {
                if let controller = parent.selectedViewController as? BaseViewController {
                    return controller
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    }
    
    func removeFromViewControllers(_ type: UIViewController) {
        var exists = false
        var index = 0
        for controller in (self.navigationController?.viewControllers)! {
            if controller.isKind(of: type.classForCoder) {
                exists = true
                index = (self.navigationController?.viewControllers.index(of: controller))!
            }
        }
        if exists {
            let modified = NSMutableArray(array: (self.navigationController?.viewControllers)!)
            modified.removeObject(at: index)
            self.navigationController?.viewControllers = NSArray(array: modified) as? [UIViewController] ?? []
        }
    }
    
    func addViewController(controller: UIViewController, view: UIView, parent: UIViewController) {
        parent.addChild(controller)
        view.addSubview(controller.view)
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addFullResizeConstraints(parent: view)
        // controller.view.backgroundColor = UIColor.clear
        
        controller.didMove(toParent: parent)
        parent.view.layoutIfNeeded()
    }
    
    func hideShowViewWith(viewToShow: UIView, viewShowing: UIView) {
        viewToShow.layer.transform = CATransform3DMakeScale(0.95, 0.95, 0.95)
        viewToShow.alpha = 0
        
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn, animations: {
            viewShowing.alpha = 0
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            viewShowing.layer.transform = CATransform3DMakeScale(0.92, 0.92, 0.92)
        }) { (_) in
            
        }
        
        UIView.animate(withDuration: 0.25, delay: 0.2, options: .curveEaseIn, animations: {
            viewToShow.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1.0)
            viewToShow.alpha = 1.0
        }) { (_) in
            
        }
    }
    
    func checkForGesture(_ controller: BaseViewController) {
           if controller.navBar != nil {
               if controller.navigationController != nil {
                   if controller.navBar.leftBarButtonType == ButtonType.buttonTypeBack {
                       controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                   } else {
                       controller.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                   }
               }
           }
       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
           super.motionEnded(motion, with: event)
           CustomLogger.sharedInstance.handleMotion(motion, withEvent: event, controller: self)
       }
}
