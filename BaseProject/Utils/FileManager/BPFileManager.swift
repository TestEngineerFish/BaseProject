//
//  BPFileManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

struct BPFileManager {
    static let share = BPFileManager()

    func saveMediaFile(name: String, data: Data, type: BPMediaType) -> String? {
        var path = ""
        switch type {
        case .thumbImage:
            path = thumbPath()
        case .originImage:
            path = originPath()
        case .video:
            path = videoPath()
        case .audio:
            path = audioPath()
        }
        path += "/\(name)" + type.suffix()

        self.checkFile(path: path)
        guard let fileHandle = FileHandle(forWritingAtPath: path) else {
            BPRequestLog("文件写入失败:", path)
            return nil
        }
        fileHandle.write(data)
        BPRequestLog("文件写入成功")
        return path
    }

    // MARK: ==== Tools ====

    /// 缩略图存放路径
    /// - Returns: 路径地址
    private func thumbPath() -> String {
        let path = mediaPath() + "/thumbnailImage"
        self.checkDirectory(path: path)
        return path
    }

    /// 原图存放路径
    /// - Returns: 路径地址
    private func originPath() -> String {
        let path = mediaPath() + "/originImage"
        self.checkDirectory(path: path)
        return path
    }

    /// 视频存放路径
    /// - Returns: 路径地址
    private func videoPath() -> String {
        let path = mediaPath() + "/video"
        self.checkDirectory(path: path)
        return path
    }

    /// 视频存放路径
    /// - Returns: 路径地址
    private func audioPath() -> String {
        let path = mediaPath() + "/audio"
        self.checkDirectory(path: path)
        return path
    }

    /// 多媒体资源存放路径
    /// - Returns: 路径地址
    private func mediaPath() -> String {
        let path = documentPath() + "/Media"
        self.checkDirectory(path: path)
        return path
    }

    /// 文档路径
    /// - Returns: 路径地址
    func documentPath() -> String {
        var documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? ""
        if documentPath == "" {
            documentPath = NSHomeDirectory() + "/Documents"
            self.checkDirectory(path: documentPath)
            return documentPath
        }
        return documentPath
    }

    /// 检查文件夹是否存在，不存在则创建
    /// - Parameter path: 文件路径
    private func checkDirectory(path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }

    /// 检查文件是否存在，不存在则创建
    /// - Parameter path: 文件路径
    private func checkFile(path: String) {
        if !FileManager.default.fileExists(atPath: path) {
            FileManager.default.createFile(atPath: path, contents: nil, attributes: nil)
        }
    }
}
