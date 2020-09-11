//
//  ViewController2.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController2: BPViewController, UINavigationControllerDelegate {

    weak var containerTransitionDelegate: BPContainerTransitionDelegate?
    var vcList = [UIViewController]()
    var containerTransitionContext: BPContainerTransitionContext?
    private var tabBarItemSize = CGSize(width: AdaptSize(64), height: AdaptSize(44))
    private var shouldReserve  = false
    private var interactive    = false
    private var priorSelectedIndex = 0
    private var selectedIndex: Int = 0 {
        willSet {
            if shouldReserve {
                self.shouldReserve = false
            } else {
                self.transitionVC(fromIndex: selectedIndex, toIndex: newValue)
            }
        }
    }

    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        view.isOpaque = true
        return view
    }()
    var buttonTabBar: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.tintColor = UIColor.white.withAlphaComponent(0.75)
        view.translatesAutoresizingMaskIntoConstraints = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindData()
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(containerView)
        self.view.addSubview(buttonTabBar)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        let barWidth = tabBarItemSize.width * CGFloat(vcList.count)
        buttonTabBar.snp.makeConstraints { (make) in
            make.width.equalTo(barWidth)
            make.height.equalTo(tabBarItemSize.height)
            make.top.equalToSuperview().offset(AdaptSize(100) + kNavHeight)
            make.centerX.equalToSuperview()
        }
        // 设置TabBar
        for (index, vc) in vcList.enumerated() {
            let button: UIButton = {
                let button = UIButton()
                button.tag = index
                button.setTitle(vc.title, for: .normal)
                button.titleLabel?.font = UIFont.mediumFont(ofSize: AdaptSize(16))
                return button
            }()
            buttonTabBar.addSubview(button)
            button.addTarget(self, action: #selector(self.tapTabBarAction(btn:)), for: .touchUpInside)
            let offsetX = AdaptSize(CGFloat(index) * tabBarItemSize.width)
            button.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(offsetX)
                make.centerY.equalToSuperview()
                make.size.equalTo(tabBarItemSize)
            }
        }
        // 设置VC
        if self.selectedIndex < self.vcList.count {
            let currentVC = self.vcList[self.selectedIndex]
            self.addChild(currentVC)
            self.containerView.addSubview(currentVC.view)
            currentVC.didMove(toParent: self)
            self.changeTabBarAt(selectedIndex: self.selectedIndex)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.isHidden = true
        let panGresture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        self.view.addGestureRecognizer(panGresture)
    }

    override func bindData() {
        super.bindData()
        self.vcList.removeAll()
        let titleList = ["Ada", "Sam", "Jennifer"]
        for title in titleList {
            let vc = UIViewController()
            vc.title = title
            vc.view.backgroundColor = UIColor.randomColor()
            self.vcList.append(vc)
        }
    }

    // MARK: ==== Event ====

    @objc
    private func tapTabBarAction(btn: UIButton) {
        self.selectedIndex = btn.tag
    }

    /// 处理VC切换逻辑
    private func transitionVC(fromIndex: Int, toIndex: Int) {
        guard fromIndex != toIndex, fromIndex >= 0, toIndex >= 0, fromIndex < self.vcList.count, toIndex < self.vcList.count else {
            return
        }
        if self.containerTransitionDelegate != nil {
            self.buttonTabBar.isUserInteractionEnabled = false
            let fromVC = self.vcList[fromIndex]
            let toVC   = self.vcList[toIndex]
            self.containerTransitionContext = BPContainerTransitionContext(containerVC: self, containerView: self.containerView, fromVC: fromVC, toVC: toVC)
            self.containerTransitionContext?.finishedBlock = { [weak buttonTabBar] in
                buttonTabBar?.isUserInteractionEnabled = true
            }
            if self.interactive {
                self.priorSelectedIndex = fromIndex
                self.containerTransitionContext?.startInteractiveTranstion(delegate: self.containerTransitionDelegate!)
            } else {
                self.containerTransitionContext?.startNonInteractiveTransition(delegate: self.containerTransitionDelegate!)
                self.changeTabBarAt(selectedIndex: toIndex)
            }
            
        } else {
            let selectedVC = self.vcList[fromIndex]
            selectedVC.willMove(toParent: nil)
            selectedVC.view.removeFromSuperview()
            selectedVC.removeFromParent()

            let newSelectedVC = self.vcList[toIndex]
            addChild(newSelectedVC)
            self.containerView.addSubview(newSelectedVC.view)
            newSelectedVC.didMove(toParent: self)

            self.changeTabBarAt(selectedIndex: toIndex)
        }
    }
    private func changeTabBarAt(selectedIndex: Int) {
        for (index, item) in buttonTabBar.subviews.enumerated() {
            guard let button = item as? UIButton else {
                continue
            }
            if index == selectedIndex {
                button.setTitleColor(.red, for: .normal)
            } else {
                button.setTitleColor(.white, for: .normal)
            }
        }
    }

    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard !self.vcList.isEmpty, let delegate = self.containerTransitionDelegate as? BPContainerViewControllerDelegate else {
            return
        }
        let translationX   = gesture.translation(in: view).x
        let translationAbs = translationX > 0 ? translationX : -translationX
        let progress       = translationAbs / view.frame.width
        switch gesture.state {
        case .began:
            self.interactive = true
            let velocityX = gesture.velocity(in: view).x
            if velocityX < 0 {
                if selectedIndex < self.vcList.count - 1 {
                    self.selectedIndex += 1
                }
            } else {
                if self.selectedIndex > 0 {
                    self.selectedIndex -= 1
                }
            }
        case .changed:
            BPLog("Progress:\(progress)")
            BPLog("Selected index: \(selectedIndex)")
            delegate.interactionController.updateInteractiveTransition(percentComplete: progress)
        case .cancelled, .ended:
            self.interactive = false
            if progress > 0.6 {
                BPLog("interactive finished")
                delegate.interactionController.finishInteractiveTransition()
            } else {
                BPLog("interactive cancel")
                delegate.interactionController.cancelInteractiveTransition()
            }
        default:
            break
        }
    }

    /// 手动滑动页面，设置按钮文案的渐变颜色
    func graduallChangeTabButtonAppear(fromIndex: Int, toIndex: Int, percent: CGFloat) {
        guard fromIndex < self.buttonTabBar.subviews.count, toIndex < self.buttonTabBar.subviews.count, let fromItem = self.buttonTabBar.subviews[fromIndex] as? UIButton, let toItem = self.buttonTabBar.subviews[toIndex] as? UIButton else {
            return
        }
        let fromItemColor = UIColor(displayP3Red: 1, green: percent, blue: percent, alpha: 1)
        let toItemColor   = UIColor(displayP3Red: 1, green: 1 - percent, blue: 1 - percent, alpha: 1)
        fromItem.setTitleColor(fromItemColor, for: .normal)
        toItem.setTitleColor(toItemColor, for: .normal)
    }

    func restoreSelectedIndex() {
        self.shouldReserve = true
        self.selectedIndex = self.priorSelectedIndex
    }
}
