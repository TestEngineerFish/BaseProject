//
//  YYUsrHomePageDataRequestAPI.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/17.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


public enum YYUsrHomePageDataRequestAPI: YYBaseRequest {
    // 主页数据（我的，直接好友、间接好友）
    case homepage(userId: Int?, accid: String?)

    // 介绍内容操作（新增、点评）
    case updateIntroducation(user_id: Int, content: String?, file: Any?, voice_len: Int?, attach_ids: String?, decibel: String?, videoId: String?)

    // 编辑介绍内容
    case getNeedEditIntroducation(usrId: Int, introducationId: Int)

    // 介绍内容操作(删除点评)
    case deleteIntroducation(userId: Int, introducationId: Int)

    // 隐藏介绍内容
    case hideIntroducation(userId: Int, introducationId: Int, status: Int)

    // 介绍内容点赞、取消点赞
    case likesForIntroducation(userId: Int, introducationId: Int)

    // 了解我/他
    case konwAboutComment(userId: Int, page: String?)

    //理解我/他列表
    case konwAboutList(userId: Int, page: Int, fromUserId: Int?)

    // 好友圈
    case myFriendsList(userId: Int, page: Int, type: Int?)

    // 亮点标签列表
    case videoTagList(userID: Int, page: Int)

    // 标签下的视频列表
    case videoList(userID: Int, tagID: Int, page: Int)

    // 删除视频标签
    case deleteVideoTag(tagId: Int)

    // 视频标签是否删除
    case isVideoTagDelete(tagId: Int)

    // 介绍人列表（原共同好友列表）
    case introducerList(targetUserId: Int, page: Int)

    // 选择问题(换一个问题)
    case changeQuestion(userId: Int, questionId: String)

    // 获取一个问题
    case fetchOneQuestion(userId: Int, questionId: String)

    // 保存问题回答
    case saveQuestionAnswer(userId: String?, questionIds: String?, tagIds: String?)

    // 添加自定义标签
    case saveCustomTag(tagName: String?, questionsId: String?, userId: String?)

    // 获取视频播放地址
    case fetchVideoUrl(introducatioId: Int)

    // 获取介绍人问题列表
    case fetchWantToKnowQuestionList

    // 求介绍 -- 问题提交
    case savaQuestionWithWantToKnow(friendsId:String, uid:Int, content: String)

}

extension YYUsrHomePageDataRequestAPI {
    public var method: YYHTTPMethod {
        switch self {
        case .homepage, .konwAboutComment, .konwAboutList, .myFriendsList, .videoTagList, .videoList, .getNeedEditIntroducation, .introducerList, .changeQuestion, .fetchOneQuestion, .fetchVideoUrl, .isVideoTagDelete, .fetchWantToKnowQuestionList:
            return .get
        case .updateIntroducation, .deleteIntroducation, .hideIntroducation, .likesForIntroducation, .saveCustomTag, .saveQuestionAnswer, .deleteVideoTag, .savaQuestionWithWantToKnow:
            return .post
        }

    }

    public var path: String {
        switch self {
        case .homepage:
            return "/v2/profile/home"           // 主页
        case .updateIntroducation:
            return "/v1/introduce/save"         // 介绍内容：新增/修改 点评
        case .deleteIntroducation:
            return "/v1/introduce/del"          // 介绍内容：删除
        case .hideIntroducation:
            return "/v1/introduce/hide"         // 介绍内容隐藏
        case .likesForIntroducation:
            return "/v1/introduce/likes"        // 介绍内容：点赞、取消点赞
        case .konwAboutComment:
            return "/v1/comment/knowme"         // 了解我、了解TA
        case .konwAboutList:
            return "/v1/introduce/knowme"       // 介绍内页
        case .myFriendsList:
            return "/v1/relation/friendslist"   // 好友圈
        case .videoTagList:
            return "/v1/video/getvideotags"
        case .videoList:
            return "/v1/video/getvideos"
        case .deleteVideoTag:
            return "/v1/video/deltag"
        case .isVideoTagDelete:
            return "/v1/video/isdeltag"
        case .introducerList:                   // 介绍人列表
            return "/v1/relation/commonfriendslist"
        case .getNeedEditIntroducation:
            return "/v1/introduce/getone"       // 获取当前需要编辑的介绍
        case .changeQuestion:
            return "/v1/question/getQuestion"   // 选择问题或者换一个问题
        case .fetchOneQuestion:
            return "/v1/question/getQuestionById" // 根据问题 id 获取问题
        case .saveCustomTag:
            return "/v1/tags/saveTag"           // 添加自定义标签
        case .saveQuestionAnswer:
            return "/v1/tags/save"              // 保存问题回答
        case .fetchVideoUrl:
            return "/v1/Introduce/getvideourl"  // 获取需要播放的视频地址
        case .fetchWantToKnowQuestionList:
            return "/v1/question/getlist"       // 获取介绍人问题列表
        case .savaQuestionWithWantToKnow:
            return "/v1/question/save"          // 求介绍 -- 问题提交
        }
    }

    public var parameters: [String : Any]? {
        switch self {
        case .homepage(let userId, let accid):
            var homepageParams: [String : Any] = [:]
            if let _accid = accid {
                homepageParams["accid"] = _accid
            }else{
                if let _userId = userId {
                    homepageParams["user_id"] = _userId
                }
            }
            return homepageParams
        case .konwAboutList( let userid, let page, let fromUserId):
            return ["user_id" : userid, "page" : page, "from_user_id": fromUserId]
        case .myFriendsList(let userId, let page, let type):
            return ["target_uid": userId, "page": page, "type": type]
        case .videoTagList(let userID, let page):
            return ["user_id": userID, "page": page]
        case .videoList(let userID, let tagID, let page):
            return ["user_id": userID, "tag_id": tagID, "page": page]
        case .getNeedEditIntroducation(let usrId, let introducationId):
            return ["user_id" : usrId, "introduce_id" : introducationId]
        case .introducerList(let targetUserId, let page):
            return ["target_uid": targetUserId, "page": page]
        case .changeQuestion(let userId, let questionId):
            return ["user_id" : userId, "id" : questionId]
        case .fetchOneQuestion(let userId, let questionId):
            return ["user_id" : userId, "id" : questionId]
        case .fetchVideoUrl(let introducatioId):
            return ["id" : introducatioId]
        case .isVideoTagDelete(let tagId):
            return ["tag_id" : tagId]
        default:
            return nil
        }
    }

    public var postJson: Any? {
        switch self {
        case .homepage, .konwAboutComment, .getNeedEditIntroducation, .myFriendsList, .videoTagList, .videoList, .introducerList, .changeQuestion, .fetchOneQuestion, .fetchVideoUrl, .isVideoTagDelete, .fetchWantToKnowQuestionList:
            return nil

        case .updateIntroducation(let user_id, let content, let file, let voice_len, let attach_ids, let decibelStr, let videoId):
            var params: [String : Any] = ["user_id" : user_id]
            if let p = content, !p.isEmpty {
                params["content"] = p
            }
            if let p = file {
                params["file"] = p
            }
            if let p = voice_len {
                params["voice_len"] = p
            }
            if let p = attach_ids {
                params["attach_ids"] = p
            }
            if let p = decibelStr {
                params["voice_decibel"] = p
            }
            if let p = videoId {
                params["video_id"] = p
            }

            return params
        case .hideIntroducation(let userId, let introducationId, let status):
            return ["owner_user_id" : userId, "introduce_id" : introducationId, "status" : status]
        case .deleteIntroducation(let userId, let introducationId):
            return ["user_id" : userId, "introduce_id" : introducationId]
        case .likesForIntroducation(let userId, let introducationId):
            return ["user_id" : userId, "introduce_id" : introducationId]
        case .saveCustomTag(let tagName, let questionId, let userId):
            return ["tag_name" : tagName, "question_id" : questionId, "user_id" : userId]
        case .saveQuestionAnswer(let userId, let questionIds, let tagIds):
            return ["user_id" : userId, "questions_id" : questionIds, "tags_id" : tagIds]
        case .konwAboutList:
            return nil
        case .deleteVideoTag(let tagID):
            return ["tag_id" : tagID]
        case .savaQuestionWithWantToKnow(let friendId, let uid, let content):
            return ["same_friend_ids" : friendId, "current_uid": uid, "questions": content]
        }
    }

}
