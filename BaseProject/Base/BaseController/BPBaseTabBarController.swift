//
//  BPCostomTabBarController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 自定义底部TabBar控制器,实现了TabBar的事件处理协议
class BPBaseTabBarController: UITabBarController, UITabBarControllerDelegate {
    
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
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray1
        UITabBar.appearance().tintColor               = UIColor.orange1
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
        let chatVC = ViewController1()
        let chatNC = BPBaseNavigationController()
        chatNC.addChild(chatVC)
        chatNC.tabBarItem.title         = "功能"
        chatNC.tabBarItem.image         = UIImage(named: "home_unselect")
        chatNC.tabBarItem.selectedImage = UIImage(named: "home_selected")
        chatNC.tabBarItem.imageInsets   = UIEdgeInsets(top: -1.0, left: 0.0, bottom: 1.0, right: 0.0)
        self.addChild(chatNC)
        
        let interactVC = ViewController2()
        let interactNC = BPBaseNavigationController()
        interactNC.addChild(interactVC)
        interactNC.tabBarItem.title         = "互动"
        interactNC.tabBarItem.image         = UIImage(named: "dynamic_unselect")
        interactNC.tabBarItem.selectedImage = UIImage(named: "dynamic_selected")
        self.addChild(interactNC)
        
        // 仅用作占位符
        let publish = UIViewController()
        publish.tabBarItem.title         = ""
        publish.tabBarItem.image         = nil
        publish.tabBarItem.selectedImage = nil
        publish.tabBarItem.isEnabled     = false
        self.addChild(publish)
        
        let sessionVC = ViewController3()
        let sessionNC = BPBaseNavigationController()
        sessionNC.addChild(sessionVC)
        sessionNC.tabBarItem.title         = "聊天"
        sessionNC.tabBarItem.image         = UIImage(named: "message_unselect")
        sessionNC.tabBarItem.selectedImage = UIImage(named: "message_selected")
        self.addChild(sessionNC)
        
        let profileVC = ViewController3()
        let profileNC = BPBaseNavigationController()
        profileNC.addChild(profileVC)
        profileNC.tabBarItem.title         = "我的"
        profileNC.tabBarItem.image         = UIImage(named: "profile_unselect")
        profileNC.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        self.addChild(profileNC)
    }

    /// 点击中间自定自定义的“+”按钮事件
    /// - parameter button: 点击的按钮
    @objc func showPublishView() {
        let vc = BPPubilshViewController()
        UIViewController.currentNavigationController?.present(vc, animated: true, completion: nil)
    }
}
