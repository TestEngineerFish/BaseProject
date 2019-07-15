//
//  YYWantToKnowQuestionListModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import ObjectMapper

class YYWantToKnowQuestionListModel: YYBaseModel{

    var list: [YYWantToKnowQuestionModel]?

    override func mapping(map: Map) {
        super.mapping(map: map)
        list <- map["list"]
    }
}

class YYWantToKnowQuestionModel: YYBaseModel {

    var id: Int = 0
    var title: String = ""

    override func mapping(map: Map) {
        super.mapping(map: map)
        id    <- map["id"]
        title <- map["title"]
    }
}
