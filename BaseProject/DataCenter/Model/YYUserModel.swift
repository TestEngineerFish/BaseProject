//
//  YYUserModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import ObjectMapper

/**
 * 用户基础数据模型
 */
public class YYUserModel: YYBaseModel {
    
    static var `default` = YYUserModel()
    
    var userID: Int = 0
    var nickname: String?
    var avatar: String?
    var avatarImage: UIImage?
    var gender: Int?    // 性别 0未知；1女；2男
    var birthday: String?
    var age: Int?
    var phone: String?
    var city: String?
    var bindInfo: [String]?
    var imAccount: YYUserIMAccount?
    var state: Int? = 0 // 正常0，封号1
    var stateCode: Int? // 10107 头像和昵称都不通过; 10105 头像不通过; 10108 昵称不通过
    var bindStatus: Int?
    
    var isHelper: Bool = false
    
    
    // 第三方信息
    var accessToken: String?
    var openid: String?
    var unionid: String?
    var appType: String?    // 1表weixin；2表示QQ
    
    var thirdAvatar: String?
    var thirdName: String?
    var thirdSex: String?
    var thirdLocation: String?
    
    var profileCompletion: Int?
    
    //是否完成了新手引导 1：完成; 0：未完成
    var noviceGuide: Int?
    
    override public func mapping(map: Map) {
        super.mapping(map: map)
        
        userID <- map["user_id"]
        nickname <- map["nickname"]
        avatar <- map["avatar"]
        gender <- map["sex"]
        birthday <- map["birthday"]
        age <- map["age"]
        city <- map["city"]
        imAccount <- map["yunxin_account"]
        bindInfo <- map["bind_info"]
        state <- map["state"]
        stateCode <- map["state_code"]
        bindStatus <- map["bind_status"]
        
        isHelper <- map["is_helper"]
        
        profileCompletion <- map["profile_completed"]
        noviceGuide <- map["novice_guide"]
    }
    
    
}

/**
 * 云信用户信息
 */
class YYUserIMAccount: YYBaseModel {
    var accid: String?
    var token: String?
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        accid <- map["accid"]
        token <- map["token"]
    }
}





extension YYUserModel {
    
    /** 获取当前用户ID */
    public class func currentUserID() -> Int {
        if let uid = UserDefaults.standard.unarchivedObject(forkey: kAppUserLoginStatus) as? Int {
            return uid
        }
        return 0
    }
    
    /** 获取登录状态 */
    public class func hasBeenLogin() -> Bool {
        return currentUserID() > 0
    }
    
    /** 保存登录状态 */
    func saveLoginStatus() {
        UserDefaults.standard.archive(object: self.userID, forkey: kAppUserLoginStatus)
        if noviceGuide == 1 {
            saveGuideStatus()
        }
    }
    func clearLoginStatus() {
//        YYCache.set(nil, forKey: numberType.CurrentCoin.rawValue)
//        YYCache.set(nil, forKey: numberType.YesterdayEarningsCoin.rawValue)
//        YYCache.set(nil, forKey: numberType.TodayEarningsCoin.rawValue)
        YYCache.set(nil, forKey: "StoredRawLocalContacts")
        YYCache.set(nil, forKey: "StoredOrderedLocalContacts")
        YYCache.set(nil, forKey: "FriendList")
        
        UserDefaults.standard.archive(object: nil, forkey: kAppUserLoginStatus)
        clearGuideStatus()
        clearInfo()
    }
    
    public class func hasBeenCompletedUserGuide() -> Bool {
        let key = kAppGuideStatus + String(YYUserModel.currentUserID())
        if let status = YYCache.object(forKey: key) as? Bool {
            return status
        }
        return false
    }
    
    /** 保存引导状态 */
    func saveGuideStatus() {
        let key = kAppGuideStatus + String(YYUserModel.currentUserID())
        YYCache.set(true, forKey: key)
    }
    func clearGuideStatus() {
        let key = kAppGuideStatus + String(YYUserModel.currentUserID())
        YYCache.remove(forKey: key)
    }
    
    /** 获取头像数据 */
    func avatarData() -> Data {
        return (avatarImage?.jpegData(compressionQuality: 0))!
    }
    
    func clearInfo() {
        accessToken = nil
        openid = nil
        unionid = nil
        appType = nil
        
        nickname = nil
        gender = nil
        birthday = nil
        avatar = nil
        avatarImage = nil
    }
    
    func clearThirdPartyInfoByNickNamePage() {
        self.clearInfo()
    }
    
    func clearThirdPartyInfoByAvatarPage() {
        accessToken = nil
        openid = nil
        unionid = nil
        appType = nil
        
        //        nickname = nil // 在头像页面使用第三方信息的时候，如果已经绑定过，不能清理 名称
        gender = nil
        birthday = nil
        avatar = nil
        avatarImage = nil
    }
    
    var genderDesc: String {
        if let _gender = self.gender {
            switch _gender {
            case 1:
                return "她"
            case 2:
                return "他"
            default:
                return ""
            }
        }
        
        return ""
    }
}
