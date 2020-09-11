//
//  BPInteractiveTransition.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/9/10.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

/// 转场代理
class BPInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning {

    weak var containerTransitionContext: BPContainerTransitionContext?

    /// 更新转场进度百分比
    /// - Parameter percentComplete: 转场进度百分比
    func updateInteractiveTransition(percentComplete: CGFloat) {
        containerTransitionContext?.updateInteractiveTransition(percentComplete)
    }

    /// 取消转场动画
    func cancelInteractiveTransition() {
        containerTransitionContext?.cancelInteractiveTransition()
    }

    /// 转场动画结束
    func finishInteractiveTransition() {
        containerTransitionContext?.finishInteractiveTransition()
    }

    // MARK: ==== UIViewControllerInteractiveTransitioning ====

    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let context = transitionContext as? BPContainerTransitionContext else {
            BPLog("\(transitionContext) is not class or subclass of BPContainerTransitionContext")
            return
        }
        containerTransitionContext = context
        containerTransitionContext?.activateInteractiveTransition()
    }


}
