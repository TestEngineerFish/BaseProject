//
//  BPImageReviewModel.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/23.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation
import ObjectMapper

struct BPImageReviewModel: Mappable {

    /// 缩略图
    var thumImage: UIImage?
    /// 缩略图网络地址
    var thumImageUrlStr: String?
    /// 缩略图本地地址
    var thumImagePath: String?
    /// 原图
    var originImage: UIImage?
    /// 原图网络地址
    var originImageUrlStr: String?
    /// 原图本地地址
    var originImagePath: String?
    
    init() {}
    init?(map: Map) {}
    mutating func mapping(map: Map) {}
}
