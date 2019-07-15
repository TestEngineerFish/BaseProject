//
//  UIDevice+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import UIKit.UIDevice
import SAMKeychain
import CommonCrypto

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

public extension UIDevice {

    //操作系统版本号
    static let systemOperationVersion: Double = {
        return Double(UIDevice.current.systemVersion) ?? 0.0
    }()

    //设备名称
    static let deviceName: String = {
        return UIDevice.current.name
    }()

    static let deviceModel: String = {
        return UIDevice.current.model
    }()

    //OS版本号
    static let OSVersion: String = {
        return UIDevice.current.systemName + UIDevice.current.systemVersion
    }()

    //openUDID
    static let openUDID: String = {
        var localOpenUDID: String = SAMKeychain.openUDID
        if !localOpenUDID.isEmpty {
            return localOpenUDID
        }

        var cStr: String = ProcessInfo.processInfo.globallyUniqueString
        let strLen = CC_LONG(cStr.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)

        CC_MD5(cStr, strLen, result)

        let udid: String = String(format: "%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08lx", result[0], result[1], result[2], result[3],
                                  result[4], result[5], result[6], result[7],
                                  result[8], result[9], result[10], result[11],
                                  result[12], result[13], result[14], result[15],
                                  arc4random() % 4294967295)
        SAMKeychain.openUDID = udid

        return udid
    }()
}
