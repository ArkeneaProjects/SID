//
//  BaseTabBarControllerDelegate.swift
//
//  Created by Mahesh Agrawal on 11/17/16.
//  Copyright © 2016 Mahesh Agrawal. All rights reserved.
//

import UIKit

class BaseTabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        /*if (viewController as! UINavigationController).viewControllers.first?.isKind(of: FalseViewController.classForCoder()) == true {
            return false
        }*/
        
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView: UIView = viewController.view
        if fromView == toView {
            return false
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.2, options: .transitionCrossDissolve) { (finished: Bool) in
            
        }
        
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            
        }
    }
    
}
