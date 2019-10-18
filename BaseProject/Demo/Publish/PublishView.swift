//
//  PublishView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/11.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 发布View,同样继承自BPTopWindowView
///
/// 通过手势处理滑动收起操作
class PublishView: BPTopWindowView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var delegate: BPTabBarControllerProtocol?
    
    let defaultOffset: CGFloat = 300 // 页面固定高度
    
    /// 发布视图
    let _publishView: UIView = {
        let height = kScreenHeight - kTabBarHeight
        let view = UIView(frame: CGRect(x: 0, y: height, width: kScreenWidth, height: height))
        view.backgroundColor = UIColor.white
        view.clipRectCorner(directionList: [.topLeft, .topRight], cornerRadius: 10.0)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubviews()
        // KVO监听PublishView的偏移量
        self._publishView.addObserver(self, forKeyPath: "transform", options: [NSKeyValueObservingOptions(rawValue: NSKeyValueObservingOptions.new.rawValue | NSKeyValueObservingOptions.old.rawValue)], context: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        backgroundView.height = height
        addSubview(_publishView)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panView(pan:)))
        pan.cancelsTouchesInView = false
        pan.delaysTouchesEnded   = false
        _publishView.addGestureRecognizer(pan)
    }
    
    /// 手势事件,处理滑动收起操作
    @objc func panView(pan: UIPanGestureRecognizer){
        let point = pan.translation(in: _publishView)
        // 仅处理向下滑动
        if point.y > 0, _publishView.top >= height - defaultOffset {
            self._publishView.transform = CGAffineTransform(translationX: 0, y: -defaultOffset + point.y)
        }
    }
    
    // 滑动结束事件
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        let minY = height - defaultOffset + 60
        if self._publishView.top > minY {
            self.hideView()
        } else {
          self.showView()
        }
    }
    
    // 滑动中断事件(电话等强制打扰事件)
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        // 判断需要收起.否则回复默认高度
        let minY = height - defaultOffset + 60
        if self._publishView.bottom > minY {
            self.hideView()
        } else {
            self.showView()
        }
    }
    
    /// 显示发布页面,自下而上
    func showView(){
        self.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self._publishView.transform = CGAffineTransform(translationX: 0, y: -self.defaultOffset)
        }
    }
    
    /// 隐藏发布页面,自上而下
    func hideView(){
        UIView.animate(withDuration: 0.25, animations: {
            self._publishView.transform = CGAffineTransform.identity
        }) { (result) in
            self.isHidden = true
            self.removeFromSuperview()
        }
    }

    override func closeBtnAction() {
        // 不用处理,与touch事件会冲突
    }

    // - MARK: KVO
    /// 通过发布页的滑动距离.来控制窗口上的背景色渐变显示和底部加号按钮的旋转
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "transform" {
            guard let delegate = self.delegate else {
                return
            }
            let offsetY = abs(height - self._publishView.top)/defaultOffset
            delegate.publishViewOffset(offsetY)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print("hitTest")
        return super.hitTest(point, with: event)
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        print("point")
         return super.point(inside: point, with: event)
    }
}
