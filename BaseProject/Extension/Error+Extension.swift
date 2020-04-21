//
//  Error+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/17.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

extension NSError {

    /**
     * 错误内容
     */
    var message: String {
        if let msg = self.userInfo[NSLocalizedDescriptionKey] as? String {
            
            return msg
        }
        return self.domain
    }
}
