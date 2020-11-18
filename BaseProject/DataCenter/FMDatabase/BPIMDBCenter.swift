//
//  IMDBCenter.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/9/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import FMDB

struct BPIMDBCenter: BPDatabaseProtocol {

    static let `default` = BPIMDBCenter()

    // MARK: ==== Session ====
    /// 获取所有最近会话
    func fetchAllRecnetSession() -> [BPSessionModel] {
        let modelList = BPIMDBOperator.default.selectAllSession()
        return modelList
    }

    /// 更新最近会话展示信息
    func updateSessionModel(model: BPSessionModel) {
        // 查询是否存在
        let result = BPIMDBOperator.default.selectSession(friend: model.friendId)
        if result {
            // 更新
            BPIMDBOperator.default.updateSession(model: model)
        } else {
            // 插入
            BPIMDBOperator.default.insertSession(model: model)
        }
    }

    func updateSessionLastShowTime(model: BPSessionModel) {
        // 查询是否存在
        let result = BPIMDBOperator.default.selectSession(friend: model.friendId)
        if result {
            // 更新
            BPIMDBOperator.default.updateSessionLastShowTime(model: model)
        } else {
            // 插入
            BPIMDBOperator.default.insertSession(model: model)
        }
    }

    /// 删除某条聊天记录
    @discardableResult
    func deleteSession(session id: String) -> Bool {
        return BPIMDBOperator.default.deleteSession(session: id)
    }
    /// 删除所有最近聊天记录
    @discardableResult
    func deleteAllSession() -> Bool {
        return BPIMDBOperator.default.deleteAllSession()
    }

    // MARK: ==== Message ====
    func selectAllMessage(session id: String) -> [BPMessageModel] {
        return BPIMDBOperator.default.selectAllMessage(session: id)
    }

    @discardableResult
    func insertMessage(message model: BPMessageModel) -> Bool {
        return BPIMDBOperator.default.insertMessage(message: model)
    }

    @discardableResult
    func deleteAllMessage(session id: String) -> Bool {
        return BPIMDBOperator.default.deleteAllMessage(session: id)
    }
}
