//
//  YYLoggerFileOperation.swift
//  YouYou
//
//  Created by pyyx on 2018/12/4.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation
import CocoaLumberjack

class YYLoggerFileOperation: YYLoggerOperation {
    
    private var logPathPrefix: String = "log"
    
    func loggerDidFillMaxContent(_ sourceLogData: [YYLoggerModel]) {
        for loggerItem in sourceLogData{
           saveLog(loggerItem)
        }
    }
    
    @discardableResult
    func saveLog(_ loggerModel: YYLoggerModel) -> Bool {
        let fileName = (YYDateFormater.share.dataToString(with: Date()) ?? "") + ".txt"
        let _loggerFilePath = self.loggerFilePath(loggerCommandType: loggerModel.loggerCommandType, fileName: fileName)
        if let loggerFilePath = _loggerFilePath {
            var tab = 0
            let fileHaneld = FileHandle(forWritingAtPath: loggerFilePath)
            writeToFile(fileHaneld: fileHaneld, with: "----------[Start]----------", for: loggerFilePath)
            writeToFile(fileHaneld: fileHaneld, with: "\n", for: loggerFilePath)
            writeToFile(fileHaneld: fileHaneld, with: "createTime: \((loggerModel.createTime ?? ""))", for: loggerFilePath)
            writeToFile(fileHaneld: fileHaneld, with: "\n", for: loggerFilePath)
            iteratorContent(loggerModel.logContent, filePath: loggerFilePath, tab: &tab, fileHaneld: fileHaneld)
            writeToFile(fileHaneld: fileHaneld, with: "----------[End]----------", for: loggerFilePath)
            writeToFile(fileHaneld: fileHaneld, with: "\n", for: loggerFilePath)
        }
        return true
    }
    
    private func iteratorContent(_ content: Any?, filePath: String, tab: inout Int, needTab: Bool = false, fileHaneld: FileHandle?) {
        if let logContent = content as? [String : Any]{
            for (key, value) in logContent {
                if value is [String : Any] {
                    let _content = key + ": "
                    writeToFile(fileHaneld: fileHaneld, with: _content, for: filePath)
                    writeToFile(fileHaneld: fileHaneld, with: "\n", for: filePath)
                    tab += 1
                    iteratorContent(value, filePath: filePath, tab: &tab, needTab: true, fileHaneld: fileHaneld)
                }else {
                    if needTab {
                        if tab > 0 {
                            for _ in 0..<tab {
                                writeToFile(fileHaneld: fileHaneld, with: "\t", for: filePath)
                            }
                        }
                    }
                    let _content = key + ": " + transformStringValue(value)
                    writeToFile(fileHaneld: fileHaneld, with: _content, for: filePath)
                    writeToFile(fileHaneld: fileHaneld, with: "\n", for: filePath)
                }
            }
        }else{
           if let logContent = content as? String {
                writeToFile(fileHaneld: fileHaneld, with: logContent, for: filePath)
                writeToFile(fileHaneld: fileHaneld, with: "\n", for: filePath)
            }
        }
    }
    
    private func writeToFile(fileHaneld: FileHandle?, with content: String, for filPath: String) {
        fileHaneld?.seekToEndOfFile()
        if let _data = content.data(using: String.Encoding.utf8) {
            fileHaneld?.write(_data)
        }
    }
    
    private func transformStringValue(_ value: Any) -> String {
        if value is String {
            return (value as! String)
        }else if value is Int {
            return String(value as! Int)
        }else if value is Float {
            return String(value as! Float)
        }else if value is Double {
            return String(value as! Double)
        }else if value is Data{
            return String(data:value as! Data ,encoding: String.Encoding.utf8) ?? ""
        }
        
        return ""
    }
    
    var userRootDic: String? {
        var _loggerFileDic: String?
        guard let _documentPath = appDocument() else {
            DDLogError("log doucument generate fail")
            return nil
        }
        
        _loggerFileDic = _documentPath.appending("/\(logPathPrefix)")
        _loggerFileDic = _loggerFileDic?.appending("/\(String(YYUserModel.currentUserID()))")
        
        return _loggerFileDic
    }
    
    var unLoginRootDic: String? {
        var _loggerFileDic: String?
        guard let _documentPath = appDocument() else {
            DDLogError("log doucument generate fail")
            return nil
        }
        
        _loggerFileDic = _documentPath.appending("/\(logPathPrefix)/0")
        
        return _loggerFileDic
    }
}

extension YYLoggerFileOperation {
    
    /**
     *  日志存储目录路径
     */
    private func loggerFilePath(loggerCommandType: YYLoggerCommandType, fileName: String) -> String? {
        var _loggerFileDic: String?
        guard let _documentPath = appDocument() else {
            DDLogError("log doucument generate fail")
            return nil
        }
        
        _loggerFileDic = _documentPath.appending("/\(logPathPrefix)")
        _loggerFileDic = _loggerFileDic?.appending("/\(String(YYUserModel.currentUserID()))")
        _loggerFileDic = _loggerFileDic?.appending("/\(loggerCommandType.rawValue)")
        var isDir : ObjCBool = false
        if let loggerFileDic = _loggerFileDic {
            if !FileManager.default.fileExists(atPath: loggerFileDic, isDirectory: &isDir) {
                do {
                    try FileManager.default.createDirectory(at: URL(fileURLWithPath: loggerFileDic), withIntermediateDirectories: true, attributes: nil)
                    
                    _loggerFileDic = _loggerFileDic?.appending("/\(fileName)")
                    if let loggerFileDic = _loggerFileDic, !FileManager.default.fileExists(atPath: loggerFileDic, isDirectory: &isDir) {
                        let success = FileManager.default.createFile(atPath: loggerFileDic, contents: nil)
                        if success{
                            DDLogInfo("log file create success")
                        }
                    }
                }catch let error {
                    DDLogError(error.localizedDescription)
                }
            }else{
                _loggerFileDic = _loggerFileDic?.appending("/\(fileName)")
                if let loggerFileDic = _loggerFileDic, !FileManager.default.fileExists(atPath: loggerFileDic, isDirectory: &isDir) {
                    let success = FileManager.default.createFile(atPath: loggerFileDic, contents: nil)
                    if success{
                        DDLogInfo("log file create success")
                    }
                }
            }
        }
        return _loggerFileDic
    }
    
    private func appDocument() -> String? {
        let paths: [String] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return paths.first
    }
}
