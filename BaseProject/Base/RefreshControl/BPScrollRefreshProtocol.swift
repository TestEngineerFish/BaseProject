//
//  BPScrollRefreshProtocol.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

protocol BPScrollRefreshProtocol {
    /// 支持刷新功能的ScrollView
    var refreshCompomentScrollView: UIScrollView? { get set }
    /// 获取顶部刷新的控制器视图
    var headerRefreshView: BPBaseRefreshControl? {get}
    /// 获取底部刷新的控制器视图
    var footerRefreshView: BPBaseRefreshControl? {get}
    
    /// 下拉Header中
    /// - Parameter offsetY: 偏移量Y
    func pullingHeader(offsetY: CGFloat)
    /// 下拉Header超过最大长度
    /// - Parameter offsetY: 偏移量Y
    func pullMaxHeader(offsetY: CGFloat)
    /// 下拉Header结束
    /// - Parameter isRefresh: 是否触发刷新
    func pullEndHeader(isRefresh: Bool)
    /// 上拉Footer中
    /// - Parameter offsetY: 偏移量Y
    func pullingFooter(offsetY: CGFloat)
    /// 上拉Footer超过最大长度
    /// - Parameter offsetY: 偏移量Y
    func pullMaxFooter(offsetY: CGFloat)
    /// 上拉Footer结束
    /// - Parameter isRefresh: 是否触发加载更多
    func pullEndFooter(isRefresh: Bool)
    
}

private struct AssociatedKeys {
    static var refreshCompomentScrollView = "kRefreshCompomentScrollView"
    static var headerRefreshView          = "kHeaderRefreshView"
    static var footerRefreshView          = "kFooterRefreshView"
}

extension BPScrollRefreshProtocol {
    /// 刷新功能的ScrollView的存取
    var refreshCompomentScrollView: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshCompomentScrollView) as? UIScrollView
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshCompomentScrollView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// 顶部刷新的控制器视图的存取
    var headerRefreshView: BPBaseRefreshControl? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.headerRefreshView) as? BPBaseRefreshControl
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKeys.headerRefreshView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.refreshCompomentScrollView?.refreshControl = newValue
        }
    }

    /// 底部刷新的控制器视图的存取
    var footerRefreshView: BPBaseRefreshControl? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.footerRefreshView) as? BPBaseRefreshControl
        }

        set {
            objc_setAssociatedObject(self, &AssociatedKeys.footerRefreshView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.refreshCompomentScrollView?.refreshControl = newValue
        }
    }

    /// 下拉刷新

}

