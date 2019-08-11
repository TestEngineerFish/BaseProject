//
//  YYBaseViewController+CustomNavigationBar.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//


import UIKit


@objc public protocol YYCustomNavigationBarProtocol: NSObjectProtocol {
    
    /** 使用自定义的导航栏 */
    @objc optional func useCustomNavigationBar()
    
    /** 自定义的导航栏 */
    @objc optional var customNavigationBar: BPNavigationBar? { get }
    
    /** 是否为大标题 */
    @objc var isLargeTitle: Bool { set get }
    
}


extension UIViewController: YYCustomNavigationBarProtocol {
    
    /** Runtime关联Key*/
    private struct AssociatedKeys {
        static var customeNavigationBar: String = "kCustomeNavigationBar"
        static var isLargeTitle: String = "kIsLargeTitle"
    }
    
    
    // MARK: ++++++++++ Public ++++++++++
    @objc public func useCustomNavigationBar() {
        self.view.addSubview(self.createCustomNavigationBar())
    }
    
    @objc public var customNavigationBar: BPNavigationBar? {
        return objc_getAssociatedObject(self, &AssociatedKeys.customeNavigationBar) as? BPNavigationBar
    }
    
    @objc public var isLargeTitle: Bool {
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
        #if DEBUG
        // 摇一摇功能
        self.becomeFirstResponder()
        #endif
        
        let cnb = BPNavigationBar(largeTitle: self.isLargeTitle)
        objc_setAssociatedObject(self, &AssociatedKeys.customeNavigationBar, cnb, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return cnb
    }
    
}

extension YYCustomNavigationBarProtocol where Self: UIViewController {
    // 该扩展中的内容仅能使用在:UIViewController的子类中,且需要实现YYCustomNavigationBvarProtocol协议
    
}

extension UIViewController: UINavigationControllerDelegate {
    
    /** 当使用自定义导航条的时候，左滑返回会消失，因此需要实现该方法*/
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.setNavigationBarHidden(true, animated: true)
            //            self.leftButtonAction?()
        } else {
            
            //系统相册继承自 UINavigationController 这个不能隐藏
            if navigationController.isKind(of: UIImagePickerController.self) {
                return
            }
            
            //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
            let name: AnyClass? = (navigationController.delegate as? UIViewController)?.classForCoder
            if name == self.classForCoder {
                //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
                navigationController.delegate = nil
            }
        }
    }
}
