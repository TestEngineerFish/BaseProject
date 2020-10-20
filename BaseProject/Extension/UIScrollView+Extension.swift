//
//  UIScrollView+Extension.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/20.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

enum BPRefreshStatus: Int {
    // 下拉滑动中
    case headerPulling
    // 下拉滑动超过阈值
    case headerPullMax
    // 下拉滑动停止
    case headerPullEnd
    // 上拉滑动中
    case footerPulling
    // 上拉滑动超过阈值
    case footerPullMax
    // 上拉滑动停止
    case footerPullEnd
}

private struct AssociatedKeys {
    static var refreshHeaderEnable = "kRefreshHeaderEnable"
    static var refreshFooterEnable = "kRefreshFooterEnable"
    static var headerView          = "kHeaderView"
    static var footerView          = "kFooterView"
    static var refreshDelegate     = "kRefreshDelegate"
    static var observerEnable      = "kObserverEnable"
}

extension UIScrollView {
    
    /// 滑动代理
    var refreshDelegate: BPScrollRefreshProtocol? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshDelegate) as? BPScrollRefreshProtocol
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshDelegate, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var observerEnable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.observerEnable) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.observerEnable, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }

    /// 是否开启下拉刷新
    var refreshHeaderEnable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshHeaderEnable) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshHeaderEnable, newValue, .OBJC_ASSOCIATION_ASSIGN)
            if newValue {
                // 开启KVO监听
                self.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
            } else {
                // 取消KVO监听
                self.removeObserver(self, forKeyPath: "contentOffset")
            }
        }
    }
    /// 是否开启上拉加载更多
    var refreshFooterEnable: Bool {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.refreshFooterEnable) as? Bool ?? false
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.refreshFooterEnable, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
    /// 刷新头部视图
    var headerView: BPRefreshHeaderView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.headerView) as? BPRefreshHeaderView
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.headerView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    /// 加载跟多底部视图
    var footerView: BPRefreshFooterView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.footerView) as? BPRefreshFooterView
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.footerView, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    private func setStatus(status: BPRefreshStatus, isRefresh: Bool = false) {
        switch status {
        case .headerPulling:
            self.refreshDelegate?.pullingHeader(offsetY: self.contentOffset.y)
        case .headerPullMax:
            self.refreshDelegate?.pullMaxHeader(offsetY: self.contentOffset.y)
        case .headerPullEnd:
            self.refreshDelegate?.pullEndHeader(isRefresh: isRefresh)
        case .footerPulling:
            self.refreshDelegate?.pullingFooter(offsetY: self.contentOffset.y)
        case .footerPullMax:
            self.refreshDelegate?.pullMaxFooter(offsetY: self.contentOffset.y)
        case .footerPullEnd:
            self.refreshDelegate?.pullEndFooter(isRefresh: isRefresh)
        }
    }
    
    // MARK: ==== KVO ====
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentOffset" else { return }
        // 设置默认最大拖拽长度
        let pullHeaderMaxSize: CGFloat = 90
        let pullFooterMaxSize: CGFloat = 60
        
        var offsetY = self.contentOffset.y
        
        if self.isDragging {
            self.observerEnable = true
            if offsetY < 0 {
                if offsetY > -pullHeaderMaxSize {
                    // 滑动中
                    self.setStatus(status: .headerPulling)
                } else {
                    // 超过最大长度
                    self.setStatus(status: .headerPullMax)
                }
                // 添加头部视图
                if self.headerView == nil {
                    self.headerView = BPRefreshHeaderView()
                }
            } else {
                offsetY = self.height + offsetY - self.contentSize.height
                if self.footerView == nil {
                    self.footerView = BPRefreshFooterView()
                }
                if offsetY > pullFooterMaxSize {
                    self.setStatus(status: .footerPullMax)
                } else if offsetY > 0 {
                    self.setStatus(status: .footerPulling)
                }
            }
        } else {
            // 防止多次触发回调
            guard self.observerEnable else { return }
            // 手指移开
            if offsetY < 0 {
                self.setStatus(status: .headerPullEnd, isRefresh: offsetY < -pullHeaderMaxSize)
                BPLog(offsetY)
            } else {
                offsetY = self.height + offsetY - self.contentSize.height
                if offsetY > 0 {
                    self.setStatus(status: .footerPullEnd, isRefresh: offsetY > pullFooterMaxSize)
                }
            }
            self.observerEnable = false
        }
        
    }
    
}
