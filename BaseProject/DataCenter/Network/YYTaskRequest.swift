//
//  YYTaskRequest.swift
//  YouYou
//
//  Created by Jie Yang on 2019/6/20.
//  Copyright © 2019 YueRen. All rights reserved.
//

import Foundation
import Alamofire

protocol YYTaskRequest {
    var request: YYTaskRequest { get }
    func cancel()
}

class YYTaskRequestModel {
    
    ///请求Request类型对象
    private var taskRequest: Request?
    
    init(request: Request) {
        self.taskRequest = request
    }
}

extension YYTaskRequestModel: YYTaskRequest {
    
    var request: YYTaskRequest {
        return self
    }
    
    func cancel() {
        guard let request = self.taskRequest else {
            return
        }
        
        request.cancel()
    }
}
