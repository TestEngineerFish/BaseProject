//
//  YYShieldListModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/17.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import ObjectMapper

class YYShieldListModel: YYBaseModel {

    var total: Int?
    var page: Int = 1
    var hasMore: Bool = false
    var list: [YYShieldModel]?

    override func mapping(map: Map) {
        super.mapping(map: map)

        total <- map["total"]
        page <- map["page"]
        list <- map["list"]
        hasMore <- map["has_more"]
    }

}

class YYShieldModel: YYHomePageUserModel {
    //    var nickName: String?
    //    var avatarUrl: String?
    //    var user_ID : NSInteger?
    //
    //    override func mapping(map: Map) {
    //        super.mapping(map: map)
    //
    //        nickName <- map["nickname"]
    //        avatarUrl <- map["avatar"]
    //        userID <- map["user_id"]
    //    }
}

class YYHomePageUserModel: YYUserModel {
    var coverUrl: String?
    var isInvisiblied: Int?     // 是否设置了对TA好友隐身，1表是；0表否
    var isShielded: Bool?       // 是否屏蔽TA，1表是；0表否

    override func mapping(map: Map) {
        super.mapping(map: map)

        coverUrl      <- map["cover"]
        isShielded    <- map["has_shielded"]
        isInvisiblied <- map["has_invisiblied"]
    }
}
