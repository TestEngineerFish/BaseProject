//
//  BPBaseNavigationController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPBaseNavigationController: UINavigationController, UIGestureRecognizerDelegate, BPContainerTransitionDelegate {
    /// 转场环境
    var transitionContext: BPContainerTransitionContext?
    /// 是否取消，页面回弹中
    private var shouldReserve = false
    /// 是否是交互式操作
    private var isInteractive = false

    /// 记录从哪儿过来（用户交互式操作的返回逻辑）
    private var fromIndex: Int = 0
    var selectedIndex: Int = 0 {
        willSet {
            // 如果在回弹中，则不处理
            if self.shouldReserve {
                self.shouldReserve = false
            } else {
                self.transitionVC(fromIndex: selectedIndex, toIndex: newValue)
            }
        }
    }

//    private var containerView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.backgroundColor = UIColor.red
//        view.isOpaque = true
//        return view
//    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.interactivePopGestureRecognizer?.delegate = self
    }

    private func createSubviews() {
//        self.view.addSubview(containerView)
//        containerView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
    }

    private func bindProperty() {
        let panGresture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.view.addGestureRecognizer(panGresture)
//        self.view.sendSubviewToBack(self.containerView)
    }
    
    // MARK: ==== Override ====
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: ==== Event ====
    /// 开始页面切换
    /// - Parameters:
    ///   - fromIndex: 起始VC的索引
    ///   - toIndex: 目标VC的索引
    private func transitionVC(fromIndex: Int, toIndex: Int) {
        // 防止数组越界
        guard fromIndex != toIndex, fromIndex >= 0, toIndex >= 0, fromIndex < self.viewControllers.count, toIndex < self.viewControllers.count else {
            return
        }

        let fromVC = self.viewControllers[fromIndex]
        let toVC   = self.viewControllers[toIndex]

        // 初始化转场环境
        self.transitionContext = BPContainerTransitionContext(containerVC: self, containerView: self.view, fromVC: fromVC, toVC: toVC)

        // 是否是交互式场景
        if self.isInteractive {
            self.transitionContext?.startInteractiveTranstion(delegate: self)
        } else {
            self.transitionContext?.startNonInteractiveTransition(delegate: self)
        }

        // 记录下当前初始下标
        self.fromIndex = fromIndex
    }

    /// 处理滑动手势
    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard !self.viewControllers.isEmpty else {
            return
        }

        let translationX   = gesture.translation(in: view).x
        let translationAbs = translationX > 0 ? translationX : -translationX
        let progress       = translationAbs / view.width

        switch gesture.state {
        case .began:
            print("VC List: \(self.navigationController?.viewControllers)")
            self.isInteractive = true
            let velocityX      = gesture.velocity(in: view).x

            if velocityX < 0 {
                // 往左滑动⬅️
                if self.selectedIndex < self.viewControllers.count - 1 {
                    self.selectedIndex += 1
                }
            } else {
                // 往右滑动➡️
                if self.selectedIndex > 0 {
                    self.selectedIndex -= 1
                }
            }
        case .changed:
            print("From:\(self.fromIndex), To:\(self.selectedIndex)")
            self.interactionController.updateInteractiveTransition(percentComplete: progress)
        case .cancelled, .ended:
            self.isInteractive = false
            if progress > 0.4 {
                self.interactionController.finishInteractiveTransition()
            } else {
                self.interactionController.cancelInteractiveTransition()
            }
        default:
            break
        }
    }

    /// 取消转场
    func restoreSelectedIndex() {
        self.shouldReserve = true
        self.selectedIndex = self.fromIndex
    }

    // MARK: ==== UIGestureRecognizerDelegate ====
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers.first {
                return false
            }
        }
        //        // 特殊VC，不支持侧滑返回
        //        let specialVCList = []
        //        if specialVCList.contains(where: { (classType) -> Bool in
        //            self.topViewController?.classForCoder == .some(classType)
        //        }) {
        //            return false
        //        }
        return true
    }

    // MARK: ==== BPContainerTransitionDelegate ====
    var interactionController = BPInteractiveTransition()

    func containerController(containerVC: UIViewController, fromVC: UIViewController, toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let fromIndex = self.viewControllers.firstIndex(of: fromVC), let toIndex = self.viewControllers.firstIndex(of: toVC) else {
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
