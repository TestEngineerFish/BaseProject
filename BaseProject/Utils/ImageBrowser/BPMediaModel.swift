//
//  BPImageModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/29.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper
import Kingfisher

struct BPMediaModel: Mappable {
    /// 资源ID
    var id: Int = 0
    /// 资源名称
    var name: String = ""
    /// 缩略图本地地址
    var thumbnailLocalPath: String?
    /// 缩略图网络地址
    var thumbnailRemotePath: String?
    /// 原图本地地址
    var originLocalPath: String?
    /// 原图网络地址
    var originRemotePath: String?


    /// 显示缩略图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    func showThumbImage(progress: ((CGFloat) ->Void)?, completion: ((UIImage?, String?)->Void)?) {
        self.loadImage(localPath: thumbnailLocalPath, remotePath: thumbnailRemotePath, progress: progress, completion: completion)
    }

    /// 显示原图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    func showOriginImage(progress: ((CGFloat) ->Void)?, completion: ((UIImage?, String?)->Void)?) {
        self.loadImage(localPath: originLocalPath, remotePath: originRemotePath, progress: progress, completion: completion)
    }

    private func loadImage(localPath: String?, remotePath: String?, progress: ((CGFloat) ->Void)?, completion: ((UIImage?, String?)->Void)?) {
        if let path = localPath, let image = UIImage(named: path) {
            completion?(image, nil)
        } else {
            guard let path = remotePath, let url = URL(string: path) else {
                return
            }
            UIImageView().kf.setImage(with: url, placeholder: nil, options: [.transition(ImageTransition.fade(1))]) { (receivedSize, totalSize) in
                let progressValue = CGFloat(receivedSize)/CGFloat(totalSize)
                progress?(progressValue)
            } completionHandler: { (result: Result<RetrieveImageResult, KingfisherError>) in
                do {
                    let imageResult = try result.get()
                    let image       = imageResult.image
                    completion?(image, nil)
                } catch {
                    completion?(nil, (error as NSError?)?.message)
                }
            }
        }
    }

    init() {}

    init?(map: Map) {}

    mutating func mapping(map: Map) {}

}
