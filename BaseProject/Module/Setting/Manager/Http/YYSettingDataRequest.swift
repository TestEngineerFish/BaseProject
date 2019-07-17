//
//  YYSettingDataRequest.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/17.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

public enum YYSettingDataRequest: YYBaseRequest {
    // 修改
    case modifyPersonalInfo(nickname: String?, sex: Int?, birthday: String?, file: Any?, cover: Any?)
    // 获取隐私设置
    case getPrivacySetting
    // 修改隐私设置
    case modifyPrivacySetting(age: Int?, sex: Int?, geo: Int?)
    // 设置密码
    case passwordSetting(password: String, repassword: String)
    // 屏蔽列表
    case shieldlist(page: Int)
    // 我的好友圈
    case myfriendslist(page: String)
    // 上传日志
    case uploadLogFile(qaID: Int, cause: String, file: Any, logInfo: String, fileType: Int)
    // 检查更新
    case checkUpdate
    // 退出登录
    case logout
    // 更新新手引导状态
    case noviceGuide
}


extension YYSettingDataRequest {
    public var method: YYHTTPMethod {
        switch self {
        case .logout, .shieldlist, .checkUpdate:
            return .get
        case .uploadLogFile, .noviceGuide:
            return .post
        default:
            return .post
        }
    }

    public var path: String {
        switch self {
        case .modifyPersonalInfo:
            return "/v1/profile/update"
        case .getPrivacySetting:
            return "/v1/profile/getprivacy"
        case .modifyPrivacySetting:
            return "/v1/profile/setprivacy"
        case .passwordSetting:
            return "/v1/user/resetpassword"
        case .logout:
            return "/v1/user/logout"
        case .shieldlist :
            return "/v1/relation/shieldlist"
        case .myfriendslist:
            return "/v1/relation/friendslist"
        case .uploadLogFile:
            return "/v1/device/uploadlog"
        case .checkUpdate:
            return  "/v1/device/updateCheck"
        case .noviceGuide:
            return "/v1/user/noviceGuide"
        }
    }

    public var parameters: [String : Any]? {
        switch self {
        case .logout:
            return nil
        case .shieldlist(let page):
            return ["page" : page]
        default:
            return nil
        }
    }

    public var postJson: Any? {
        switch self {
        case .shieldlist, .myfriendslist, .getPrivacySetting, .checkUpdate, .logout, .noviceGuide:
            return nil
        case .modifyPersonalInfo(let nickname, let sex, let birthday, let file, let cover):
            return ["nickname" : nickname,
                    "sex" : sex,
                    "birthday" : birthday,
                    "file" : file,
                    "cover": cover]
        case .modifyPrivacySetting(let age, let sex, let geo):
            return ["age" : age,
                    "sex" : sex,
                    "location" : geo]
        case .passwordSetting(let password, let repassword):
            return["password" : password,
                   "repassword" : repassword]
        case .uploadLogFile(let qaID, let cause, let file, let logInfo, let fileType):
            return ["qa_id" : qaID,
                    "cause" : cause,
                    "file_info" : file,
                    "log_info" : logInfo,
                    "file_type" : fileType]
        }
    }
}
