//
//  YYNetFoxHelper.swift
//  YouYou
//
//  Created by pyyx on 2018/12/4.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation

enum HTTPModelShortType: String {
    case JSON = "JSON"
    case XML = "XML"
    case HTML = "HTML"
    case IMAGE = "Image"
    case OTHER = "Other"
    
    static let allValues = [JSON, XML, HTML, IMAGE, OTHER]
}

extension InputStream {
    func readfully() -> Data {
        var result = Data()
        var buffer = [UInt8](repeating: 0, count: 4096)
        
        open()
        
        var amount = 0
        repeat {
            amount = read(&buffer, maxLength: buffer.count)
            if amount > 0 {
                result.append(buffer, count: amount)
            }
        } while amount > 0
        
        close()
        
        return result
    }
}

extension URLRequest {
    func getNFURL() -> String {
        if (url != nil) {
            return url!.absoluteString;
        } else {
            return "-"
        }
    }
    
    func getNFMethod() -> String {
        if (httpMethod != nil) {
            return httpMethod!
        } else {
            return "-"
        }
    }
    
    func getNFCachePolicy() -> String {
        switch cachePolicy {
        case .useProtocolCachePolicy: return "UseProtocolCachePolicy"
        case .reloadIgnoringLocalCacheData: return "ReloadIgnoringLocalCacheData"
        case .reloadIgnoringLocalAndRemoteCacheData: return "ReloadIgnoringLocalAndRemoteCacheData"
        case .returnCacheDataElseLoad: return "ReturnCacheDataElseLoad"
        case .returnCacheDataDontLoad: return "ReturnCacheDataDontLoad"
        case .reloadRevalidatingCacheData: return "ReloadRevalidatingCacheData"
        }
    }
    
    func getNFTimeout() -> String {
        return String(Double(timeoutInterval))
    }
    
    func getNFHeaders() -> [AnyHashable: Any] {
        if (allHTTPHeaderFields != nil) {
            return allHTTPHeaderFields!
        } else {
            return Dictionary()
        }
    }
    
    func getNFBody() -> Data {
        return self.httpBody ?? Data()
    }
    
    func getNFQuery() -> String {
        return self.url?.query ?? ""
    }
    
    func getCurl() -> String {
        guard let url = url else { return "" }
        let baseCommand = "curl \(url.absoluteString)"
        
        var command = [baseCommand]
        
        if let method = httpMethod {
            command.append("-X \(method)")
        }
        
        for (key, value) in getNFHeaders() {
            command.append("-H \u{22}\(key): \(value)\u{22}")
        }
        
        if let body = String(data: getNFBody(), encoding: .utf8) {
            command.append("-d \u{22}\(body)\u{22}")
        }
        
        return command.joined(separator: " ")
    }
}

extension URLResponse{
    func getNFStatus() -> Int {
        return (self as? HTTPURLResponse)?.statusCode ?? 999
    }
    
    func getNFHeaders() -> [AnyHashable: Any]{
        return (self as? HTTPURLResponse)?.allHeaderFields ?? [:]
    }
}
