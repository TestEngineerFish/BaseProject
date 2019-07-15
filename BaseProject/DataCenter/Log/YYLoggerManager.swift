//
//  YYLoggerManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

/**
 *  日志类别分类
 *
 *  network: 网络
 *  im: 消息聊天
 *  other: 其他
 *  businessOperation: 业务操作
 */
enum YYLoggerCommandType: String {
    case other = "Other"
    case network = "Network"
    case im = "IM"
    case businessOperation = "BusinessOperation"
}

protocol YYLoggerOperation {
    
    func loggerDidFillMaxContent(_ sourceLogData: [YYLoggerModel])
}

class YYLoggerManager: NSObject {
    
    /**
     *  容量阈值（默认为3）
     */
    var max: Int  = 0
    
    /**
     *  具体存储操作（目前暂仅支持文件存储方式）
     */
    var loggerOperation: YYLoggerOperation?
    
    var userLoggerDic: String? {
        return (self.loggerOperation as? YYLoggerFileOperation)?.userRootDic
    }
    
    var unLoginLoggerDic: String? {
        return (self.loggerOperation as? YYLoggerFileOperation)?.unLoginRootDic
    }
    
    private var condition: NSCondition?
    private var loggerThread: Thread?
    private var sourceLogData: [YYLoggerModel] = []
    
    static let `default` = YYLoggerManager()
    
    private override init() {
        super.init()
        initPros()
    }
    
    private func initPros() {
        self.max = 3
        self.condition = NSCondition()
        self.loggerOperation = YYLoggerFileOperation()
        self.loggerThread = Thread(target: self, selector: #selector(threadRunAction), object: nil)
        self.loggerThread?.start()
    }
    
    @objc func threadRunAction() {
        //TODO 线程常驻
        RunLoop.current.add(Port(), forMode: .common)
        RunLoop.current.run()
    }
    
    func addLoggerDataSource(_ loggerCommandType: YYLoggerCommandType = .other, logText: Any) {
        self.condition?.lock()
        sourceLogData.append(transfromLogTextToLoggerModel(loggerCommandType, logText: logText))
        self.perform(#selector(action), on: self.loggerThread!, with: nil, waitUntilDone: false)
        self.condition?.unlock()
    }
    
    @objc func action() {
        if sourceLogData.count >= self.max {
            self.loggerOperation?.loggerDidFillMaxContent(sourceLogData)
            clearLoggerDataSource()
        }
    }
    
    /**
     *  强制将数据写入文件
     */
    func forceLoggerDataSourceToWriteFile() {
        self.loggerOperation?.loggerDidFillMaxContent(sourceLogData)
        clearLoggerDataSource()
    }
    
    func clearLoggerDataSource() {
        self.condition?.lock()
        self.sourceLogData.removeAll()
        self.condition?.unlock()
    }
    
    func start() {
        //URLProtocol.registerClass(YYNetFoxProtocol.self)
    }
    
    func stop() {
        //URLProtocol.unregisterClass(YYNetFoxProtocol.self)
    }
}

extension YYLoggerManager {
    private func transfromLogTextToLoggerModel(_ loggerCommandType: YYLoggerCommandType, logText: Any) -> YYLoggerModel {
        
        var loggerModel: YYLoggerModel = YYLoggerModel()
        loggerModel.createTime = YYDateFormater.share.dataToString(with: Date.getCurrentDate(),
                                                                   dateFormat: "YYYY-MM-dd HH:mm:ss")
        loggerModel.loggerCommandType = loggerCommandType
        loggerModel.logContent = logText
        
        return loggerModel
    }
}
