//
//  YYNetworkError.swift
//  YouYou
//
//  Created by pyyx on 2018/11/10.
//  Copyright © 2018 YueRen. All rights reserved.
//

import Foundation
import ObjectMapper

//
//enum YYErrorCode {
//    case 
//}



class YYNetworkError: NSObject {
    
    var code: Int?
    var message: String?
    var warning: String?
    
    init(codeDesc: Int, messageDesc: String?, warningDesc: String?) {
        code = codeDesc
        message = messageDesc
        warning = warningDesc
    }
}

