//
//  YYAlertManger.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

struct YYAlertManager {
    
    static func showTwoVerticalButtonAlertView(title: String = "", description: String, aboveButtonName: String, aboveButtonClosure: @escaping (() -> Void), lowButtonName: String, lowButtonClosure: @escaping (() -> Void)) {
        let alertView = YYTwoVerticalButtonAlertView(title: title, description: description, aboveButtonName: aboveButtonName, aboveButtonClosure: aboveButtonClosure, lowButtonName: lowButtonName, lowButtonClosure: lowButtonClosure)
        
        alertView.showTopWindow()
    }
    
    static func showThreeVerticalButtonAlertView(title: String = "", description: String, fristButtonName: String, fristButtonClosure: @escaping (() -> Void), secondButtonName: String, secondButtonClosure: @escaping (() -> Void), threeButtonName: String, threeButtonClosure: @escaping (() -> Void)) {
        let alertView = YYThreeVerticalButtonAlertView(title: title, description: description, fristButtonName: fristButtonName, fristButtonClosure: fristButtonClosure, secondButtonName: secondButtonName, secondButtonClosure: secondButtonClosure, threeButtonName: threeButtonName, threeButtonClosure: threeButtonClosure)
        
        alertView.showTopWindow()
    }
    
    static func showTwoHorizontalButtonAlertView(title: String = "", description: String, leftButtonName: String, leftButtonClosure: @escaping (() -> Void), rightButtonName: String, rightButtonClosure: @escaping (() -> Void)) {
        let alertView = YYTwoHorizontalButtonAlertView(title: title, description: description, leftButtonName: leftButtonName, leftButtonClosure: leftButtonClosure, rightButtonName: rightButtonName, rightButtonClosure: rightButtonClosure)
        
        alertView.showTopWindow()
    }
    
    static func showOneButtonAlertView(title: String = "", description: String, buttonName: String, buttonClosure: @escaping (() -> Void)) {
        let alertView = YYOneButtonAlertView(title: title, description: description, buttonName: buttonName, buttonClosure: buttonClosure)
        
        alertView.showTopWindow()
    }
    
}
