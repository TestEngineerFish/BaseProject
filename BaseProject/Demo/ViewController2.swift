//
//  ViewController2.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red1
        self.view.layer.setGradient(colors: [UIColor.green1, UIColor.yellow1, UIColor.orange1], direction: .leftTop)
    }
}
