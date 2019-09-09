//
//  YYBaseModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import ObjectMapper

/**
 * 数据模型基类
 */
public class YYBaseModel: NSObject, Mappable {

    override init() {}
    
    required public init?(map: Map) {}

    /** 子类只需要重写改方法，进行字段绑定 */
    public func mapping(map: Map) {}
}
