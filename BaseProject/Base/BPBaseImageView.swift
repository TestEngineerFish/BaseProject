//
//  BPBaseImageView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/7.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Kingfisher

class BPBaseImageView: UIImageView {
    // 设置闭包
    typealias TouchOnImageBlock       = (Source) -> Void
    typealias ImageDownloadCompletion = ((_ image: UIImage?, _ error: Error?, _ imageURL: URL?) -> Void)
    typealias ImageDownloadProgress   = (CGFloat) -> Void

    fileprivate var shouldShowProgress = false
    fileprivate var imageSource: Source?// 接收下载后的图片存储

    /// 图片点击闭包
    var touchOnBlock: TouchOnImageBlock? {
        willSet {
            isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(with:)))
            addGestureRecognizer(tap)
        }
    }

    @objc func tapped(with gestureRecognizer: UITapGestureRecognizer) {
        guard let source = imageSource else {return}
        touchOnBlock?(source)
    }

    func showImage(with imageStr: String, placeholder: UIImage? = nil, downloadProgress: ImageDownloadProgress? = nil, completion: ImageDownloadCompletion? = nil) -> Void {
        guard let imageURL = URL(string: imageStr) else { return }
        self.kf.setImage(with: imageURL, placeholder: placeholder, options: [], progressBlock: { (receivedByte, totalByte) in
            let progress = CGFloat(receivedByte / totalByte)
            downloadProgress?(progress)
        }) { (result: Result<RetrieveImageResult, KingfisherError>) in
            switch result {
            case .success(let data):
                self.imageSource = data.source
                completion?(data.image, nil, data.source.url)
            case .failure(let error):
                print(error.errorDescription ?? "error message")
            }
        }
    }
}
