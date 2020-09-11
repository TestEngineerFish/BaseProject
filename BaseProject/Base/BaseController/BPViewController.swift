//
//  BPViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPViewController: UIViewController {

    deinit {
        #if DEBUG
        BPLog(self.classForCoder, "资源释放")
        #endif
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        BPLog("==== \(self.classForCoder) 内存告警 ====")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.useCustomNavigationBar()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
//        self.addGes()
    }

    private func addGes() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(pan:)))
        self.view.addGestureRecognizer(pan)
    }

    @objc
    private func panAction(pan: UIPanGestureRecognizer) {
        let point = pan.translation(in: self.view)
        BPLog(point)
        if point.y > 10 {
            BPLog("向下滑动")
        } else if point.y < -10 {
            BPLog("向上滑动")
        } else if point.x > 10 {
            BPLog("向右滑动")
        } else if point.x < -10 {
            BPLog("向左滑动")
        }

    }

    internal func createSubviews() {}

    internal func bindProperty() {}

    internal func bindData() {}

    internal func registerNotification() {}

}

