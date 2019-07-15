//
//  UIViewController+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    public func findViewController<T: UIViewController>(with targetViewControllerClass: T.Type, offset: Int = 0) -> UIViewController? {
        
        var targetViewController: UIViewController?
        
        let viewControllers: [UIViewController] = self.viewControllers
        if viewControllers.count == 0 {
            return targetViewController
        }
        
        for (index, viewController) in viewControllers.enumerated() where viewController.classForCoder == targetViewControllerClass {
            var targetIndex: Int = index
            if offset > 0 {
                targetIndex = targetIndex + offset
            }else if offset < 0 {
                targetIndex = targetIndex - abs(offset)
            }
            
            if targetIndex >= viewControllers.count || targetIndex < 0 {
                break
            }
            
            targetViewController = viewControllers[targetIndex]
            break
        }
        
        return targetViewController
    }
}

// MARK: - 获取当前显示的ViewController
extension UIViewController {
    
    public func findViewController<T: UIViewController>(with targetViewControllerClass: T.Type) -> T? {
        var currentResponder: UIResponder? = self.next
        while currentResponder != nil {
            if currentResponder?.classForCoder == targetViewControllerClass {
                return (currentResponder as? T)
            }
            currentResponder = currentResponder?.next
        }
        
        return nil
    }
    
    @objc public static var currentNavgationController: UINavigationController? {
        let currentVController: UIViewController? = self.currentViewController
        var navgationController: UINavigationController? = currentVController?.navigationController
        var currentResponder: UIResponder? = currentVController?.next
        while navgationController == nil && currentResponder != nil {
            if let _navigationController = (currentResponder as? UIViewController)?.navigationController {
                navgationController = _navigationController
            }else{
                currentResponder = currentResponder?.next
            }
        }
        
        return navgationController
    }
    
    @objc public static var currentViewController: UIViewController? {
        var rootViewController: UIViewController?
        let textEffectsWindowClass: AnyClass? = NSClassFromString("UITextEffectsWindow")
        for window in UIApplication.shared.windows where !window.isHidden {
            if let _textEffectsWindowClass = textEffectsWindowClass, window.isKind(of: _textEffectsWindowClass) { continue }
            if let windowRootViewController = window.rootViewController {
                rootViewController = windowRootViewController
                break
            }
        }
        
        return self.topMost(of: rootViewController)
    }
    
    @objc private static func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        
        return viewController
    }
}
