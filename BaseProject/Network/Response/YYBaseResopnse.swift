//
//  YYBaseResopnse.swift
//  YouYou
//
//  Created by pyyx on 2018/10/25.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation
import ObjectMapper

protocol YYBaseResopnse: Mappable {
    
    /** 状态码 */
    var statusCode: Int { get }
    var statusMessage: String? { get }
    var warningDesc: String? { get }
    var response: URLResponse? { set get}
    var request: URLRequest? { set get}
}

public struct YYDefaultNilDataResponse: Mappable {
    public init?(map: Map) {}
    public mutating func mapping(map: Map) {}
}

public struct YYStructResponse<T: Mappable> : YYBaseResopnse {
    
    public var response: URLResponse?
    public var request: URLRequest?
    
    private var status: Int = 0
    private var message: String?
    private var warning: String?
    
    public var data:T?
    
    /** 时间戳 */
    public var timestamp:CLong = 0
    
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {
        status <- map["code"]
        message <- map["message"]
        warning <- map["warning"]
        data <- map["data"]
    }
}

public struct YYStructDataArrayResponse<T: Mappable> : YYBaseResopnse {
    
    public var response: URLResponse?
    public var request: URLRequest?
    
    private var status: Int = 0
    private var message: String?
    private var warning: String?
    
    public var dataArray:[T]?
    /** 时间戳 */
    public var timestamp:CLong = 0
    
    public init?(map: Map) {}
    
    public mutating func mapping(map: Map) {
        status <- map["code"]
        message <- map["message"]
        warning <- map["warning"]
        dataArray <- map["data"]
    }
    
}

extension YYStructResponse {
    
    public var statusCode: Int {
        return status
    }
    
    public var statusMessage: String? {
        return message
    }
    
    var warningDesc: String? {
        return warning
    }
}

extension YYStructDataArrayResponse {
    
    public var statusCode: Int {
        return status
    }
    
    public var statusMessage: String? {
        return message
    }
    
    var warningDesc: String? {
        return warning
    }
}

