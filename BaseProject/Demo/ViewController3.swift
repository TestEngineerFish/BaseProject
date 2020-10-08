//
//  ViewController3.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController3: BPViewController {
    var earthView: BPEarthView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.customNavigationBar?.isHidden = true
        self.createSubviews()
    }

    override func createSubviews() {
        super.createSubviews()
        self.earthView = BPEarthView(frame: CGRect(x: 50, y: 350, width: kScreenWidth - 100, height: kScreenWidth - 100))
        earthView?.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        self.view.addSubview(earthView!)
    }


    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.earthView?.removeFromSuperview()
        self.createSubviews()
    }
}
