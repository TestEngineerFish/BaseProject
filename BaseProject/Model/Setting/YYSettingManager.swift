//
//  YYSettingManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/16.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

struct YYSettingManager {
    
    // 修改资料
    public static func modifyPersonalInfo(_ nickname: String? = nil, sex: Int? = nil, birthday: String? = nil, cover: Any? = nil, file: Any? = nil, completion: @escaping ((_ settingModel: YYPersonalSettingModel?, _ errorMsg: String? ) -> Void)) {
        
        let request = YYSettingDataRequest.modifyPersonalInfo(nickname: nickname, sex: sex, birthday: birthday, file: file, cover: cover)
        
        YYNetworkService.default.httpUploadRequestTask(YYStructResponse<YYPersonalSettingModel>.self, request: request, success: { (response) in
            completion(response.data, nil)
        }) { (error) in
            completion(nil, error.message)
        }
    }
    
    // 获取隐私设置
    public static func GetPrivacySetting(completion: @escaping ((_ settingModel: YYPrivacySettingModel?, _ errorMsg: String? ) -> Void)) {
        
        let request = YYSettingDataRequest.getPrivacySetting
        
        YYNetworkService.default.httpRequestTask(YYStructResponse<YYPrivacySettingModel>.self, request: request, success: { (response) in
            completion(response.data, nil)
        }) { (error) in
            completion(nil, error.message)
        }
    }
    
    // 修改隐私设置
    public static func ModifyPrivacySetting(_ age: Int?, _ sex: Int?, _ geo: Int?, completion: @escaping ((_ settingModel: YYPrivacySettingModel?, _ errorMsg: String? ) -> Void)) {
        
        let request = YYSettingDataRequest.modifyPrivacySetting(age: age, sex: sex, geo: geo)
        
        YYNetworkService.default.httpRequestTask(YYStructResponse<YYPrivacySettingModel>.self, request: request, success: { (response) in
            completion(response.data, nil)
        }) { (error) in
            completion(nil, error.message)
            
        }
    }
    
    // 设置密码
    public static func PasswordSetting(_ password: String, _ repassword: String , completion: @escaping ((_ settingModel: YYPersonalSettingModel?, _ errorMsg: String? ) -> Void)) {
        let request = YYSettingDataRequest.passwordSetting(password: password, repassword: repassword)
        YYNetworkService.default.httpRequestTask(YYStructResponse<YYPersonalSettingModel>.self, request: request, success: { (response) in
            completion(response.data, nil)
        }) { (error) in
            completion(nil, error.message)
        }
    }
    
    
    // 退出登录
    public static func logout(completion: @escaping ((_ settingModel: YYPersonalSettingModel?, _ errorMsg: String? ) -> Void)) {
        let request = YYSettingDataRequest.logout
        YYNetworkService.default.httpRequestTask(YYStructResponse<YYPersonalSettingModel>.self, request: request, success: { (response) in
            completion(response.data, nil)
        }) { (error) in
            completion(nil, error.message)
        }
    }
    
    // 屏蔽列表
    public static func shieldlist(_ page: Int, completion: @escaping ((_ shieldListModel: YYShieldListModel?, _ errorMsg: String? ) -> Void)) {
        
        let request = YYSettingDataRequest.shieldlist(page: page)
        YYNetworkService.default.httpRequestTask(YYStructResponse<YYShieldListModel>.self, request: request, success: { (response) in
            completion(response.data, nil)
        }) { (error) in
            completion(nil, error.message)
        }
    }
    
    // 上传日志
    public static func uploadLogFile(_ file: Any, fileName: String, completion: @escaping (_ model: YYBaseModel?, _ errorMsg: String?) -> Void) {
        let request = YYSettingDataRequest.uploadLogFile(qaID: 11001, cause: "日志", file: file, logInfo: "日志上传", fileType: 1)
        YYNetworkService.default.httpUploadRequestTask(YYStructResponse<YYBaseModel>.self, request: request, mimeType: "application/octet-stream", fileName: fileName, success: { (response) in
            completion(response.data, nil)
        }) { (error) in
            completion(nil, error.message)
        }
    }
    
    // 版本更新
    public static func checkUpdate(completion: @escaping (_ checkUpdateModel: YYCheckUpdateModel?, _ errorMsg: String?) -> Void) {
        
        let request = YYSettingDataRequest.checkUpdate
        YYNetworkService.default.httpRequestTask(YYStructResponse<YYCheckUpdateModel>.self, request: request, success: { (response) in
            completion(response.data, nil)
        }) { (error) in
            completion(nil, error.message)
        }
    }
    
    public static func noviceGuide(completion: ((String?) -> Void)? = nil) {
        let request = YYSettingDataRequest.noviceGuide
        YYNetworkService.default.httpRequestTask(YYStructResponse<YYBaseModel>.self, request: request, success: { (response) in
            completion?(nil)
        }) { (error) in
            completion?(error.message)
        }
    }
    
}
