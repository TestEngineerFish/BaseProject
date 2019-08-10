//
//  BPCostomTabBarController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPBaseTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addChildViewController()
        self.setCustomTabBar()
    }
    
    func setCustomTabBar() {
        let customTabBar = BPCenterTabBar()
        //利用kVC,将自定义的tabBar赋值到系统的tabBar
        self.setValue(customTabBar, forKeyPath: "tabBar")
        customTabBar.tintColor     = UIColor.red1
        customTabBar.isTranslucent = false
        customTabBar.centerButton.addTarget(self, action: #selector(showPublishView), for: .touchUpInside)
    }
    
    func addChildViewController() {
        let home = ViewController1()
        home.tabBarItem.title         = "HOME"
        home.tabBarItem.image         = UIImage(named: "home_unselect")
        home.tabBarItem.selectedImage = UIImage(named: "home_selected")
        home.tabBarItem.imageInsets   = UIEdgeInsets(top: -1.0, left: 0.0, bottom: 1.0, right: 0.0)
        self.addChild(home)
        
        let dynamic = ViewController2()
        dynamic.tabBarItem.title         = "DYNAMIC"
        dynamic.tabBarItem.image         = UIImage(named: "dynamic_unselect")
        dynamic.tabBarItem.selectedImage = UIImage(named: "dynamic_selected")
        self.addChild(dynamic)
        
        let publish = UIViewController()
        publish.tabBarItem.title         = ""
        publish.tabBarItem.image         = nil
        publish.tabBarItem.selectedImage = nil
        publish.tabBarItem.isEnabled     = false
        self.addChild(publish)
        
        let message = ViewController3()
        message.tabBarItem.title         = "MESSAGE"
        message.tabBarItem.image         = UIImage(named: "message_unselect")
        message.tabBarItem.selectedImage = UIImage(named: "message_selected")
        self.addChild(message)
        
        let profile = ViewController4()
        profile.tabBarItem.title         = "PROFILE"
        profile.tabBarItem.image         = UIImage(named: "profile_unselect")
        profile.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        self.addChild(profile)
    }

    /// 点击中间自定自定义的“+”按钮事件
    /// - parameter button: 点击的按钮
    @objc func showPublishView(button: UIButton) {
        self.view.toast("来啦.老弟")
        button.isSelected = !button.isSelected
        UIView.animate(withDuration: 0.25) {
            if button.isSelected {
                button.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
            } else {
                button.transform = CGAffineTransform.identity
            }
        }
    }
}
