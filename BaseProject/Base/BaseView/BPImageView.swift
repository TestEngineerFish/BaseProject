//
//  BPBaseImageView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/7.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Kingfisher

class BPImageView: UIImageView {
    /// 下载进度闭包
    typealias ImageDownloadProgress   = (CGFloat) -> Void
    /// 下载完成闭包
    typealias ImageDownloadCompletion = ((_ image: UIImage?, _ error: Error?, _ imageURL: URL?) -> Void)

    func showImage(with imageStr: String, placeholder: UIImage? = nil, completion: ImageDownloadCompletion? = nil, downloadProgress: ImageDownloadProgress? = nil) -> Void {
        
        guard let imageURL = URL(string: imageStr) else { return }
        
        self.kf.setImage(with: imageURL, placeholder: placeholder, options: [], progressBlock: { (receivedByte, totalByte) in
            let progress = CGFloat(receivedByte / totalByte)
            downloadProgress?(progress)
        }) { (result: Result<RetrieveImageResult, KingfisherError>) in
            switch result {
            case .success(let data):
                self.image = data.image
                completion?(data.image, nil, data.source.url)
            case .failure(let error):
                completion?(nil, error, imageURL)
            }
        }
    }
}
