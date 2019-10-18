//
//  BPIMDBOperator.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import FMDB

protocol BPIMDBProtocol {
    // 单例操作对象
    static var `default`: BPIMDBOperator { get }

    // MARK: 最近会话表操作
    /// 插入最近会话记录
    func insertRecentSession() -> Bool
    /// 查询最近会话记录
    func selectRecentSession() -> Bool
    /// 更新最近会话记录
    func updateRecentSession() -> Bool
    /// 删除最近会话记录
    func deleteRecentSession() -> Bool

    // MARK: 消息表操作
    /// 插入消息记录
    func insertMessage() -> Bool
    /// 查询消息记录
    func selectMessage() -> Bool
    /// 更新消息记录
    func updateMessage() -> Bool
    /// 删除消息记录
    func deleteMessage() -> Bool

    // MARK: 关联表操作
    /// 插入关联记录
    func insertMap() -> Bool
    /// 查询关联记录
    func selectMap() -> Bool
    /// 更新关联记录
    func updateMap() -> Bool
    /// 删除关联记录
    func deleteMap() -> Bool
}

extension BPIMDBProtocol {
    static var `default`: BPIMDBOperator { return BPIMDBOperator() }
}

class BPIMDBOperator: BPIMDBProtocol, BPDatabaseProtocol {

    func insertRecentSession() -> Bool {
        return true
    }

    @discardableResult
    func selectRecentSession() -> Bool {
        let sql = BPSQLManager.SelectIMTableSQLs.selectAllRecentSession.rawValue
        let result = self.imRunner.executeQuery(sql, withArgumentsIn: [])
        if result == nil {
            print("Error: query all recent session fail")
        }
        return true
    }

    func updateRecentSession() -> Bool {
        return true
    }

    func deleteRecentSession() -> Bool {
        return true
    }

    func insertMessage() -> Bool {
        return true
    }

    func selectMessage() -> Bool {
        return true
    }

    func updateMessage() -> Bool {
        return true
    }

    func deleteMessage() -> Bool {
        return true
    }

    func insertMap() -> Bool {
        return true
    }

    func selectMap() -> Bool {
        return true
    }

    func updateMap() -> Bool {
        return true
    }

    func deleteMap() -> Bool {
        return true
    }


}
