//
//  YYBaseViewController+CustomNavigationBar.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//


import UIKit


protocol BPCustomNavigationBarProtocol: NSObjectProtocol {
    
    /** 使用自定义的导航栏 */
    func useCustomNavigationBar()
    
    /** 自定义的导航栏 */
    var customNavigationBar: BPNavigationBar? { get }
    
    /** 是否为大标题 */
    var isLargeTitle: Bool { set get }
    
}


extension BPViewController: BPCustomNavigationBarProtocol {
    
    /** Runtime关联Key*/
    private struct AssociatedKeys {
        static var customeNavigationBar: String = "kCustomeNavigationBar"
        static var isLargeTitle: String = "kIsLargeTitle"
    }
    
    
    // MARK: ++++++++++ Public ++++++++++
    func useCustomNavigationBar() {
        self.view.addSubview(self.createCustomNavigationBar())
    }
    
    var customNavigationBar: BPNavigationBar? {
        return objc_getAssociatedObject(self, &AssociatedKeys.customeNavigationBar) as? BPNavigationBar
    }
    
    var isLargeTitle: Bool {
        set (newValue) {
            objc_setAssociatedObject(self, &AssociatedKeys.isLargeTitle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.isLargeTitle) as? Bool else {
                return false
            }
            return value
        }
    }
    
    
    // MARK: ++++++++++ Private ++++++++++
    private func createCustomNavigationBar() -> BPNavigationBar {
        let cnb = BPNavigationBar(largeTitle: self.isLargeTitle)
        objc_setAssociatedObject(self, &AssociatedKeys.customeNavigationBar, cnb, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return cnb
    }
    
}

extension BPCustomNavigationBarProtocol where Self: UIViewController {
    // 该扩展中的内容仅能使用在:UIViewController的子类中,且需要实现YYCustomNavigationBvarProtocol协议
    
}
