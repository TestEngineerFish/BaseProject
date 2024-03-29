//
//  BPViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import SnapKit

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    internal func createSubviews() {}

    internal func bindProperty() {}

    internal func bindData() {}

    internal func registerNotification() {}
    
    // 切换环境
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
        #if DEBUG
        if event?.subtype == .some(.motionShake) && !(UIViewController.currentViewController?.isKind(of: BPEnvChangeViewController.classForCoder()) ?? false) {
            let vc = BPEnvChangeViewController()
            UIViewController.currentViewController?.present(vc, animated: true, completion: nil)
            BPLog("用户目录：\(NSHomeDirectory())")
        }
        #endif
    }

}

