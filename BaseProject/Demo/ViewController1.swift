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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        button.setTitle("Touch me", for: .normal)
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
        IMDBCenter.default.fetchAllRecnetSession().forEach { (str) in
            print(str)
        }

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
        BPAlertManager.showAlertImage(imageStr: "https://maxst.icons8.com/_nuxt/ouch/img/art-2.0e6fbc3.png", hideCloseBtn: false) { (source) in
            self.view.toast(source.url?.absoluteString ?? "???")
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        BPAlertManager.showAlert(title: "T##String?", description: "T##String", leftBtnName: "T##String", leftBtnClosure: nil, rightBtnName: "T##String", rightBtnClosure: nil)
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
