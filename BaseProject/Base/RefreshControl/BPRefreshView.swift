//
//  BPRefreshView.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/20.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPRefreshView: BPView {
    let headerViewHeight = AdaptSize(50)
    let footerViewHeight = AdaptSize(50)
    
    var headerView: BPRefreshHeaderView?
    var footerView: BPRefreshFooterView?
    var scrollView: UIScrollView?
    
    init(enableHeader: Bool = true, enableFooter: Bool = true) {
        super.init(frame: .zero)
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.headerView = BPRefreshHeaderView()
        self.footerView = BPRefreshFooterView()
        self.addSubview(headerView!)
        self.addSubview(footerView!)
        headerView?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.snp.top)
            make.height.equalTo(headerViewHeight)
        })
        footerView?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.snp.bottom)
            make.height.equalTo(footerViewHeight)
        })
    }
    
    // MARK: ==== KVO 监听滑动 ====
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.snp.remakeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        guard let _scrollView = superview as? UIScrollView else {
            return
        }
        _scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        self.scrollView = _scrollView
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let _scrollView =  self.scrollView, _scrollView.isDragging else {
            return
        }
        BPLog(_scrollView.contentOffset)
        if _scrollView.contentOffset.y < 0 {
            BPLog("下拉刷新")
            self.headerView?.transform = CGAffineTransform(translationX: 0, y: -_scrollView.contentOffset.y)
        } else {
            BPLog("上拉中")
        }
    }
}
