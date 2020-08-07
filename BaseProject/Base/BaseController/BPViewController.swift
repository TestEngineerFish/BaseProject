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
    }

    internal func createSubviews() {}

    internal func bindProperty() {}

    internal func registerNotification() {}

}

