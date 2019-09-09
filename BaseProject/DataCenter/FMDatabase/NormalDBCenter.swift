//
//  NormalDBCenter.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import FMDB

struct NormalDBCenter: BPDatabaseProtocol {

    static let `default` = NormalDBCenter()

    var db: FMDatabase { return self.normalRunner }

    // MARK: 查询
    // MARK: 更新
}
