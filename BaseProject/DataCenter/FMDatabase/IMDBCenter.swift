//
//  IMDBCenter.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import FMDB

struct IMDBCenter: BPDatabaseProtocol {

    static let `default` = IMDBCenter()

    // MARK: 查询
    func fetchAllRecnetSession() -> [String] {
        BPIMDBOperator.default.selectRecentSession()
        return Array(repeating: "result", count: 10)
    }

    // MARK: 更新
}
