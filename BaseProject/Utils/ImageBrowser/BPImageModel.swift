//
//  BPImageModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/29.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper

struct BPImageModel: Mappable {
    /// 缩略图本地地址
    var thumbnailLocalPath: String?
    /// 缩略图网络地址
    var thumbnailRemotePath: String?
    /// 原图本地地址
    var originLocalPath: String?
    /// 原图网络地址
    var originRemotePath: String?

    init() {}

    init?(map: Map) {}

    mutating func mapping(map: Map) {}

}
