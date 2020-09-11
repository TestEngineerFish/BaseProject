//
//  BPContainerTransitionDelegate.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/9/10.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPContainerTransitionDelegate: NSObjectProtocol {
    /// 获得转场方式
    /// - Parameters:
    ///   - containerVC: 容器视图
    func containerController(containerVC: UIViewController, fromVC: UIViewController, toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
    func containerController(containerVC: UIViewController, animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning?
}

class BPContainerViewControllerDelegate: NSObject, BPContainerTransitionDelegate {

    var interactionController = BPInteractiveTransition()

    func containerController(containerVC: UIViewController, fromVC: UIViewController, toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let fromIndex = (containerVC as? ViewController2)?.vcList.firstIndex(of: fromVC), let toIndex = (containerVC as? ViewController2)?.vcList.firstIndex(of: toVC) else {
            return nil
        }
        if fromIndex > toIndex {
            return BPAnimationController(type: .naviationTransition(.pop))
        } else {
            return BPAnimationController(type: .naviationTransition(.push))
        }
    }

    func containerController(containerVC: UIViewController, animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactionController
    }


}
