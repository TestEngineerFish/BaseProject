//
//  BPPublishRemindViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/26.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPublishRemindViewController: BPViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.customNavigationBar?.isHidden = true
    }

    override func bindProperty() {
        super.bindProperty()
        self.view.backgroundColor = .randomColor()
    }
}
