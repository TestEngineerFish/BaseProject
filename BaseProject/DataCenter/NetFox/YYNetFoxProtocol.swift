//
//  YYNetFoxProtocol.swift
//  YouYou
//
//  Created by pyyx on 2018/12/4.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation

public class YYNetFoxProtocol: URLProtocol {
    
    var connection: NSURLConnection?
    var model: YYNetFoxHTTPModel?
    var session: URLSession?
    
    open override class func canInit(with request: URLRequest) -> Bool {
       
        return canServeRequest(request)
    }
    
    open override class func canInit(with task: URLSessionTask) -> Bool {
        
        guard let request = task.currentRequest else { return false }
        return canServeRequest(request)
    }
    
    fileprivate class func canServeRequest(_ request: URLRequest) -> Bool {
        
        if let url = request.url {
            if !(url.absoluteString.hasPrefix("http")) && !(url.absoluteString.hasPrefix("https")) {
                return false
            }
        }else {
            return false
        }
        
        return true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override func startLoading() {
        
        self.model = YYNetFoxHTTPModel()
        
        var req: NSMutableURLRequest
        req = (YYNetFoxProtocol.canonicalRequest(for: request) as NSURLRequest).mutableCopy() as! NSMutableURLRequest
    
        if session == nil {
            session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        }
        
        session!.dataTask(with: req as URLRequest, completionHandler: {data, response, error in
            
            self.model?.requestModel?.saveRequest(req as URLRequest)
            
            if let error = error, let response = response {
                self.model?.responseModel?.saveResponse(response)
                self.loaded()
                self.client?.urlProtocol(self, didFailWithError: error)
            }
            
            if let data = data {
                self.model?.responseModel?.saveResponse(response!)
                self.loaded()
                self.client!.urlProtocol(self, didLoad: data)
            }
            
            if let client = self.client {
                client.urlProtocolDidFinishLoading(self)
            }
        }).resume()
    }
    
    public override func stopLoading() { }
    
    func loaded(){
        if let _modelJson = self.model?.toJSON() {
            //YYLoggerManager.default.addLoggerDataSource(.network, logText: _modelJson)
        }
    }
}

extension YYNetFoxProtocol: URLSessionDelegate {
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let wrappedChallenge = URLAuthenticationChallenge(authenticationChallenge: challenge, sender: YYAuthenticationChallengeSender(handler: completionHandler))
        client?.urlProtocol(self, didReceive: wrappedChallenge)
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        guard let error = error else { return }
        client?.urlProtocol(self, didFailWithError: error)
    }
}
