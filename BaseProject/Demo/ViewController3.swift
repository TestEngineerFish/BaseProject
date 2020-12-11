//
//  ViewController3.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController3: BPViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.customNavigationBar?.isHidden = true
        self.createSubviews()

        let drawView = DrawView(frame: self.view.bounds)
        self.view.addSubview(drawView)
    }

    override func createSubviews() {
        super.createSubviews()
    }




}
