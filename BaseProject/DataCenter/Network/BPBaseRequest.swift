//
//  BPBaseRequest.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import UIKit

let kClientSecret: String = "VQ-(,eTRZ(?8" + "\\" + "wyPZC,7"

public enum BPHTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

protocol YYBaseRequest {
    var method: BPHTTPMethod { get }
    var header: [String : String] { get }
    var parameters: [String : Any?]? { get }
    var url: URL { get }
    var path: String { get }

    func handleHeader(parameters: [String : Any?]?, headers: [String : String]?) -> [String : String]
}

extension YYBaseRequest {

    public var header: [String : String] {
        let _header = ["Content-Type"   : "application/json",
                       "Connection"     : "keep-alive",
                       "YY-OS-VERSION"  : UIDevice.OSVersion,
                       "YY-APP-VERSION" : Bundle.appVersion,
                       "YY-CHANNEL-ID"  : "AppStore",
                       "YY-CLIENT-ID"   : "100",
                       "YY-BUNDLE-ID"   : Bundle.bundleIdentifier,
                       //                       "YY-UDID"        : UIDevice.openUDID,
            "YY-MODEL"       : UIDevice.deviceName,
            //                       "YY-GPS-LNG"     : YYLocationManager.default.longitude,
            //                       "YY-GPS-LAT"     : YYLocationManager.default.latitude,
            //                       "YY-GPS-ALT"     : YYLocationManager.default.altitude,
            "YY-TIMESTAMP"   : "\(Int(Date().timeIntervalSince1970))"]

        return _header
    }

    public var parameters: [String : Any?]? {
        return nil
    }

    public var baseURL: URL {
        return URL(string: "https://api-test.helloyouyou.com")!
    }

    public var method: BPHTTPMethod {
        return .get
    }

    public var url: URL {
        return URL(string: baseURL.absoluteString + path)!
    }

    public var path: String { return "" }

    func handleHeader(parameters: [String : Any?]?, headers: [String : String]? = nil) -> [String : String] {

        var _header: [String : String] = self.header
        if headers != nil { _header = headers!}

        if let sessID = UserDefaults.standard.unarchivedObject(forkey: "YY-SESSID") as? String {
            _header["YY-SESSID"] = sessID
        }


        var sign: String = ""
        let sortKeys: [String] = parameters?.keys.sorted() ?? []
        for key in sortKeys {
            if key == "file" || key == "file_info" { continue }
            var value: String = ""
            if parameters?[key] is Int {
                value = String(parameters?[key] as! Int)
            }else if parameters?[key] is String {
                value = (parameters?[key] as? String ?? "")
            }
            sign += (key + "=" + value + "&")
        }

        sign += _header["YY-TIMESTAMP"] ?? ""

        if sign.last == "&" {
            sign += kClientSecret
        }else{
            sign += "&" + kClientSecret
        }

        _header["YY-SIGN"] = sign.sha1()

        return _header
    }
}

