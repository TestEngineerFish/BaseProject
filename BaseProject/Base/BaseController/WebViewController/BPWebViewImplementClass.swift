//
//  BPWebViewImplementClass.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/22.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

class BPWebViewImplementClass: NSObject {
    func jsToOcWithPrams(_ parms: [String:Any])  {
        print("jsToOcWithPrams, params : \(parms)")
    }
    
    func jsToOcNoPrams() {
        print("jsToOcNoPrams")
    }
    
    func goBackValue() -> String {
        print("goBackValue")
        return "sam"
    }
    
}
