//
//  AlgorithmModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper

enum AlgorithmType: String {
    case bubble = "冒泡排序"
    case choose = "选择排序"
}

struct AlgorithmModel: Mappable {

    init?(map: Map) {}

    mutating func mapping(map: Map) {}
}
