//
//  ViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Lottie

class ViewController1: UIViewController {
    
    var showView = UIView()
    let button   = BPBaseButton()
    let text = UITextField()
    var shaperLayer = CAShapeLayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeUI()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        self.view.addGestureRecognizer(pan)
    }

    @objc private func pan(_ pan: UIPanGestureRecognizer) {
        let point = pan.location(in: self.view)
        shaperLayer.removeFromSuperlayer()
        let path = UIBezierPath()
        path.move(to: self.view.center)
        path.addLine(to: point)
        shaperLayer.path = path.cgPath
        shaperLayer.lineWidth = 6
        shaperLayer.strokeColor = UIColor.orange1.cgColor
        shaperLayer.fillColor = nil
        self.view.layer.addSublayer(shaperLayer)

    }
    
    private func makeUI() {
        self.view.backgroundColor = UIColor.white
        button.setTitle("right-data", for: .normal)
        let textColor = UIColor.gradientColor(with: CGSize(width: 100, height: 50), colors: [UIColor.white.cgColor, UIColor.black.cgColor], direction: .horizontal)
        button.setTitleColor(textColor, for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.green1), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(showToast), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
//        IMDBCenter.default.fetchAllRecnetSession().forEach { (str) in
//            print(str)
//        }
        
        if #available(iOS 13.0, *) {
            self.overrideUserInterfaceStyle = .dark
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func hideToast() {
        self.view.hideTopLoading()
    }
    
    @objc func showToast() {
        
        let vc = BPBaseWebViewController(BPWebViewImplementClass.classForCoder())
//        self.navigationController?.pushViewController(vc, animated: true)
//        let jsToOcNoPrams   = "jsToOcNoPrams"
//        let jsToOcWithPrams = "jsToOcWithPrams:"

        let jSString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
//        vc.funciontList = [jsToOcNoPrams, jsToOcWithPrams]
        vc.jsScriptList = [jSString]
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        return
        var count: UInt32 = 0
        if let methodList = class_copyMethodList(BPBaseWebViewController.classForCoder(), &count) {
            for i in 0..<Int(count) {
                let method = methodList[i]
//                if let methodUTF8 = method_getTypeEncoding(method) {
//                    let methodStr = String(utf8String: methodUTF8) ?? ""
//                    print(methodStr)
//                }
                let sel = method_getName(method)
                let methodStr = String(_sel: sel)
                print(methodStr)
            }
        }
        
        
//        for method in methodList {
//            print(method)
//        }
        
//        BPAlertManager.showAlertImage(imageStr: "https://maxst.icons8.com/_nuxt/ouch/img/art-2.0e6fbc3.png", hideCloseBtn: false) { (source) in
//            self.view.toast(source.url?.absoluteString ?? "???")
//        }
    }
    
    
    
    // 求介绍 - 问题列表
    func fetchQuestionList(_ completion: @escaping ((_ questionList:YYWantToKnowQuestionListModel?, _ errorMsg: String?) -> Void)){
        let request = YYUsrHomePageDataRequestAPI.fetchWantToKnowQuestionList
        BPNetworkService.default.httpRequestTask(BPStructResponse<YYWantToKnowQuestionListModel>.self, request: request, success: { (response) in
            completion(response.data, nil)
        }) { (error) in
            completion(nil, error.message)
        }
    }
    
    
    
}

extension Array {
    
    subscript(_ index: Int, safe: Bool) -> Element? {
        print("safe")
        return self[index]
    }
    
    func safeObject(_ index: Int) -> Element? {
        if index > self.count {
            return nil
        }
        return self.safeObject(index)
    }
}
