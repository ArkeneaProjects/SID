//
//  BaseViewController.swift
//  YupEasy
//
//  Created by Pankaj on 11/11/19.
//  Copyright © 2019 Kethan. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate, SWRevealViewControllerDelegate, UINavigationControllerDelegate {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // check RevelView initialize
        if self.revealViewController() != nil {
            if self.navigationController != nil {
                if self.navigationController?.viewControllers.count == 1 {
                    let reveal: SWRevealViewController = self.revealViewController()
                    reveal.panGestureRecognizer()
                    reveal.tapGestureRecognizer()
                    self.revealViewController().delegate = self
                    self.revealViewController()?.rearViewRevealWidth = getCalculated(270.0)
                }
            }
        }
        
        //Navigation Controller initialize
        if self.navigationController != nil {
            self.navigationController?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.revealViewController() != nil {
            if self.navigationController?.viewControllers.first?.isKind(of: self.classForCoder) == false {
                self.revealViewController().panGestureRecognizer().isEnabled = false
            }
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
    func navigateToHome(_ withLoggedIn: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            //Display screen accroding to user login
            if withLoggedIn == true {
                let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
                if let yourVc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                    self.setAsRootScreen(yourVc)
                }
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
                
                let search = self.instantiateNav("SearchViewController", storyboard: "Main" )
                search.tabBarItem = self.getTabBarButtonWithTitle(title: "", imageName: "tab1_deactive", selectedImageName: "tab1_active")
                
                let home = self.instantiateNav("HomeViewController", storyboard: "Main")
                home.tabBarItem = self.getTabBarButtonWithTitle(title: "", imageName: "tab2_deactive", selectedImageName: "tab2_active")
                
                let upload = self.instantiateNav("UploadViewController", storyboard: "Main")
                upload.tabBarItem = self.getTabBarButtonWithTitle(title: "", imageName: "tab3_deactive", selectedImageName: "tab3_active")
                
                let purchase = self.instantiateNav("PurchesViewController", storyboard: "Main")
                purchase.tabBarItem = self.getTabBarButtonWithTitle(title: "", imageName: "tab4_deactive", selectedImageName: "tab4_active")
                
                tabBarViewController.viewControllers = [search, home, upload, purchase]
                tabBarViewController.delegate = AppDelegate.delegate()?.tabBarDelegate
                
                self.setAsRootScreen(tabBarViewController)
                tabBarViewController.selectedIndex = 1
                AppDelegate.delegate()?.tabBarController = tabBarViewController
            }
        }
        
    }
    
    func getTabBarButtonWithTitle(title: String?, imageName: String, selectedImageName: String?) -> UITabBarItem {
        let tabBarItem = UITabBarItem(title: title, image: UIImage(named: imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal), selectedImage: ((selectedImageName != nil) ?UIImage(named: selectedImageName!)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal):nil))
        return tabBarItem
    }
    
    // MARK: - Instantiate Navigation Controller
    func instantiateNav(_ identifier: String, storyboard: String) -> UINavigationController {
        let storyboard: UIStoryboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        let controller = (storyboard.instantiateViewController(withIdentifier: identifier)) as? BaseViewController ?? BaseViewController()
        if identifier == "HomeViewController" {
            let sideMenuController: LeftMenuViewController = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as? LeftMenuViewController ?? LeftMenuViewController()
            
            let rearNavigationController: UINavigationController = UINavigationController(rootViewController: sideMenuController)
            rearNavigationController.navigationItem.hidesBackButton = true
            rearNavigationController.isNavigationBarHidden = true
            
            let frontNavigationController: UINavigationController = UINavigationController(rootViewController: controller)
            frontNavigationController.navigationItem.hidesBackButton = true
            frontNavigationController.isNavigationBarHidden = true
            
            controller.revealViewController = SWRevealViewController(rearViewController: rearNavigationController, frontViewController: frontNavigationController)
        }
        let navigation = UINavigationController(rootViewController: (identifier == "HomeViewController") ?controller.revealViewController():controller)
        navigation.restorationIdentifier = String(format: "Nav_%@", identifier)
        navigation.isNavigationBarHidden = true
        return navigation
    }
    
    func setAsRootScreen(_ controller: UIViewController) {
        // AppDelegate.delegate()!.window?.setWindowRootViewController(rootController: controller)
        AppDelegate.delegate()?.window?.rootViewController = controller
        AppDelegate.delegate()?.window?.makeKeyAndVisible()
        
    }
}
