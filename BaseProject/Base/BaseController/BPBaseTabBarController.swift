//
//  BPCostomTabBarController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// TabBar的事件处理协议
protocol BPTabBarControllerProtocol {
    /// 发布View的滑动进度事件,用于同步底部按钮的旋转角度
    /// - parameter progress: 滑动进度
    func publishViewOffset(_ progress: CGFloat)
}

/// 自定义底部TabBar控制器,实现了TabBar的事件处理协议
class BPBaseTabBarController: UITabBarController, UITabBarControllerDelegate, BPTabBarControllerProtocol {
    
    /// 发布页面
    lazy var publisView: PublishView = {
        let height    = kScreenHeight - kTabBarHeight
        let view      = PublishView()
        view.frame    = CGRect(x: 0, y: 0, width: kScreenWidth, height: height)
        view.isHidden = true
        view.delegate = self
        return view
    }()
    
    /// 自定义TabBar
    let customTabBar: BPCenterTabBar = {
        let tabBar           = BPCenterTabBar()
        tabBar.isTranslucent = false
        return tabBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.addChildViewController()
        self.setCustomTabBar()
    }
    
    /// 设置自定义的TabBar
    func setCustomTabBar() {
        // 利用kVC,将自定义的tabBar赋值到系统的tabBar
        self.setValue(customTabBar, forKeyPath: "tabBar")
        // 添加点击事件
        let tap = UITapGestureRecognizer(target: self, action: #selector(showPublishView))
        customTabBar.buttonBgView.addGestureRecognizer(tap)
    }
    
    /// 设置底部TabBarItem
    func addChildViewController() {
        let vc = ViewController1()
        let home = BPBaseNavigationController(rootViewController: vc)
        home.tabBarItem.title         = "HOME"
        home.tabBarItem.image         = UIImage(named: "home_unselect")
        home.tabBarItem.selectedImage = UIImage(named: "home_selected")
        home.tabBarItem.imageInsets   = UIEdgeInsets(top: -1.0, left: 0.0, bottom: 1.0, right: 0.0)
        self.addChild(home)
        
        let dynamicVC = ViewController2()
        let dynamic = BPBaseNavigationController(rootViewController: dynamicVC)
        dynamic.tabBarItem.title         = "DYNAMIC"
        dynamic.tabBarItem.image         = UIImage(named: "dynamic_unselect")
        dynamic.tabBarItem.selectedImage = UIImage(named: "dynamic_selected")

        self.addChild(dynamic)
        
        // 仅用作占位符
        let publish = UIViewController()
        publish.tabBarItem.title         = ""
        publish.tabBarItem.image         = nil
        publish.tabBarItem.selectedImage = nil
        publish.tabBarItem.isEnabled     = false
        self.addChild(publish)
        
        let messageVC = ViewController3()
        let message = BPBaseNavigationController(rootViewController: messageVC)
        message.tabBarItem.title         = "MESSAGE"
        message.tabBarItem.image         = UIImage(named: "message_unselect")
        message.tabBarItem.selectedImage = UIImage(named: "message_selected")
        self.addChild(message)
        
        let profileVC = ViewController4()
        let profile = BPBaseNavigationController(rootViewController: profileVC)
        profile.tabBarItem.title         = "PROFILE"
        profile.tabBarItem.image         = UIImage(named: "profile_unselect")
        profile.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        self.addChild(profile)
    }

    /// 点击中间自定自定义的“+”按钮事件
    /// - parameter button: 点击的按钮
    @objc func showPublishView() {
        if self.publisView.isHidden {
            // 显示按钮动画
            self.selectedViewController?.view.addSubview(self.publisView)
            // 显示发布页面(自下而上出现)
            self.publisView.showView()
        } else {
            // 恢复按钮动画
            self.publisView.hideView()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        // 隐藏发布页面
        self.publisView.hideView()
        return true
    }
    
    
    // - MARK: BPTabBarControllerProtocol
    func publishViewOffset(_ progress: CGFloat) {
        let angle      = CGFloat.pi/4 * progress
        let alphaColor = 0.3 * progress
        self.customTabBar.publishLabel.transform  = CGAffineTransform(rotationAngle: angle)
        self.publisView.backgroundView.backgroundColor         = UIColor.black.withAlphaComponent(alphaColor)
    }
}
