//
//  BPAnimationController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/9/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

enum BPTransitionType {
    case naviationTransition(UINavigationController.Operation)
    case tabTransition(TabOperationDirection)
    case modalTransition(ModalOperation)
}

enum TabOperationDirection {
    case toRight
    case toLeft
}
enum ModalOperation {
    case presentation
    case dismissal
}

/// 转场动画控制器
class BPAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    var transitionType: BPTransitionType

    init(type: BPTransitionType) {
        self.transitionType = type
        super.init()
    }

    // MARK: ==== UIViewControllerAnimatedTransitioning ====

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 获得转场控制容器
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from), let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        let fromView = fromVC.view
        let toView   = toVC.view
        
        // 设置偏移量
        var translation       = containerView.width
        var fromViewTransform = CGAffineTransform.identity
        var toViewTransform   = CGAffineTransform.identity

        switch transitionType {
        case .naviationTransition(let type):
            translation       = type == .push ? translation : -translation
            fromViewTransform = CGAffineTransform(translationX: -translation, y: 0)
            toViewTransform   = CGAffineTransform(translationX: translation, y: 0)
        case .tabTransition(let type):
            translation       = type == .toRight ? translation : -translation
            fromViewTransform = CGAffineTransform(translationX: -translation, y: 0)
            toViewTransform   = CGAffineTransform(translationX: translation, y: 0)
        case .modalTransition(let type):
            translation       = type == .presentation ? containerView.height : 0
            fromViewTransform = CGAffineTransform(translationX: 0, y: 0)
            toViewTransform   = CGAffineTransform(translationX: 0, y: translation)
        }

        // 将目标视图添加到控制容器中
        switch transitionType {
        case .modalTransition(let type):
            if type == .dismissal {
                break
            } else {
                containerView.addSubview(toView!)
            }
        default:
            containerView.addSubview(toView!)
        }

        // 设置动画
        toView?.transform = toViewTransform
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromView?.transform = fromViewTransform
            toView?.transform   = .identity
        }) { (finished) in
            fromView?.transform = .identity
            toView?.transform   = .identity
            // 转场完成
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
