//
//  YYPrivacySettingModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/17.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import ObjectMapper

class YYPersonalSettingModel: YYBaseModel {
    var id: Int?
    var name: String?
    var sex: Int?
    var birthday: String?
    var avatar: String?
    var createdAt: String?
    var state: Int?
    var stateCode: Int?
    var cover: String?
    var isRealHumanFace: Int?

    var age: Int? {
        if let b = birthday {
            let date = YYDateFormater.share.dateFromYMD(with: b)
            return date?.age()
        }
        return nil
    }

    override func mapping(map: Map) {
        super.mapping(map: map)

        id <- map["user_id"]
        name <- map["nickname"]
        sex <- map["sex"]
        birthday <- map["birthday"]
        avatar <- map["avatar"]
        createdAt <- map["created_at"]
        state <- map["state"]
        stateCode <- map["state_code"]
        isRealHumanFace <- map["is_me_really_face"]
        cover <- map["cover"]
    }


}

class YYPrivacySettingModel: YYBaseModel {
    var age: Int?
    var sex: Int?
    var location: Int?

    override func mapping(map: Map) {
        super.mapping(map: map)

        age <- map["age"]
        sex <- map["sex"]
        location <- map["location"]
    }
}

class YYCheckUpdateModel: YYBaseModel {

    static var `default` = YYCheckUpdateModel()

    var hasNewVersion: Bool?
    var mustUpdate: Bool?
    var newVersion: String?
    var desc: String?
    var downloadUrl: String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        hasNewVersion <- map["have_new_version"]
        mustUpdate <- map["must_update"]
        newVersion <- map["newest_version"]
        desc <- map["desc"]
        downloadUrl <- map["download_url"]

    }
}

