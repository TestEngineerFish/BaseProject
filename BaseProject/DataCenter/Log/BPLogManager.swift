//
//  BPLogManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/1/16.
//  Copyright © 2020 沙庭宇. All rights reserved.
//


import Foundation
import CocoaLumberjack
import ZipArchive

class BPLogManager: NSObject {

    @objc static let share = BPLogManager()

    // MARK: ==== Request ====

    // 上传
    @objc func report(_ showToast: Bool = false) {
        self.addInfo()
//        guard let fileData = self.zipLogFile() else {
//            return
//        }
//        let request = YXLogRequest.report(file: fileData)
//        YYNetworkService.default.upload(YYStructResponse<YXLogModel>.self, request: request, mimeType: YXMiMeType.file.rawValue, fileName: "log", success: { (response) in
//            if showToast {
//                YXUtils.showHUD(kWindow, title: "上传完成")
//            }
//            self.deleteZip()
//            self.deleteFile()
//        }) { (error) in
//            if showToast {
//                YXUtils.showHUD(kWindow, title: "上传失败，请稍后再试")
//            }
//        }
    }

    // MARK: ==== Event ====
    private func addInfo() {
        self.addUserInfo()
        self.addDeviceInfo()
    }

    /// 添加用户信息
    private func addUserInfo() {
//        BPLog("当前UUID：" + (YXUserModel.default.uuid ?? ""))
//        BPLog("当前用户名：" + (YXUserModel.default.username ?? ""))
//        BPLog("当前用户手机号：" + (YXConfigure.shared().mobile ?? ""))
//        BPLog("当前使用App版本：" + UIDevice().appVersion())
    }

    /// 添加设备信息
    private func addDeviceInfo() {
//        BPLog("当前App版本：" + UIDevice().appVersion())
//        BPLog("当前App Build版本：" + YRDevice.appBuild())
//        BPLog("当前设备名称：" + UIDevice().machineName())
//        BPLog("当前系统版本：" + UIDevice().sysVersion())
//        BPLog("当前网络环境：" + UIDevice().networkType())
//        BPLog("当前屏幕英寸：" + UIDevice().screenInch())
//        BPLog("当前屏幕分辨率：" + UIDevice().screenResolution())
    }

    // MARK: ==== Tool ====

    ///  压缩日志文件
    private func zipLogFile() -> Data? {
        let fileLogger    = DDFileLogger()
        let requestLogger = BPOCLog.shared()?.loggerFoRequest
        let eventLogger   = BPOCLog.shared()?.loggerForEvent

        let logZiper         = ZipArchive()
        let requestZiper     = ZipArchive()
        let eventZiper       = ZipArchive()
        let wordSQLiteZiper  = ZipArchive()

        let logDirectoryPath = fileLogger.logFileManager.logsDirectory
        let logZipPath       = logDirectoryPath + "/Log.zip"

        let requestLogList   = requestLogger?.logFileManager.sortedLogFileNames
        let requestDirectory = requestLogger?.logFileManager.logsDirectory ?? ""
        let requestZipPath   = requestDirectory + "/Request.zip"
        let eventLogList     = eventLogger?.logFileManager.sortedLogFileNames
        let eventDirectory   = eventLogger?.logFileManager.logsDirectory ?? ""
        let eventZipPath     = eventDirectory + "/Event.zip"

        let wordSQLitePath: String = {
            let documentPath = NSHomeDirectory() + "/Documents/"
            if !FileManager.default.fileExists(atPath: documentPath){
                try? FileManager.default.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }
            return documentPath
        }()
        let wordSQLiteZipPath = wordSQLitePath + "WordSQL.zip"

//        BPLog("++++++++++++++++")
//        BPLog(logDirectoryPath)
        if requestZiper.createZipFile2(requestZipPath) {
            requestLogList?.forEach({ (name) in
                requestZiper.addFile(toZip: requestDirectory + "/" + name, newname: name)
            })
//            BPLog("创建Request Zip成功")
        } else {
//            BPLog("创建Request Zip失败")
        }
        requestZiper.closeZipFile2()

        if eventZiper.createZipFile2(eventZipPath) {
            eventLogList?.forEach({ (name) in
                eventZiper.addFile(toZip: eventDirectory + "/" + name, newname: name)
            })
//            BPLog("创建Event Zip成功")
        } else {
//            BPLog("创建Evnet Zip失败")
        }
        eventZiper.closeZipFile2()

        if wordSQLiteZiper.createZipFile2(wordSQLiteZipPath) {
            let sqlPath = BPDatabaseManager.default.dbFilePath(fileName: BPDatabaseType.im.rawValue)
            wordSQLiteZiper.addFile(toZip: sqlPath, newname: BPDatabaseType.im.rawValue)
//            BPLog("创建Word SQLite Zip成功")
        } else {
//            BPLog("创建Word SQLite Zip失败")
        }
        wordSQLiteZiper.closeZipFile2()

        guard let requestZipData = try? Data(contentsOf: URL(fileURLWithPath: requestZipPath)), let eventZipData = try? Data(contentsOf: URL(fileURLWithPath: eventZipPath)), let wordSQLiteZipData = try? Data(contentsOf: URL(fileURLWithPath: wordSQLiteZipPath)) else {
            return nil
        }
        if logZiper.createZipFile2(logZipPath) {
            logZiper.addData(toZip: requestZipData, fileAttributes: [:], newname: "Request.zip")
            logZiper.addData(toZip: eventZipData, fileAttributes: [:], newname: "Event.zip")
            logZiper.addData(toZip: wordSQLiteZipData, fileAttributes: [:], newname: "WordSQL.zip")
//            BPLog("创建Log Zip成功")
        } else {
//            BPLog("创建Log Zip失败")
        }
        logZiper.closeZipFile2()
        guard let logZipData = try? Data(contentsOf: URL(fileURLWithPath: logZipPath))else {
            return nil
        }
        return logZipData
    }

    /// 删除Zip包
    private func deleteZip() {
        let fileLogger    = DDFileLogger()
        let requestLogger = BPOCLog.shared()?.loggerFoRequest
        let eventLogger   = BPOCLog.shared()?.loggerForEvent

        let logDirectory     = fileLogger.logFileManager.logsDirectory
        let requestDirectory = requestLogger?.logFileManager.logsDirectory ?? ""
        let eventDirectory   = eventLogger?.logFileManager.logsDirectory ?? ""

        let requestZipPath   = requestDirectory + "/Request.zip"
        let eventZipPath     = eventDirectory + "/Event.zip"
        let logZipPath       = logDirectory + "/Log.zip"
        let wordSQLitePath: String = {
            let documentPath = NSHomeDirectory() + "/Documents/"
            if !FileManager.default.fileExists(atPath: documentPath){
                try? FileManager.default.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }
            return documentPath
        }()
        let wordSQLiteZipPath = wordSQLitePath + "WordSQL.zip"

        if ((try? FileManager.default.removeItem(atPath: requestZipPath)) != nil) {
//            BPLog("删除Request Zip包成功")
        } else {
//            BPLog("删除Reqeust Zip包失败")
        }

        if ((try? FileManager.default.removeItem(atPath: eventZipPath)) != nil) {
//            BPLog("删除Event Zip包成功")
        } else {
//            BPLog("删除Evnet Zip包失败")
        }

        if ((try? FileManager.default.removeItem(atPath: wordSQLiteZipPath)) != nil) {
//            BPLog("删除Word SQLite Zip包成功")
        } else {
//            BPLog("删除Word SQLite Zip包失败")
        }

        if ((try? FileManager.default.removeItem(atPath: logZipPath)) != nil) {
//            BPLog("删除Log Zip包成功")
        } else {
//            BPLog("删除Log Zip包失败")
        }
    }

    /// 删除日志文件
    private func deleteFile() {
        let requestLogger = BPOCLog.shared()?.loggerFoRequest
        let eventLogger   = BPOCLog.shared()?.loggerForEvent

        let requestLogFileList = requestLogger?.logFileManager.sortedLogFilePaths ?? []
        let eventLogFileList   = eventLogger?.logFileManager.sortedLogFilePaths ?? []

        requestLogFileList.forEach { (path) in
            if ((try? FileManager.default.removeItem(atPath: path)) != nil) {
//                BPLog("删除Request日志成功")
            } else {
//                BPLog("删除Request日志失败")
            }
        }
        eventLogFileList.forEach { (path) in
            if ((try? FileManager.default.removeItem(atPath: path)) != nil) {
//                BPLog("删除Even日志成功")
            } else {
//                BPLog("删除Event日志失败")
            }
        }
    }
}

