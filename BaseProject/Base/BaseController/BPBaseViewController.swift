//
//  BPBaseViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class YYBaseViewController: UIViewController {

    deinit {
        print("控制器释放: " + String(describing: self.classForCoder))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 当使用自定义导航条的时候，左滑返回会消失，在扩展中进行了实现
        self.navigationController?.delegate = self

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        useCustomNavigationBar()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

