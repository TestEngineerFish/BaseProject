//
//  ViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Lottie

class ViewController: UIViewController {

    var showView = UIView()
    let button   = BPBaseButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        button.setTitle("Touch me", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.green1), for: .normal)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(showToast), for: .touchUpInside)
        button.addTarget(self, action: #selector(hideToast), for: .touchUpOutside)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
    }

    @objc func hideToast() {
        self.view.hideTopLoading()
    }
    
    @objc func showToast() {

//        BPAlertManager.showAlertImage(imageStr: "https://maxst.icons8.com/_nuxt/ouch/img/art-2.0e6fbc3.png", hideCloseBtn: false) { (source) in
//            self.view.toast(source.url?.absoluteString ?? "???")
//        }
        self.view.showTopLoading(with: 100)
//        let vc = BPBaseTableViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
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

class BClass: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.orange
        self.view.addObserver(self, forKeyPath: "frame", options: [], context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let offsetPoint = self.view.convert(self.view.origin, from: kWindow)
        print("Current offsetPoint: \(offsetPoint)")
    }
}

class BPCustomNavigationController: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.addObserver(self.view, forKeyPath: "subviews", options: [], context: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let offsetPoint = self.view.convert(self.view.origin, from: kWindow)
        print("Current offsetPoint: \(offsetPoint)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        return super.popViewController(animated: animated)
    }

}

