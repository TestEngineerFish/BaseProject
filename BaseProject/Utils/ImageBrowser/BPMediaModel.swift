//
//  BPImageModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/29.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper
import Kingfisher

enum BPMediaType: Int {
    /// 缩略图
    case thumbImage
    /// 原图
    case originImage
    /// 视频
    case video
    /// 音频
    case audio

    /// 获取后缀名
    /// - Returns: 资源后缀名
    func suffix() -> String {
        switch self {
        case .thumbImage:
            return ".jpg"
        case .originImage:
            return ".png"
        case .video:
            return ".mp4"
        case .audio:
            return ".mp3"
        }
    }
}

import Photos
import SDWebImage

struct BPMediaModel: Mappable, Hashable, Equatable, Any {
    /// 资源ID
    var id: String = ""
    /// 资源名称
    var name: String = ""
    /// 资源类型
    var type: BPMediaType = .thumbImage
    /// 缩略图本地地址
    var thumbnailLocalPath: String?
    /// 缩略图网络地址
    var thumbnailRemotePath: String?
    /// 原图本地地址
    var originLocalPath: String?
    /// 原图网络地址
    var originRemotePath: String?
    /// 视频时长
    var videoTime: TimeInterval = .zero


    /// 显示缩略图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    func getThumbImage(progress: ((CGFloat) ->Void)?, completion: DefaultImageBlock?) {
        if let path = self.thumbnailLocalPath, let image = UIImage(named: path) {
            completion?(image)
        } else {
            guard let path = self.thumbnailRemotePath else {
                completion?(nil)
                return
            }
            BPDownloadManager.share.image(name: "ThumbImage", urlStr: path, type: .thumbImage, progress: progress, completion: completion)
        }
    }

    /// 显示原图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    func getOriginImage(progress: ((CGFloat) ->Void)?, completion: DefaultImageBlock?) {
        if let path = self.originLocalPath, let image = UIImage(named: path) {
            completion?(image)
        } else {
            guard let path = self.originRemotePath else {
                completion?(nil)
                return
            }
            BPDownloadManager.share.image(name: "OriginImage", urlStr: path, type: .originImage, progress: progress, completion: completion)
        }
    }

    // 默认获取原图，如果没有则获取缩略图
    func getImage(progress: ((CGFloat) ->Void)?, completion: DefaultImageBlock?) {
        self.getOriginImage(progress: progress) { (image) in
            if let _image = image {
                completion?(_image)
            } else {
                // 获取缩略图
                self.getThumbImage(progress: progress, completion: completion)
            }
        }
    }

    init() {}

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        self.id                  <- map["id"]
        self.name                <- map["name"]
        self.type                <- (map["type"], EnumTransform<BPMediaType>())
        self.thumbnailLocalPath  <- map["thumbnailLocalPath"]
        self.thumbnailRemotePath <- map["thumbnailRemotePath"]
        self.originLocalPath     <- map["originLocalPath"]
        self.originRemotePath    <- map["originRemotePath"]
        self.videoTime           <- map["videoTime"]
    }

    // MARK: ==== Tools ====
    private func queryImageCache(path: String, block: DefaultImageBlock) {

    }
    
}
