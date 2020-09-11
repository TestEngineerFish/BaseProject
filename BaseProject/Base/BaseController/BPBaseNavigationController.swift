//
//  BPBaseNavigationController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPBaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    /// 转场环境
    var transitionContext: BPContainerTransitionContext?
    /// 转场控制协议
    weak var transitionDelegate: BPContainerTransitionDelegate?
    /// 是否取消，页面回弹中
    private var shouldReserve = false
    /// 是否是交互式操作
    private var isInteractive = false
    /// 记录从哪儿过来（用户交互式操作的返回逻辑）
    private var fromIndex: Int = 0
    private var selectedIndex: Int = 0 {
        willSet {
            // 如果在回弹中，则不处理
            if self.shouldReserve {
                self.shouldReserve = false
            } else {

            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNotification()
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotAction), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    }
    
    // MARK: ==== Override ====
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    // MARK: ==== Event ====
    @objc private func screenshotAction() {
        BPLog("检测到截屏")
        _ = self.getScreenshotImage()
    }


    /// 开始页面切换
    /// - Parameters:
    ///   - fromIndex: 起始VC的索引
    ///   - toIndex: 目标VC的索引
    private func transitionVC(fromIndex: Int, toIndex: Int) {
        // 防止数组越界
        guard fromIndex != toIndex, fromIndex >= 0, toIndex >= 0, fromIndex < self.viewControllers.count, toIndex < self.viewControllers.count, let delegate = self.transitionDelegate else {
            return
        }
//        self.transitionContext = BPContainerTransitionContext(containerVC: self, containerView: <#T##UIView#>, fromVC: <#T##UIViewController#>, toVC: <#T##UIViewController#>)
    }
    
    // MARK: ==== Tools ====
    private func getScreenshotImage() -> UIImage? {
        guard let layer = UIApplication.shared.keyWindow?.layer else {
            return nil
        }
        let renderer = UIGraphicsImageRenderer(size: layer.frame.size)
        let image = renderer.image { (context: UIGraphicsImageRendererContext) in
            layer.render(in: context.cgContext)
        }
        return image
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
    
}
