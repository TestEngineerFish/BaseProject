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
    case image
    case video
}

struct BPMediaModel: Mappable, Hashable {
    /// 资源ID
    var id: Int = 0
    /// 资源名称
    var name: String = ""
    /// 资源类型
    var type: BPMediaType = .image
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
    func getThumbImage(progress: ((CGFloat) ->Void)?, completion: ((UIImage?)->Void)?) {
        self.loadImage(localPath: thumbnailLocalPath, remotePath: thumbnailRemotePath, progress: progress, completion: completion)
    }

    /// 显示原图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    func getOriginImage(progress: ((CGFloat) ->Void)?, completion: ((UIImage?)->Void)?) {
        self.loadImage(localPath: originLocalPath, remotePath: originRemotePath, progress: progress, completion: completion)
    }

    private func loadImage(localPath: String?, remotePath: String?, progress: ((CGFloat) ->Void)?, completion: ((UIImage?)->Void)?) {
        if let path = localPath, let image = UIImage(named: path) {
            completion?(image)
        } else {
            guard let path = remotePath, let url = URL(string: path) else {
                return
            }
            UIImageView().kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))]) { (receivedSize, totalSize) in
                let progressValue = CGFloat(receivedSize)/CGFloat(totalSize)
                progress?(progressValue)
                BPLog(progressValue)
            } completionHandler: { (result: Result<RetrieveImageResult, KingfisherError>) in
                switch result {
                case .success(let imageResult):
                    completion?(imageResult.image)
                case .failure(let error):
                    BPLog("资源下载失败，地址：\(path), 原因：" + (error.errorDescription ?? ""))
                    completion?(nil)
                }
            }
        }
    }

    init() {}

    init?(map: Map) {}

    mutating func mapping(map: Map) {}

}
