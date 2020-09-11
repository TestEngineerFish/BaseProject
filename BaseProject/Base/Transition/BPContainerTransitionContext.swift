//
//  BPContainerTransitionContext.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/9/10.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

/// 转场环境
class BPContainerTransitionContext: NSObject, UIViewControllerContextTransitioning {

    // TODO: ---- Custom ----
    private var fromVC: UIViewController
    private var toVC: UIViewController
    private var fromIndex = 0
    private var toIndex   = 0
    private var containerVC: UIViewController
    private var animationController: UIViewControllerAnimatedTransitioning?
    private var transitionDuration: CFTimeInterval = .zero
    private var transitonPercent: CGFloat = .zero
    private var isCancelled: Bool = false
    var finishedBlock: (()->Void)?

    init(containerVC: UIViewController, containerView: UIView, fromVC: UIViewController, toVC: UIViewController) {
        self.containerVC   = containerVC
        self.containerView = containerView
        self.fromVC        = fromVC
        self.toVC          = toVC
        super.init()
        self.toVC.view.frame = containerView.bounds
        if let vc = containerVC as? ViewController2 {
            self.fromIndex = vc.vcList.firstIndex(of: fromVC) ?? 0
            self.toIndex   = vc.vcList.firstIndex(of: toVC) ?? 0
        }
    }

    /// 开始交互式转场
    func startInteractiveTranstion(delegate: BPContainerTransitionDelegate) {
        // 获得转场动画控制器
        self.animationController = delegate.containerController(containerVC: self.containerVC, fromVC: self.fromVC, toVC: self.toVC)
        // 获得动画持续时间
        self.transitionDuration  = self.animationController?.transitionDuration(using: self) ?? 0
        // 获得转场代理
        if let interactionController = delegate.containerController(containerVC: containerVC, animationController: animationController!) {
            interactionController.startInteractiveTransition(self)
        } else {
            fatalError("Need for interaction controller for interactive transition.")
        }
    }

    /// 开始非交互式转场
    func startNonInteractiveTransition(delegate: BPContainerTransitionDelegate) {
        // 获得转场动画控制器
        self.animationController = delegate.containerController(containerVC: self.containerVC, fromVC: self.fromVC, toVC: self.toVC)
        // 获得动画持续时间
        self.transitionDuration  = self.animationController?.transitionDuration(using: self) ?? 0
        self.activateNonInteractiveTransition()
    }

    func activateInteractiveTransition() {
        self.isInteractive = true
        self.isCancelled   = false
        self.containerVC.addChild(toVC)
        self.containerView.layer.speed = 0
        self.animationController?.animateTransition(using: self)
    }

    /// 取消转场时的回弹动画
    @objc
    private func reverseAnimation(displayLink: CADisplayLink) {
        let timeOffset = self.containerView.layer.timeOffset - displayLink.duration
        if timeOffset > 0 {
            self.containerView.layer.timeOffset = timeOffset
            self.transitonPercent = CGFloat(timeOffset / self.transitionDuration)
            (self.containerVC as? ViewController2)?.graduallChangeTabButtonAppear(fromIndex: fromIndex, toIndex: toIndex, percent: self.transitonPercent)
        } else {
            displayLink.invalidate()
            self.containerView.layer.timeOffset = 0
            self.containerView.layer.speed      = 1
            (self.containerVC as? ViewController2)?.graduallChangeTabButtonAppear(fromIndex: fromIndex, toIndex: toIndex, percent: 0)
            let fakeFromView = self.fromVC.view.snapshotView(afterScreenUpdates: true)
            self.containerView.addSubview(fakeFromView!)
            self.perform(#selector(self.removeFakeFromView(fakeView:)), with: fakeFromView, afterDelay: 1/60)
        }
    }

    @objc
    private func removeFakeFromView(fakeView: UIView) {
        fakeView.removeFromSuperview()
    }

    @objc
    private func finishChangeItemAppear(displayLine: CADisplayLink) {
        let percentFrame = 1 / (transitionDuration * 60)
        self.transitonPercent += CGFloat(percentFrame)
        if self.transitonPercent < 1.0 {
            (self.containerVC as? ViewController2)?.graduallChangeTabButtonAppear(fromIndex: fromIndex, toIndex: toIndex, percent: self.transitonPercent)
        } else {
            (self.containerVC as? ViewController2)?.graduallChangeTabButtonAppear(fromIndex: fromIndex, toIndex: toIndex, percent: 1)
            displayLine.invalidate()
        }
    }

    @objc
    private func fixBeginTimeBug() {
        self.containerView.layer.beginTime = 0.0
    }

    // MARK: ==== Tools ====
    private func activateNonInteractiveTransition() {
        self.isInteractive = false
        self.isCancelled   = false
        self.containerVC.addChild(self.toVC)
        self.animationController?.animateTransition(using: self)
    }

    private func transitionEnd() {
        self.animationController?.animationEnded?(!self.isCancelled)
        if isCancelled {
            (self.containerVC as? ViewController2)?.restoreSelectedIndex()
            self.isCancelled = false
        }
        (self.containerVC as? ViewController2)?.containerTransitionContext = nil
        (self.containerVC as? ViewController2)?.buttonTabBar.isUserInteractionEnabled = true
        self.finishedBlock?()
    }

    // MARK: ==== UIViewControllerContextTransitioning ====
    var containerView: UIView

    var isAnimated: Bool {
        return animationController != nil
    }

    var isInteractive: Bool = false

    var transitionWasCancelled: Bool {
        return self.isCancelled
    }

    var targetTransform: CGAffineTransform {
        return .identity
    }

    var presentationStyle: UIModalPresentationStyle {
        return .custom
    }

    /// 更新百分比
    func updateInteractiveTransition(_ percent: CGFloat) {
        guard self.animationController != nil && self.isInteractive else {
            return
        }
        self.transitonPercent = percent
        self.containerView.layer.timeOffset = CFTimeInterval(percent) * self.transitionDuration
        (self.containerVC as? ViewController2)?.graduallChangeTabButtonAppear(fromIndex: fromIndex, toIndex: toIndex, percent: percent)
    }

    /// 用户交互转场完成
    func finishInteractiveTransition() {
        self.isInteractive = true
        let pausedTime     = self.containerView.layer.timeOffset
        self.containerView.layer.speed      = 1.0
        self.containerView.layer.timeOffset = 0.0
        self.containerView.layer.beginTime  = 0.0

        let timeSincePause = self.containerView.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        self.containerView.layer.beginTime = timeSincePause
        let displayLink = CADisplayLink(target: self, selector: #selector(self.finishChangeItemAppear(displayLine:)))
        displayLink.add(to: .main, forMode: .default)

        let remainingTime = CFTimeInterval(1 - self.transitonPercent) * self.transitionDuration
        self.perform(#selector(self.fixBeginTimeBug), with: nil, afterDelay: remainingTime)
    }

    /// 取消转场
    func cancelInteractiveTransition() {
        self.isInteractive = false
        self.isCancelled   = true
        let displayLink = CADisplayLink(target: self, selector: #selector(BPContainerTransitionContext.reverseAnimation(displayLink:)))
        displayLink.add(to: .main, forMode: .default)
    }

    /// 暂停转场动画
    func pauseInteractiveTransition() {

    }

    /// 转场完成
    func completeTransition(_ didComplete: Bool) {
        if didComplete {
            self.toVC.didMove(toParent: containerVC)
            self.fromVC.willMove(toParent: nil)
            self.fromVC.view.removeFromSuperview()
            self.fromVC.removeFromParent()
        } else {
            self.toVC.didMove(toParent: containerVC)
            self.toVC.willMove(toParent: nil)
            self.toVC.view.removeFromSuperview()
            self.toVC.removeFromParent()
        }
        self.transitionEnd()
    }

    func viewController(forKey key: UITransitionContextViewControllerKey) -> UIViewController? {
        switch key {
        case .from:
            return self.fromVC
        case .to:
            return self.toVC
        default:
            return nil
        }
    }

    func view(forKey key: UITransitionContextViewKey) -> UIView? {
        switch key {
        case .from:
            return self.fromVC.view
        case .to:
            return self.toVC.view
        default:
            return nil
        }
    }

    func initialFrame(for vc: UIViewController) -> CGRect {
        return vc.view.frame
    }

    func finalFrame(for vc: UIViewController) -> CGRect {
        return vc.view.frame
    }
}
