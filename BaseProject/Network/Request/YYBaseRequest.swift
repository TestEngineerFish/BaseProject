//
//  YYBaseRequest.swift
//  YouYou
//
//  Created by pyyx on 2018/10/25.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation
import UIKit

let kClientSecret: String = "VQ-(,eTRZ(?8" + "\\" + "wyPZC,7"
//let kClientSecret: String = "rew@#44$%fds"

public enum YYHTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

protocol YYBaseRequest {
    var method: YYHTTPMethod { get }
    var header: [String : String] { get }
    var parameters: [String : Any]? { get }
    var url: URL { get }
    var path: String { get }
    var postJson: Any? { get }
    
    func handleHeader(parameters: [String : Any]?, headers: [String : String]?) -> [String : String]
}

extension YYBaseRequest {

    public var header: [String : String] {
        let _header = ["Content-Type" : "application/json",
                       "Connection" : "keep-alive",
                       "YY-OS-VERSION" : UIDevice.OSVersion,
                       "YY-APP-VERSION" : Bundle.appVersion,
                       "YY-CHANNEL-ID" : "AppStore",
                       "YY-CLIENT-ID" : "100",
                       "YY-BUNDLE-ID" : Bundle.bundleIdentifier,
                       "YY-UDID" : UIDevice.openUDID,
                       "YY-MODEL" : UIDevice.deviceName,
                       "YY-GPS-LNG" : YYLocationManager.default.longitude,
                       "YY-GPS-LAT" : YYLocationManager.default.latitude,
                       "YY-GPS-ALT" : YYLocationManager.default.altitude,
                       "YY-TIMESTAMP" : "\(Int(Date().timeIntervalSince1970))"]
        
        return _header
    }
    
    public var parameters: [String : Any]? {
        return nil
    }
    
    public var baseURL: URL {
        return URL(string: YYEVC.apiUrl)!
    }
    
    public var method: YYHTTPMethod {
        return .get
    }
    
    public var url: URL {
        return URL(string: baseURL.absoluteString + path)!
    }
    
    public var path: String { return "" }
    
    public var postJson : Any? { return nil }
    
    func handleHeader(parameters: [String : Any]?, headers: [String : String]? = nil) -> [String : String] {
        
        var _header: [String : String] = self.header
        if headers != nil { _header = headers!}
        
        let token: String? = UserDefaults.standard["user_token"] as? String
        if token?.isEmpty ?? false {
            _header["PYYX-SESSID"] = token
        }
        
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
