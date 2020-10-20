//
//  BPBaseRefreshControl.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPBaseRefreshControl: UIRefreshControl {

    var delegate: BPScrollRefreshProtocol?
    
    override func beginRefreshing() {
        super.beginRefreshing()
    }

    override func endRefreshing() {
        super.endRefreshing()
    }
}
