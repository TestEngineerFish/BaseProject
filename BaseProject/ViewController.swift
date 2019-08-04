//
//  ViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var showView = UIView()
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.showView.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 100, height: 100))
        self.showView.center = self.view.center
        self.showView.backgroundColor = UIColor.red
        self.view.addSubview(self.showView)
        self.button.frame = CGRect(origin: CGPoint(x: self.view.centerX, y: self.view.height - 100), size: CGSize(width: 50, height: 30))
        self.button.backgroundColor = UIColor.blue
        self.button.setTitle("RESET", for: .normal)
        self.button.setTitleColor(UIColor.white, for: .normal)
        self.button.addTarget(self, action: #selector(reset), for: .touchUpInside)
        self.view.addSubview(button)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.button.frame = CGRect(x: 199, y: 199, width: 199, height: 199)
        kWindow.addSubview(self.button)
    }
    
    @objc func reset() {
        UIView.cleanTopWindow(anyClass: UIButton.self)
//        UIView.animate(withDuration: 0.5) {
//            self.showView.transform = CGAffineTransform.identity
//        }
    }
    

    // 求介绍 - 问题列表
    func fetchQuestionList(_ completion: @escaping ((_ questionList:YYWantToKnowQuestionListModel?, _ errorMsg: String?) -> Void)){
        let request = YYUsrHomePageDataRequestAPI.fetchWantToKnowQuestionList
        YYNetworkService.default.httpRequestTask(YYStructResponse<YYWantToKnowQuestionListModel>.self, request: request, success: { (response) in
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

class Nav: UINavigationController {

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

