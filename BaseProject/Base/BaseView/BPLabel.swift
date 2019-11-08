//
//  BPLabel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPLabel: UILabel {
    var count: Int   = 0
    var maxNum: Int  = 100
    var timer: Timer = Timer.init()

    func startCount(interval: Double) {
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
               timer.fire()
    }

    @objc private func countDown() {
        if count < maxNum {
            self.text = "\(count)%"

            count += 1
        } else {
            timer.invalidate()
        }
    }
}
