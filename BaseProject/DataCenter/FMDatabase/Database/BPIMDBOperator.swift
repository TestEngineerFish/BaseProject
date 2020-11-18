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
    func insertSession(model: BPSessionModel) -> Bool
    /// 查询最近会话记录
    func selectSession(friend id: String) -> Bool
    /// 查询所有最近会话记录
    func selectAllSession() -> [BPSessionModel]
    /// 更新最近会话记录
    func updateSession(model: BPSessionModel) -> Bool
    /// 跟新最近会话中最后最后一条显示的时间戳
    func updateSessionLastShowTime(model: BPSessionModel) -> Bool
    /// 删除某条最近会话记录
    /// - Parameter id: 会话ID
    func deleteSession(session id: String) -> Bool
    /// 删除最近会话记录
    func deleteAllSession() -> Bool

    // MARK: 消息表操作
    /// 插入消息记录
    func insertMessage(message model: BPMessageModel) -> Bool
    /// 查询消息记录
    func selectAllMessage(session id: String) -> [BPMessageModel]
    /// 更新消息记录
    func updateMessage() -> Bool
    /// 删除消息记录
    func deleteAllMessage(session id: String) -> Bool

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

    // MARK: ==== Session ====
    @discardableResult
    func insertSession(model: BPSessionModel) -> Bool {
        let values = [model.id,
                      model.type.rawValue,
                      model.friendId,
                      model.name,
                      model.avatarPath as Any,
                      model.lastMsgModel?.text ?? "",
                      model.lastMsgModel?.time ?? 0,
                      model.lastMsgModel?.status.rawValue ?? 0] as [Any]
        let sql    = BPSQLManager.IMSession.insertSession.rawValue
        let result = self.imRunner.executeUpdate(sql, withArgumentsIn: values)
        return result
    }

    @discardableResult
    func selectSession(friend id:String) -> Bool {
        let sql = BPSQLManager.IMSession.selectSession.rawValue
        guard let result = self.imRunner.executeQuery(sql, withArgumentsIn: [id]), result.next() else {
            return false
        }
        return true
    }

    func selectAllSession() -> [BPSessionModel] {
        var sessionModelList = [BPSessionModel]()
        let sql = BPSQLManager.IMSession.selectAllSession.rawValue
        guard let result = self.imRunner.executeQuery(sql, withArgumentsIn: []) else {
            BPLog("数据库中无最近会话")
            return sessionModelList
        }
        while result.next() {
            let model = self.transformSessionModel(result: result)
            sessionModelList.append(model)
        }
        return sessionModelList
    }

    @discardableResult
    func updateSession(model: BPSessionModel) -> Bool {
        let params = [model.lastMsgModel?.text ?? "",
                      model.lastMsgModel?.time ?? 0,
                      model.lastMsgModel?.status.rawValue ?? 0,
                      model.unreadCount, model.id] as [Any]
        let sql = BPSQLManager.IMSession.updateSession.rawValue
        let result = self.imRunner.executeUpdate(sql, withArgumentsIn: params)
        return result
    }

    @discardableResult
    func updateSessionLastShowTime(model: BPSessionModel) -> Bool {
        guard let time = model.lastShowTime else {
            return false
        }
        let sql = BPSQLManager.IMSession.updateSessionLastShowTime.rawValue
        let result = self.imRunner.executeUpdate(sql, withArgumentsIn: [time, model.id])
        return result
    }

    func deleteSession(session id: String) -> Bool {
        let sql = BPSQLManager.IMSession.deleteSession.rawValue
        let result = self.imRunner.executeUpdate(sql, withArgumentsIn: [id])
        return result
    }

    func deleteAllSession() -> Bool {
        let sql = BPSQLManager.IMSession.deleteAllSession.rawValue
        let result = self.imRunner.executeUpdate(sql, withArgumentsIn: [])
        return result
    }

    // MARK: ==== Message ====
    func insertMessage(message model: BPMessageModel) -> Bool {
        let params = [model.id,
                      model.sessionId,
                      model.type.rawValue,
                      model.fromType.rawValue,
                      model.status.rawValue,
                      model.text,
                      model.mediaModel?.toJSONString() ?? "",
                      model.time,
                      model.unread] as [Any]
        let sql = BPSQLManager.IMMessage.insertMessage.rawValue
        let result = self.imRunner.executeUpdate(sql, withArgumentsIn: params)
        return result
    }

    func selectAllMessage(session id: String) -> [BPMessageModel] {
        var messageModelList = [BPMessageModel]()
        let sql = BPSQLManager.IMMessage.selectAllMessage.rawValue
        guard let result = self.imRunner.executeQuery(sql, withArgumentsIn: [id]) else {
            return messageModelList
        }
        while result.next() {
            let messageModel = self.transformMessageModel(result: result)
            messageModelList.append(messageModel)
        }
        return messageModelList
    }

    func updateMessage() -> Bool {
        return true
    }

    func deleteAllMessage(session id: String) -> Bool {
        let sql = BPSQLManager.IMMessage.deleteAllMessageWithSession.rawValue
        let result = self.imRunner.executeUpdate(sql, withArgumentsIn: [id])
        return result
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

    // MARK: ==== Tools ====
    private func transformSessionModel(result: FMResultSet) -> BPSessionModel {
        var model = BPSessionModel()
        model.id            = result.string(forColumn: "session_id") ?? ""
        model.friendId      = result.string(forColumn: "friend_id") ?? ""
        model.avatarPath    = result.string(forColumn: "friend_avatar_url") ?? ""
        model.name          = result.string(forColumn: "friend_name") ?? ""
        model.isTop         = (Int(result.int(forColumn: "is_top")) != 0)
        model.type          = BPSessionType(rawValue: Int(result.int(forColumn: "session_type"))) ?? .normal
        model.lastShowTime  = result.date(forColumn: "last_show_time")
        var lastMsgModel = BPMessageModel()
        lastMsgModel.text   = result.string(forColumn: "last_msg") ?? ""
        lastMsgModel.time   = result.date(forColumn: "msg_time") ?? Date()
        lastMsgModel.status = BPMessageStatus(rawValue: Int(result.int(forColumn: "msg_status"))) ?? .success
        model.lastMsgModel = lastMsgModel
        return model
    }

    private func transformMessageModel(result: FMResultSet) -> BPMessageModel {
        var model = BPMessageModel()
        model.id       = result.string(forColumn: "msg_id") ?? ""
        model.text     = result.string(forColumn: "content") ?? ""
        model.time     = result.date(forColumn: "create_time") ?? Date()
        model.type     = BPMessageType(rawValue: Int(result.int(forColumn: "type"))) ?? .text
        model.fromType = BPMessageFromType(rawValue: Int(result.int(forColumn: "from_type"))) ?? .local
        model.status   = BPMessageStatus(rawValue: Int(result.int(forColumn: "status"))) ?? .success
        if let mediaJson = result.string(forColumn: "media_json"), let mediatModel = BPMediaModel(JSONString: mediaJson) {
            model.mediaModel = mediatModel
        }
        return model
    }

}
