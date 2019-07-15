//
//  YYAuthenticationChallengeSender.swift
//  YouYou
//
//  Created by pyyx on 2018/12/4.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation

class YYAuthenticationChallengeSender: NSObject, URLAuthenticationChallengeSender{
    typealias YYAuthenticationChallengeHandler = (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    
    fileprivate var handler: YYAuthenticationChallengeHandler
    
    init(handler: @escaping YYAuthenticationChallengeHandler) {
        self.handler = handler
        super.init()
    }
    
    public func use(_ credential: URLCredential, for challenge: URLAuthenticationChallenge) {
        handler(URLSession.AuthChallengeDisposition.useCredential, credential)
    }
    
    public func continueWithoutCredential(for challenge: URLAuthenticationChallenge) {
        handler(URLSession.AuthChallengeDisposition.useCredential, nil)
    }
    
    public func cancel(_ challenge: URLAuthenticationChallenge) {
        handler(URLSession.AuthChallengeDisposition.cancelAuthenticationChallenge, nil)
    }
    
    public func performDefaultHandling(for challenge: URLAuthenticationChallenge) {
        handler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
    }
    
    public func rejectProtectionSpaceAndContinue(with challenge: URLAuthenticationChallenge) {
        handler(URLSession.AuthChallengeDisposition.rejectProtectionSpace, nil)
    }
}
