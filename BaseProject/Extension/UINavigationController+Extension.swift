//
//  UINavigationController+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/4.
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
        // 为什么要offset???
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

    func push(vc: UIViewController, animation: Bool = true) {
        self.addChild(vc)
        if self.children.count > 1 {
            self.tabBarController?.tabBar.isHidden = true
        }
        (self as? BPBaseNavigationController)?.selectedIndex += 1
    }

    func pop(animation: Bool = true) {
        (self as? BPBaseNavigationController)?.selectedIndex -= 1
        if self.children.count <= 2 {
            self.tabBarController?.tabBar.isHidden = false
        }
    }
}
