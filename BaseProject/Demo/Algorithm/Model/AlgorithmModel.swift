//
//  AlgorithmModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper

enum AlgorithmType: String {
    case bubbleSort    = "冒泡排序"
    case chooseSort    = "选择排序"
    case insertionSort = "插入排序"
    case shellSort     = "希尔排序"

    /// 是否双层显示
    func isDouble() -> Bool {
        switch self {
        case .insertionSort, .shellSort:
            return true
        default:
            return false
        }
    }
}

struct AlgorithmModel: Mappable {

    init?(map: Map) {}

    mutating func mapping(map: Map) {}
}
