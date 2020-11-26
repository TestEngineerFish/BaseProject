//
//  BPEmojiModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/18.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper

struct BPEmojiModel: Mappable {

    var name: String?
    var image: UIImage?
    init() {}
    init?(map: Map) {}
    mutating func mapping(map: Map) {}
}
