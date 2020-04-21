//
//  ViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Lottie
import ZipArchive

class ViewController1: UIViewController {
    
    var showView = UIView()
    let button   = BPBaseButton()
    let text = UITextField()
    var shaperLayer = CAShapeLayer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeUI()
        #if DEVELOPMENT
        print("当前是测试环境")
        #else
        print("当前是正式环境")
        #endif
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
        let vc = BPBaseWebViewController()
        self.navigationController?.present(vc, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.report()
//        let vc = ViewController2()
//        let nvc = UINavigationController(rootViewController: vc)
//        self.navigationController?.present(nvc, animated: true, completion: nil)
//        return
        var count: UInt32 = 0
        if let methodList = class_copyMethodList(BPBaseWebViewController.classForCoder(), &count) {
            for i in 0..<Int(count) {
                let method = methodList[i]
                let sel = method_getName(method)
                let methodStr = String(_sel: sel)
                print(methodStr)
            }
        }
    }


    func report() {
        let fileLogger = DDFileLogger()
        let ziper      = ZipArchive()

        let logPathArray     = fileLogger.logFileManager.sortedLogFileNames
        let logDirectoryPath = fileLogger.logFileManager.logsDirectory
        let logZipPath       = logDirectoryPath + "/feadbackLog.zip"

        if ziper.createZipFile2(logZipPath) {
            logPathArray.forEach { (path) in
                ziper.addFile(toZip: logDirectoryPath + "/" + path, newname: path)
            }
        }
        print(logDirectoryPath)
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
