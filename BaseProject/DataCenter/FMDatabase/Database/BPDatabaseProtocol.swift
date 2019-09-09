//
//  BPDatabaseProtocol.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import FMDB


/// 若要定义其他数据库的封装层,则直接实现该接口即可
/// - note: 通过这个入口,可以直接获取到需要的数据执行器
protocol BPDatabaseProtocol {
    var normalRunner: FMDatabase { get }
    var imRunner: FMDatabase { get }
}

extension BPDatabaseProtocol {
    /// 默认实现,返回普通数据库的执行器
    var normalRunner: FMDatabase {
        return BPDatabaseManager.default.createRunner(type: .normal)
    }

    /// 默认实现,返回IM系统的数据库执行器
    var imRunner: FMDatabase {
        return BPDatabaseManager.default.createRunner(type: .im)
    }
}
