//
//  YYFileManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

open class YYFileManager: NSObject {
    
    // singleton
    class var share: YYFileManager {
        struct Static {
            static let instance: YYFileManager = YYFileManager()
        }
        return Static.instance
    }
    
    /// 创建文件路径
    ///
    /// - Parameter docuMentPath: <#docuMentPath description#>
    /// - Returns: <#return value description#>
    func createPath(documentPath: String?) -> String {
        
        guard let _documentPath = documentPath else {  return "" }
        
        if !FileManager.default.fileExists(atPath: _documentPath) {
            try! FileManager.default.createDirectory(atPath: _documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        
        return _documentPath
    }
    
    /// 创建压缩文件
    ///
    /// - Parameters:
    ///   - documentPath: <#documentPath description#>
    ///   - paths: <#paths description#>
    ///   - zipName: <#zipName description#>
    /// - Returns: <#return value description#>
    func archiveZipFile(documentPath: String?, paths: [String]?, zipName: String?) -> Data? {
        guard let _documentPath = documentPath, let _paths = paths, let _zipName =  zipName  else {
            return nil
        }
        let zipFilePath = self.createPath(documentPath: _documentPath) + _zipName
        
        if SSZipArchive.createZipFile(atPath: zipFilePath, withFilesAtPaths: _paths) {
            return try! Data.init(contentsOf: URL(fileURLWithPath: zipFilePath))
        }
        return nil
    }
    
    
    
    /// 判断指定文件路径下是否存在文件
    ///
    /// - Parameter path: 文件路径
    /// - Returns: bool
    func judgeFileIsExistAtPath(path: String?) -> Bool {
        guard let _path = path else {
            return false
        }
        
        let exist = FileManager.default.fileExists(atPath: _path)
        if exist { return true }
        
        return false
    }
    
    /**
     * 清除指定路径下的内容
     *
     *
     */
    func clearPaths(paths: [String]? = [], documentPath: String?) {
        guard var _paths = paths, let _documentPath = documentPath else {
            return
        }
        
        do {
            try FileManager.default.removeItem(atPath: self.createPath(documentPath: _documentPath))
            _paths.removeAll()
        } catch _ {
        }
    }
    
    
    /// 清除指定路径下的视频
    ///
    /// - Parameter path: 指定路径
    func clearVideoAtPath(path: String?) {
        guard let _path = path else { return }
        
        do {
            try FileManager.default.removeItem(atPath: _path)
        } catch _ {
        }
        
    }
    
    
    /// 清除指定路径下的文件
    ///
    /// - Parameter path: 指定路径
    func clearFile(path: String?) -> Bool {
        guard let _path = path else { return false}
        
        do {
            try FileManager.default.removeItem(atPath: _path)
            return true
        } catch _ {
            return false
        }
        
    }
}
