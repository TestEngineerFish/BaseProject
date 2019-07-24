//
//  YYNetFoxHTTPModel.swift
//  YouYou
//
//  Created by pyyx on 2018/12/4.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

public class YYNetFoxHTTPResponseModel: Mappable, YYNetFoxHTTPModelProtocol {
    
    var responseStatus: Int?
    var responseType: String?
    var responseDate: Date?
    var responseHeaders: [AnyHashable: Any]?
    var responseBodyLength: Int?
    var responseBodyString: String?
    
    var randomHash: NSString?
    var shortType: NSString = HTTPModelShortType.OTHER.rawValue as NSString
    var noResponse: Bool = true
    
    var requestStartTime: String?
    var requestCompletedTime: String?
    var requestDuration: TimeInterval = 0.0
    
    var initialResponseTime: String?
    var serializationDuration: TimeInterval = 0.0
    var serializationCompletedTime: String?
    var latency: TimeInterval = 0.0
    var totalDuration: TimeInterval = 0.0
    
    init() {}
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {
        responseStatus <- map["Response Status"]
        responseType <- map["Response Type"]
        responseDate <- map["Response Date"]
        responseHeaders <- map["Response Headers"]
        responseBodyString <- map["Response Body"]
        responseBodyLength <- map["ResponseBody Length"]
        
        requestStartTime <- map["Request Start Time"]
        requestCompletedTime <- map["Request End Time"]
        requestDuration <- map["Request Duration"]
        
        initialResponseTime <- map["Response Start Time"]
        serializationCompletedTime <- map["Response End Time"]
        serializationDuration <- map["Response Duration"]
        
        latency <- map["latency"]
        totalDuration <- map["totalDuration"]
    }
    
    func saveResponse(_ response: URLResponse, data: Data? = Data(), timeLine: Timeline = Timeline()) {
        self.noResponse = false
        
        self.responseDate = Date()
        
        self.responseStatus = response.getNFStatus()
        self.responseHeaders = response.getNFHeaders()
        
        let headers = response.getNFHeaders()
        
        if let contentType = headers["Content-Type"] as? String {
            self.responseType = contentType.components(separatedBy: ";")[0]
            self.shortType = getShortTypeFrom(self.responseType!).rawValue as NSString
        }
        
        self.requestStartTime = YYDateFormater.share.absoluteTimeToDateTimeString(timeInterval: timeLine.requestStartTime)
        self.requestCompletedTime = YYDateFormater.share.absoluteTimeToDateTimeString(timeInterval: timeLine.requestCompletedTime)
        self.requestDuration = timeLine.requestDuration
        
        self.initialResponseTime = YYDateFormater.share.absoluteTimeToDateTimeString(timeInterval: timeLine.initialResponseTime)
        self.serializationDuration = timeLine.serializationDuration
        self.serializationCompletedTime = YYDateFormater.share.absoluteTimeToDateTimeString(timeInterval: timeLine.serializationCompletedTime)
        self.latency = timeLine.latency
        self.totalDuration = timeLine.totalDuration
        if let _data = data {
            saveResponseBodyStr(_data)
        }
    }
    
    fileprivate func saveResponseBodyStr(_ data: Data) {
        var bodyString: String?
        if self.shortType as String == HTTPModelShortType.IMAGE.rawValue {
            bodyString = data.base64EncodedString(options: .endLineWithLineFeed)
            
        } else {
            if let tempBodyString = String(data: data, encoding: String.Encoding.utf8) {
                bodyString = tempBodyString
            }
        }
        
        if let _bodyString = bodyString{
            self.responseBodyLength = data.count
            self.responseBodyString = _bodyString
        }
    }
}

public class YYNetFoxHTTPRequestModel: Mappable, YYNetFoxHTTPModelProtocol {
    
    var requestURL: String?
    var requestMethod: String?
    var requestCachePolicy: String?
    var requestQuery: String?
    var requestTimeout: String?
    var requestHeaders: [AnyHashable: Any]?
    var requestBodyLength: Int?
    var requestBodyString: String?
    var requestType: String?
    var requestCurl: String?
    
    init() {}
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        
        requestURL <- map["Request URL"]
        requestMethod <- map["Request Method"]
        requestType <- map["Request Type"]
        requestQuery <- map["Request Query"]
        requestTimeout <- map["Request Timeout"]
        requestHeaders <- map["Request Headers"]
        requestBodyString <- map["Request Body"]
        requestBodyLength <- map["RequestBody Length"]
    }
    
    func saveRequest(_ request: URLRequest) {
        self.requestURL = request.getNFURL()
        self.requestMethod = request.getNFMethod()
        self.requestCachePolicy = request.getNFCachePolicy()
        self.requestQuery = request.getNFQuery()
        self.requestTimeout = request.getNFTimeout()
        self.requestHeaders = request.getNFHeaders()
        self.requestType = requestHeaders?["Content-Type"] as! String?
        self.requestCurl = request.getCurl()
        let requestBody: Data = request.getNFBody()
        self.requestBodyString = prettyOutput(requestBody, contentType: requestType)
        self.requestBodyLength = requestBody.count
    }
}

protocol YYNetFoxHTTPModelProtocol {
    func getRequestBodyStr(_ data: Data) -> String?
    func prettyOutput(_ rawData: Data, contentType: String?) -> String
    func prettyPrint(_ rawData: Data, type: HTTPModelShortType) -> String?
    func getShortTypeFrom(_ contentType: String) -> HTTPModelShortType
}

extension YYNetFoxHTTPModelProtocol {
    func getRequestBodyStr(_ data: Data) -> String? {
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func prettyOutput(_ rawData: Data, contentType: String? = nil) -> String {
        if let contentType = contentType {
            let shortType = getShortTypeFrom(contentType)
            if let output = prettyPrint(rawData, type: shortType) {
                return output
            }
        }
        return String(data: rawData, encoding: String.Encoding.utf8) ?? ""
    }
    
    func prettyPrint(_ rawData: Data, type: HTTPModelShortType) -> String?{
        switch type {
        case .JSON:
            do {
                let rawJsonData = try JSONSerialization.jsonObject(with: rawData, options: [])
                let prettyPrintedString = try JSONSerialization.data(withJSONObject: rawJsonData, options: [.prettyPrinted])
                return String(data: prettyPrintedString, encoding: String.Encoding.utf8)
            } catch {
                return nil
            }
            
        default:
            return nil
        }
    }
    
    func getShortTypeFrom(_ contentType: String) -> HTTPModelShortType {
        if NSPredicate(format: "SELF MATCHES %@",
                       "^application/(vnd\\.(.*)\\+)?json$").evaluate(with: contentType) {
            return .JSON
        }
        
        if (contentType == "application/xml") || (contentType == "text/xml")  {
            return .XML
        }
        
        if contentType == "text/html" {
            return .HTML
        }
        
        if contentType.hasPrefix("image/") {
            return .IMAGE
        }
        
        return .OTHER
    }
}

public class YYNetFoxHTTPModel: Mappable {
    
    var requestModel:  YYNetFoxHTTPRequestModel?
    var responseModel: YYNetFoxHTTPResponseModel?
    
    init() {}
    public required init?(map: Map) {}
    
    public func mapping(map: Map) {
        requestModel <- map["Request Info"]
        responseModel <- map["Response Info"]
    }
}
