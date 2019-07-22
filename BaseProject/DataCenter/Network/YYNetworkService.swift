//
//  YYNetworkService.swift
//  YouYou
//
//  Created by pyyx on 2018/10/23.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import CocoaLumberjack

struct YYNetworkService {
    private let MAX_CONCURRENT_OPERATION_COUNT: Int = 3
    private let request_time_out: TimeInterval = 60
    
    private var model: YYNetFoxHTTPModel?
    
    private var defaultConfiguration: URLSessionConfiguration {
        let _configuration = URLSessionConfiguration.default
        _configuration.timeoutIntervalForRequest = request_time_out
        //_configuration.protocolClasses = [YYNetFoxProtocol.self]
        return _configuration
    }
    
    public static let `default` = YYNetworkService()
    private init() {
        let sessionManager:SessionManager = Alamofire.SessionManager.init(configuration: self.defaultConfiguration)
        sessionManager.session.delegateQueue.maxConcurrentOperationCount = MAX_CONCURRENT_OPERATION_COUNT
    }
    
    /**
     *  普通HTTP Request, 支持GET、POST方式
     */
    @discardableResult
    public func httpRequestTask <T> (_ type: T.Type, request: YYBaseRequest, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> YYTaskRequest? where T: YYBaseResopnse {
        
        if let postJSON = request.postJson {
            var _request = URLRequest(url: request.url)
            _request.httpMethod = request.method.rawValue
            _request.allHTTPHeaderFields = request.handleHeader(parameters: requestParametersReduceValueNil(request.parameters))
            
            do {
                if let _postJSON = requestParametersReduceValueNil(postJSON as? [AnyHashable : Any]) {
                    try _request.httpBody = JSONSerialization.data(withJSONObject: _postJSON, options: [])
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
        } else {
            return self.httpRequest(type, request: request, header: request.handleHeader(parameters: requestParametersReduceValueNil(request.parameters)), success: { (response, httpStatusCode) in
                self.handleStatusCodeLogicResponseObject(response, statusCode: httpStatusCode, request: request, success: success, fail: fail)
            }, fail: { (error) in
                fail?(error as NSError)
            })
        }
    }
    
    public func httpDownloadRequestTask <T> (_ type: T.Type, request: YYBaseRequest, localSavePath: String, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: YYBaseResopnse {
        
        guard let postJSON = request.postJson as? [AnyHashable : Any] else { return }
        
        let requestPostJson = (postJSON as? [String : Any?])?.reduce([String : Any]()) { (dict, e) in
            guard let value = e.1 else { return dict }
            var dict = dict
            dict[e.0] = value
            return dict
            }
        guard let _requestPostJson: [String:Any] = requestPostJson else {return}
        
        Alamofire.download(request.url, method: HTTPMethod(rawValue: request.method.rawValue) ?? .get, parameters: _requestPostJson, headers: request.handleHeader(parameters: _requestPostJson, headers: request.header)) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
            let path = YYFileManager.share.createPath(documentPath: localSavePath)
            return (URL(fileURLWithPath: path), [.removePreviousFile, .createIntermediateDirectories])
            }.downloadProgress { (progress) in
                DispatchQueue.main.async {
                    DDLogInfo("progress.completedUnitCount is \(progress.completedUnitCount)")
                }
            }.response { (defaultDownloadResponse) in
                
        }
    }
    
    /**
     *  文件内容上传 Request
     */
    public func httpUploadRequestTask <T> (_ type: T.Type, request: YYBaseRequest, mimeType: String = "image/jpeg", fileName: String = "photo", success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: YYBaseResopnse {
        
        var requestHeader = request.header
        requestHeader["Content-Type"] = "multipart/form-data"
        guard let postJSON = request.postJson as? [AnyHashable : Any] else {
            return
        }
        
        let requestPostJson = (postJSON as? [String : Any?])?.reduce([String : Any]()) { (dict, e) in
            guard let value = e.1 else { return dict }
            var dict = dict
            dict[e.0] = value
            return dict
            }
        guard var _requestPostJson: [String:Any] = requestPostJson else {return}
        
        if _requestPostJson.keys.contains("cover") {
            _requestPostJson.removeValue(forKey: "cover")
        }
        if _requestPostJson.keys.contains("file_info") {
            _requestPostJson.removeValue(forKey: "file_info")
        }
        
        //MARK: 上传
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            var fileData: Any?
            var name: String = ""
            if _requestPostJson.keys.contains("file") {
                fileData = _requestPostJson["file"]
                name = "file"
            }else if _requestPostJson.keys.contains("cover") {
                fileData = _requestPostJson["cover"]
                name = "cover"
            } else if _requestPostJson.keys.contains("file_info") {
                fileData = _requestPostJson["file_info"]
                name = "file_info"
            }
            
            if let _fileData = fileData, _fileData is String {
                multipartFormData.append(URL(fileURLWithPath:(_fileData as! String)), withName: name, fileName: fileName, mimeType: mimeType)
            }else if let _fileData = fileData, fileData is Data {
                multipartFormData.append(_fileData as! Data, withName: name, fileName: fileName, mimeType: mimeType)
            }
            _requestPostJson.removeValue(forKey: name)
            
            for (key, value) in _requestPostJson {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key )
            }
        }, usingThreshold: UInt64.init(), to: request.url, method: HTTPMethod(rawValue: request.method.rawValue) ?? .post , headers: request.handleHeader(parameters: _requestPostJson, headers: requestHeader)) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseObject(completionHandler: { (response: DataResponse <T>) in
                    var result = self
                    switch response.result {
                    case .success(let x):
                        self.handleStatusCodeLogicResponseObject(x, statusCode: (response.response?.statusCode) ?? 0, request: request, success: success, fail: fail)
                        if (response.response?.statusCode ?? 0) != 0 {
                            result.model = YYNetFoxHTTPModel()
                            let requestModel = YYNetFoxHTTPRequestModel()
                            let responseModel = YYNetFoxHTTPResponseModel()
                            if let _urlRequest = response.request {
                                requestModel.saveRequest(_urlRequest)
                                result.model?.requestModel = requestModel
                            }
                            let resultData: Data? = x.toJSONString()?.data(using: String.Encoding.utf8)
                            if let _urlResponse = response.response {
                                responseModel.saveResponse(_urlResponse, data: resultData, timeLine: response.timeline)
                                result.model?.responseModel = responseModel
                            }
                            result.loaded()
                        }
                    case .failure(let error):
                        result.model = YYNetFoxHTTPModel()
                        let requestModel = YYNetFoxHTTPRequestModel()
                        let responseModel = YYNetFoxHTTPResponseModel()
                        if let _urlRequest = response.request {
                            requestModel.saveRequest(_urlRequest)
                            result.model?.requestModel = requestModel
                        }
                        
                        if let _urlResponse = response.response {
                            responseModel.saveResponse(_urlResponse, timeLine: response.timeline)
                            result.model?.responseModel = responseModel
                        }
                        result.loaded()
                        fail?(error as NSError)
                    }
                })
            case .failure(let error):
                fail?(error as NSError)
            }
        }
    }
    
    @discardableResult
    private func httpPostRequest <T> (_ type: T.Type, request: URLRequest, success:@escaping (_ response: T, _ httpStatusCode: Int) -> Void?, fail: @escaping (_ error: NSError) -> Void?) -> YYTaskRequest where T: YYBaseResopnse {
        
        let request = Alamofire.request(request).responseObject { (response: DataResponse<T>) in
            self.saveSessID(response: response.response)
            var result = self
            switch response.result {
            case .success(var x):
                x.response = response.response
                x.request = response.request
                success(x, (response.response?.statusCode) ?? 0)
                if (response.response?.statusCode ?? 0) != 0 {
                    result.model = YYNetFoxHTTPModel()
                    let requestModel = YYNetFoxHTTPRequestModel()
                    let responseModel = YYNetFoxHTTPResponseModel()
                    if let _urlRequest = response.request {
                        requestModel.saveRequest(_urlRequest)
                        result.model?.requestModel = requestModel
                    }
                    let resultData: Data? = x.toJSONString()?.data(using: String.Encoding.utf8)
                    if let _urlResponse = response.response {
                        responseModel.saveResponse(_urlResponse, data: resultData, timeLine: response.timeline)
                        result.model?.responseModel = responseModel
                    }
                    result.loaded()
                }
            case .failure(let error):
                result.model = YYNetFoxHTTPModel()
                let requestModel = YYNetFoxHTTPRequestModel()
                let responseModel = YYNetFoxHTTPResponseModel()
                if let _urlRequest = response.request {
                    requestModel.saveRequest(_urlRequest)
                    result.model?.requestModel = requestModel
                }
                
                if let _urlResponse = response.response {
                    responseModel.saveResponse(_urlResponse, timeLine: response.timeline)
                    result.model?.responseModel = responseModel
                }
                result.loaded()
                
                fail(error as NSError)
            }
        }
        
        let taskRequest: YYTaskRequest = YYTaskRequestModel(request: request)
        return taskRequest
    }
    
    @discardableResult
    private func httpRequest <T>(_ type: T.Type, request: YYBaseRequest, header:[String:String], success:@escaping (_ response: T, _ httpStatusCode: Int) -> Void, fail: @escaping (_ error: NSError) -> Void?) -> YYTaskRequest where T: YYBaseResopnse {
        let encoding: ParameterEncoding = (.get == request.method ? URLEncoding.default : JSONEncoding.default)
        let request = Alamofire.request(request.url, method: HTTPMethod(rawValue: request.method.rawValue) ?? .get, parameters: requestParametersReduceValueNil(request.parameters), encoding: encoding, headers: header).responseObject { (response: DataResponse <T>) in
            
            self.saveSessID(response: response.response)
            var result = self
            switch response.result {
            case .success(var x):
                x.response = response.response
                x.request = response.request
                success(x, (response.response?.statusCode) ?? 0)
                if (response.response?.statusCode ?? 0) != 0 {
                    result.model = YYNetFoxHTTPModel()
                    let requestModel = YYNetFoxHTTPRequestModel()
                    let responseModel = YYNetFoxHTTPResponseModel()
                    if let _urlRequest = response.request {
                        requestModel.saveRequest(_urlRequest)
                        result.model?.requestModel = requestModel
                    }
                    let resultData: Data? = x.toJSONString()?.data(using: String.Encoding.utf8)
                    if let _urlResponse = response.response {
                        responseModel.saveResponse(_urlResponse, data: resultData, timeLine: response.timeline)
                        result.model?.responseModel = responseModel
                    }
                    result.loaded()
                }
            case .failure(let error):
                result.model = YYNetFoxHTTPModel()
                let requestModel = YYNetFoxHTTPRequestModel()
                let responseModel = YYNetFoxHTTPResponseModel()
                if let _urlRequest = response.request {
                    requestModel.saveRequest(_urlRequest)
                    result.model?.requestModel = requestModel
                }
                
                if let _urlResponse = response.response {
                    responseModel.saveResponse(_urlResponse, timeLine: response.timeline)
                    result.model?.responseModel = responseModel
                }
                result.loaded()
                
                fail(error as NSError)
            }
        }
        
        let taskRequest: YYTaskRequest = YYTaskRequestModel(request: request)
        return taskRequest
    }
    
    /**
     *  请求状态码逻辑处理
     */
    private func handleStatusCodeLogicResponseObject <T> (_ response: T, statusCode: Int, request: YYBaseRequest, success: ((_ response: T) -> Void)?, fail: ((_ responseError: NSError) -> Void)?) -> Void where T: YYBaseResopnse {
        let baseResponse = response as YYBaseResopnse
        let responseStatusCode : Int = baseResponse.statusCode
        
        if responseStatusCode == 0 {
            success?(response)
        } else {
            if responseStatusCode == 10106 {
                // 当登录状态失效时，通知上层
                let loginExpired = Notification.Name(YYNotificationCenter.kLoginStatusExpired)
                NotificationCenter.default.post(name: loginExpired, object: nil)
            } else if responseStatusCode == 10109 {
                //用户账号已封禁
                let accountBlocked = Notification.Name(YYNotificationCenter.kUserAccountHasBeenBlocked)
                NotificationCenter.default.post(name: accountBlocked, object: baseResponse.statusMessage)
            } else if responseStatusCode == 10107 {
                //用户资料信息审核不通过
                let infoBlocked = Notification.Name(YYNotificationCenter.kUserInfoHasBeenBlocked)
                NotificationCenter.default.post(name: infoBlocked, object: nil)
            } else if responseStatusCode == 10105 {
                //用户头像信息审核不通过
                let avatarBlocked = Notification.Name(YYNotificationCenter.kUserAvatarInfoHasBeenBlocked)
                NotificationCenter.default.post(name: avatarBlocked, object: nil)
            } else if responseStatusCode == 10108 {
                //用户昵称信息审核不通过
                let nicknameBlocked = Notification.Name(YYNotificationCenter.kUserNicknameInfoHasBeenBlocked)
                NotificationCenter.default.post(name: nicknameBlocked, object: nil)
            }
            
            if let errorMsg = baseResponse.statusMessage {
                fail?(NSError(domain: "com.youyou.httpError", code: responseStatusCode, userInfo: [NSLocalizedDescriptionKey : errorMsg]))
            }
        }
    }
    
    
    private func loaded(){
        if let _model = self.model {
            let logText = _model.toJSON()
            YYLoggerManager.default.addLoggerDataSource(.network, logText: logText)
        }
    }

    /// 保存 Session ID
    private func saveSessID(response: HTTPURLResponse?) {
        if let sessID = response?.allHeaderFields["YY-SESSID"] {
            UserDefaults.standard.archive(object: sessID, forkey: "YY-SESSID")
        }
    }

    /// 确保参数key对应的Value不为空
    private func requestParametersReduceValueNil(_ requestionParameters: [AnyHashable : Any]?) -> [String : Any]? {
        if let _requestionParameters = requestionParameters {
            let parameters = (_requestionParameters as? [String : Any?])?.reduce([String : Any]()) { (dict, e) in
                guard let value = e.1 else { return dict }
                var dict = dict
                dict[e.0] = value
                return dict
                }
            guard let _parameters: [String:Any] = parameters else {return nil}
            return _parameters
        }
        
        return nil
    }
}
