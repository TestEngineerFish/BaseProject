//
//  BPNetworkService.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import CocoaLumberjack

struct BPNetworkService {
    private let MAX_CONCURRENT_OPERATION_COUNT: Int = 3
    private let request_time_out: TimeInterval = 60

    private var defaultConfiguration: URLSessionConfiguration {
        let _configuration = URLSessionConfiguration.default
        _configuration.timeoutIntervalForRequest = request_time_out
        //_configuration.protocolClasses = [YYNetFoxProtocol.self]
        return _configuration
    }

    public static let `default` = BPNetworkService()
    private init() {
        let sessionManager:SessionManager = Alamofire.SessionManager.init(configuration: self.defaultConfiguration)
        sessionManager.session.delegateQueue.maxConcurrentOperationCount = MAX_CONCURRENT_OPERATION_COUNT
    }

    /**
     *  普通HTTP Request, 支持GET、POST方式
     */
    /// - parameter type: 只是定义泛型对象类型,没有其他作用
    @discardableResult
    public func httpRequestTask <T> (_ type: T.Type, request: YYBaseRequest, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> BPTaskRequest? where T: BPBaseResopnse {
        switch request.method {
        case .post:
            var _request = URLRequest(url: request.url)
            _request.httpMethod = request.method.rawValue
            _request.allHTTPHeaderFields = request.handleHeader(parameters: requestParametersReduceValueNil(request.parameters))

            do {
                if let _parameters = requestParametersReduceValueNil(request.parameters) {
                    try _request.httpBody = JSONSerialization.data(withJSONObject: _parameters, options: [])
                }
                return self.httpPostRequest(type, request: _request, success: { (response, httpStatusCode) in
                    self.handleStatusCodeLogicResponseObject(response, statusCode: httpStatusCode, request: request, success: success, fail: fail)
                }, fail: { (error) in
                    fail?(error as NSError)
                })
            }catch let parseError {
                fail?(parseError as NSError)
                return nil
            }
        case .get:
            return self.httpGetRequest(type, request: request, header: request.handleHeader(parameters: requestParametersReduceValueNil(request.parameters)), success: { (response, httpStatusCode) in
                self.handleStatusCodeLogicResponseObject(response, statusCode: httpStatusCode, request: request, success: success, fail: fail)
            }, fail: { (error) in
                fail?(error as NSError)
            })
        default:
            return nil
        }
    }

    public func httpDownloadRequestTask <T> (_ type: T.Type, request: YYBaseRequest, localSavePath: String, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: BPBaseResopnse {

        //        let requestParameters = self.requestParametersReduceValueNil(request.parameters)
        //
        //        Alamofire.download(request.url, method: HTTPMethod(rawValue: request.method.rawValue) ?? .get, parameters: requestParameters, headers: request.handleHeader(parameters: requestParameters, headers: request.header)) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
        //            let path = YYFileManager.share.createPath(documentPath: localSavePath)
        //            return (URL(fileURLWithPath: path), [.removePreviousFile, .createIntermediateDirectories])
        //            }.downloadProgress { (progress) in
        //                DispatchQueue.main.async {
        //                    DDLogInfo("progress.completedUnitCount is \(progress.completedUnitCount)")
        //                }
        //            }.response { (defaultDownloadResponse) in
        //
        //        }
    }

    /**
     *  文件内容上传 Request
     */
    public func httpUploadRequestTask <T> (_ type: T.Type, request: YYBaseRequest, mimeType: String = "image/jpeg", fileName: String = "photo", success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: BPBaseResopnse {

        var requestHeader = request.header
        requestHeader["Content-Type"] = "multipart/form-data"

        let requestParameters = self.requestParametersReduceValueNil(request.parameters)
        guard var parameters = requestParameters else { return }

        if parameters.keys.contains("cover") {
            parameters.removeValue(forKey: "cover")
        }
        if parameters.keys.contains("file_info") {
            parameters.removeValue(forKey: "file_info")
        }

        //MARK: 上传
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var fileData: Any?
            var name: String = ""
            if parameters.keys.contains("file") {
                fileData = parameters["file"]
                name = "file"
            }else if parameters.keys.contains("cover") {
                fileData = parameters["cover"]
                name = "cover"
            } else if parameters.keys.contains("file_info") {
                fileData = parameters["file_info"]
                name = "file_info"
            }

            if let _fileData = fileData, _fileData is String {
                multipartFormData.append(URL(fileURLWithPath:(_fileData as! String)), withName: name, fileName: fileName, mimeType: mimeType)
            }else if let _fileData = fileData, fileData is Data {
                multipartFormData.append(_fileData as! Data, withName: name, fileName: fileName, mimeType: mimeType)
            }
            parameters.removeValue(forKey: name)

            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
            }
        }, usingThreshold: UInt64.init(), to: request.url, method: HTTPMethod(rawValue: request.method.rawValue) ?? .post , headers: request.handleHeader(parameters: requestParameters, headers: requestHeader)) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response: DataResponse <T>) in
                    switch response.result {
                    case .success(let x):
                        self.handleStatusCodeLogicResponseObject(x, statusCode: (response.response?.statusCode) ?? 0, request: request, success: success, fail: fail)
                    case .failure(let error):
                        fail?(error as NSError)
                    }
                })
            case .failure(let error):
                fail?(error as NSError)
            }
        }
    }

    @discardableResult
    private func httpPostRequest <T> (_ type: T.Type, request: URLRequest, success:@escaping (_ response: T, _ httpStatusCode: Int) -> Void?, fail: @escaping (_ error: NSError) -> Void?) -> BPTaskRequest where T: BPBaseResopnse {

        let request = Alamofire.request(request).responseObject { (response: DataResponse<T>) in
            self.saveSessID(response: response.response)
            switch response.result {
            case .success(var x):
                x.response = response.response
                x.request = response.request
                success(x, (response.response?.statusCode) ?? 0)
            case .failure(let error):
                fail(error as NSError)
            }
        }

        let taskRequest: BPTaskRequest = BPTaskRequestModel(request: request)
        return taskRequest
    }

    @discardableResult
    private func httpGetRequest <T>(_ type: T.Type, request: YYBaseRequest, header:[String:String], success:@escaping (_ response: T, _ httpStatusCode: Int) -> Void, fail: @escaping (_ error: NSError) -> Void?) -> BPTaskRequest where T: BPBaseResopnse {
        let encoding: ParameterEncoding = (.get == request.method ? URLEncoding.default : JSONEncoding.default)
        let request = Alamofire.request(request.url, method: HTTPMethod(rawValue: request.method.rawValue) ?? .get, parameters: requestParametersReduceValueNil(request.parameters), encoding: encoding, headers: header).responseObject { (response: DataResponse <T>) in

            self.saveSessID(response: response.response)
            switch response.result {
            case .success(var x):
                x.response = response.response
                x.request = response.request
                success(x, (response.response?.statusCode) ?? 0)
            case .failure(let error):
                fail(error as NSError)
            }
        }

        let taskRequest: BPTaskRequest = BPTaskRequestModel(request: request)
        return taskRequest
    }

    /**
     *  请求状态码逻辑处理
     */
    private func handleStatusCodeLogicResponseObject <T> (_ response: T, statusCode: Int, request: YYBaseRequest, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: BPBaseResopnse {
        let baseResponse = response as BPBaseResopnse
        let responseStatusCode : Int = baseResponse.statusCode

        if responseStatusCode == 0 {
            success?(response)
        } else {
            if responseStatusCode == 10106 {
                // 当登录状态失效时，通知上层
                let loginExpired = Notification.Name(BPNotificationName.kLoginStatusExpired)
                NotificationCenter.default.post(name: loginExpired, object: nil)
            } else if responseStatusCode == 10109 {
                //用户账号已封禁
                let accountBlocked = Notification.Name(BPNotificationName.kUserAccountHasBeenBlocked)
                NotificationCenter.default.post(name: accountBlocked, object: baseResponse.statusMessage)
            } else if responseStatusCode == 10107 {
                //用户资料信息审核不通过
                let infoBlocked = Notification.Name(BPNotificationName.kUserInfoHasBeenBlocked)
                NotificationCenter.default.post(name: infoBlocked, object: nil)
            } else if responseStatusCode == 10105 {
                //用户头像信息审核不通过
                let avatarBlocked = Notification.Name(BPNotificationName.kUserAvatarInfoHasBeenBlocked)
                NotificationCenter.default.post(name: avatarBlocked, object: nil)
            } else if responseStatusCode == 10108 {
                //用户昵称信息审核不通过
                let nicknameBlocked = Notification.Name(BPNotificationName.kUserNicknameInfoHasBeenBlocked)
                NotificationCenter.default.post(name: nicknameBlocked, object: nil)
            }

            if let errorMsg = baseResponse.statusMessage {
                fail?(NSError(domain: "com.youyou.httpError", code: responseStatusCode, userInfo: [NSLocalizedDescriptionKey : errorMsg]))
            }
        }
    }

    /// 保存 Session ID
    private func saveSessID(response: HTTPURLResponse?) {
        if let sessID = response?.allHeaderFields["YY-SESSID"] {
            UserDefaults.standard.archive(object: sessID, forkey: "YY-SESSID")
        }
    }

    /// 确保参数key对应的Value不为空
    private func requestParametersReduceValueNil(_ requestionParameters: [String : Any?]?) -> [String : Any]? {
        guard let parameters = requestionParameters else {
            return nil
        }
        let _parameters = parameters.reduce([String : Any]()) { (dict, e) in
            guard let value = e.1 else { return dict }
            var dict = dict
            dict[e.0] = value
            return dict
        }
        return _parameters
    }
}
