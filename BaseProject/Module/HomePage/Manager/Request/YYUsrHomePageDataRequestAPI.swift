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

    public var parameters: [String : Any?]? {
        switch self {
        case .fetchWantToKnowQuestionList:
            return nil
        case .updateIntroducation(let user_id, let content, let file, let voice_len, let attach_ids, let decibel, let videoId):
            let params: [String:Any?] = ["user_id" : user_id, "content": content, "file" : file, "voice_len" : voice_len, "attach_ids" : attach_ids, "voice_decibel" : decibel, "video_id" : videoId]
            return params
        }
    }
}
