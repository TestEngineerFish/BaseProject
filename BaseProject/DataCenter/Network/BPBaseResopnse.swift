//
//  BPBaseResopnse.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import ObjectMapper

protocol BPBaseResopnse: Mappable {

    /** 状态码 */
    var statusCode: Int { get }
    var statusMessage: String? { get }
    var warningDesc: String? { get }
    var response: URLResponse? { set get}
    var request: URLRequest? { set get}
}

public struct BPDefaultNilDataResponse: Mappable {
    public init?(map: Map) {}
    public mutating func mapping(map: Map) {}
}

public struct BPStructResponse<T: Mappable> : BPBaseResopnse {

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
        status  <- map["code"]
        message <- map["message"]
        warning <- map["warning"]
        data    <- map["data"]
    }
}

public struct BPStructDataArrayResponse<T: Mappable> : BPBaseResopnse {

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
        status    <- map["code"]
        message   <- map["message"]
        warning   <- map["warning"]
        dataArray <- map["data"]
    }

}

extension BPStructResponse {

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

extension BPStructDataArrayResponse {

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
