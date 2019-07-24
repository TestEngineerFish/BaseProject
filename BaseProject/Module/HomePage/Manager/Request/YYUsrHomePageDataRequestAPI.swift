//
//  YYUsrHomePageDataRequestAPI.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/17.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


public enum YYUsrHomePageDataRequestAPI: YYBaseRequest {

    // 介绍内容操作（新增、点评）
    case updateIntroducation(user_id: Int, content: String?, file: Any?, voice_len: Int?, attach_ids: String?, decibel: String?, videoId: String?)

    // 获取介绍人问题列表
    case fetchWantToKnowQuestionList

}

extension YYUsrHomePageDataRequestAPI {
    public var method: YYHTTPMethod {
        switch self {
        case .fetchWantToKnowQuestionList:
            return .get
        case .updateIntroducation:
            return .post
        }

    }

    public var path: String {
        switch self {
        case .updateIntroducation:
            return "/v1/introduce/save"         // 介绍内容：新增/修改 点评
        case .fetchWantToKnowQuestionList:
            return "/v1/question/getlist"       // 获取介绍人问题列表
        }
    }

    public var parameters: [String : Any]? {
//        return ["key":"value"]
        return nil
    }

    public var postJson: Any? {
        switch self {
        case .fetchWantToKnowQuestionList:
            // 如果是Get请求,则返回Nil. 在具体请求时,会判断postJson是否有为Nil,来区分Get和Post请求
            return nil

        case .updateIntroducation(let user_id, let content, let file, let voice_len, let attach_ids, let decibelStr, let videoId):
            var params: [String : Any]  = ["user_id" : user_id]
            if let p = content, !p.isEmpty {
                params["content"]       = p
            }
            if let p = file {
                params["file"]          = p
            }
            if let p = voice_len {
                params["voice_len"]     = p
            }
            if let p = attach_ids {
                params["attach_ids"]    = p
            }
            if let p = decibelStr {
                params["voice_decibel"] = p
            }
            if let p = videoId {
                params["video_id"]      = p
            }

            return params
        }
    }

}
