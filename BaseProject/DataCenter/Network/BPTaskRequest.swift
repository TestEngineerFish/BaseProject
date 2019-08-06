//
//  BPTaskRequest.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import Alamofire

protocol BPTaskRequest {
    var request: BPTaskRequest { get }
    func cancel()
}

class BPTaskRequestModel {

    ///请求Request类型对象
    private var taskRequest: Request?

    init(request: Request) {
        self.taskRequest = request
    }
}

extension BPTaskRequestModel: BPTaskRequest {

    var request: BPTaskRequest {
        return self
    }

    func cancel() {
        guard let request = self.taskRequest else {
            return
        }

        request.cancel()
    }
}
