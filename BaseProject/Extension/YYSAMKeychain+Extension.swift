//
//  YYSAMKeychain+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import SAMKeychain

extension SAMKeychain {
    struct YYSAMKeychainStruct {
        static let SSKeychainService: String = "service"
        static let SSKeychainOpenUDIDKey: String = "udid"
    }
    
    private static var _openUDID: String = ""
    static var openUDID: String {
        set {
            self.setPassword(newValue, forService: YYSAMKeychainStruct.SSKeychainService, account: openUDIDGenernalKey)
        }
        
        get {
            var error: NSError?
            let _opendUDID: String = password(forService: YYSAMKeychainStruct.SSKeychainService, account: openUDIDGenernalKey, error: &error) ?? ""
            return _opendUDID
        }
    }
    
    static let openUDIDGenernalKey: String = {
        return Bundle.bundleName + " - " + YYSAMKeychainStruct.SSKeychainOpenUDIDKey
    }()
}
