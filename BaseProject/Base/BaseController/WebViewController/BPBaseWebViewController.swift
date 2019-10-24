//
//  BPBaseWebViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/17.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import WebKit

class BPBaseWebViewController: UIViewController {
    
    /// 定义注册函数的实现类
    static var implClass: AnyClass?
    
    let keyPath         = "title"
    let jsToOcNoPrams   = "jsToOcNoPrams"
    let jsToOcWithPrams = "jsToOcWithPrams:"
    
    let configuration = WKWebViewConfiguration()
    
    /// 需要注册的函数
    var funciontList: [String] = {
        var list = [String]()
        guard let implClass = BPBaseWebViewController.implClass else { return list }
        
        var count: UInt32 = 0
        if let methodList = class_copyMethodList(implClass, &count) {
            for i in 0..<Int(count) {
                let method = methodList[i]
                let sel = method_getName(method)
                let methodStr = String(_sel: sel)
                print(methodStr)
            }
        }
        return list
    }()
    var jsScriptList = [String]()
    
    lazy var webView: WKWebView = {
        self.setConfiguration()
        let _webView = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), configuration: configuration)
        _webView.uiDelegate = self
        _webView.navigationDelegate = self
        // 允许左滑返回上一级
        _webView.allowsBackForwardNavigationGestures = true
        let path = Bundle.main.path(forResource: "JStoOC.html", ofType: nil) ?? ""
        let pathStr = try? String(contentsOfFile: path, encoding: .utf8)
        _webView.loadHTMLString(pathStr ?? "", baseURL: URL(fileURLWithPath: Bundle.main.bundlePath))
        return _webView
    }()
    var progressView: UIProgressView?
    
    private func setConfiguration() {
        // 视频播放是否允许调用本地播放器
        configuration.allowsInlineMediaPlayback = true
        // 设置哪些设备(音频或视频)需要用户主动播放,不自动播放
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        // 是否允许画中画(缩放视频在浏览器内,不影响其他操作)效果,特定设备有效
        configuration.allowsPictureInPictureMediaPlayback = true
        // 设置请求时的User—Agent信息中的应用名称, iOS9之后又用
        configuration.applicationNameForUserAgent = "User_agent name"
        // ---- 设置偏好设置 ----
        let preferences = WKPreferences()
        // 设置最小字体,优先JS的控制,可关闭javaScriptEnabled.来测试
        preferences.minimumFontSize = 0
        // 是否支持javaScriptEnable
        preferences.javaScriptEnabled = true
        // 是否可以不经过用户同意,直接由JS控制打开窗口
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        
        // ---- 自定义处理JS消息对象 ----
        let weakScriptMessageDelegate = WeakWkScriptMessageHeaderDelegate(self)
        
        // 这个类主要负责与JS交互管理
        let userContentController =  WKUserContentController()
        for name in funciontList {
            // 向JS注册函数,使用自定义的WKScriptMessageHeader对象来处理
            userContentController.add(weakScriptMessageDelegate, name: name)
        }
        configuration.userContentController = userContentController
        
        // 注入JS内容,注入到JS文件末尾
        for script in jsScriptList {
            let userScript = WKUserScript(source: script, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            userContentController.addUserScript(userScript)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeUI()
        self.makeNotification()
    }
    
    private func makeUI() {
//        self.customNavigationItems()
        self.view.addSubview(webView)
//        self.view.addSubview(progressView)
    }
    
    private func makeNotification() {
        webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
    }
    
    /// 自定义导航栏左右Item上的按钮
    private func customNavigationItems() {
        let backBtn = UIButton(type: .custom)
        backBtn.setTitle("back", for: .normal)
        backBtn.setTitleColor(UIColor.black1, for: .normal)
        backBtn.addTarget(self, action: #selector(goBackAction(_:)), for: .touchUpInside)
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: kNavHeight)
        let backBtnItem = UIBarButtonItem(customView: backBtn)
        let js2OC  = UIBarButtonItem(title: "js2OC", style: .done, target: self, action: #selector(jsToOCAction))
        self.navigationItem.leftBarButtonItems = [backBtnItem, js2OC]
        
        let refreshBtn = UIButton(type: .custom)
        refreshBtn.setTitle("刷新", for: .normal)
        refreshBtn.setTitleColor(UIColor.black1, for: .normal)
        refreshBtn.frame = CGRect(x: 0, y: 0, width: 30, height: kNavHeight)
        refreshBtn.addTarget(self, action: #selector(refreshAction(_:)), for: .touchUpInside)
        let refreshBtnItem = UIBarButtonItem(customView: refreshBtn)
        let oc2JS = UIBarButtonItem(title: "oc2JS", style: .done, target: self, action: #selector(ocToJSAction))
        self.navigationItem.rightBarButtonItems = [refreshBtnItem, oc2JS]
    }
    
    @objc private func goBackAction(_ btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func jsToOCAction() {
        
    }
    
    @objc private func refreshAction(_ btn: UIButton) {
        
    }
    
    @objc private func ocToJSAction() {
        
    }
    
    ///  移除注册的函数
    deinit {
        for name in funciontList {
            webView.configuration.userContentController.removeScriptMessageHandler(forName: name)
        }
        webView.removeObserver(self, forKeyPath: keyPath)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == self.keyPath {
            guard let objc = object as? WKWebView, objc == self.webView else {
                return
            }
            self.navigationController?.title = webView.title
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    
}
// 接收WebView传递来的信息
extension BPBaseWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let funcName = message.name
        let parameters = message.body
        if funcName == jsToOcNoPrams {
            BPAlertManager.showAlertOntBtn(title: "JS调用了没有参数函数", description: "函数名:" + funcName, buttonName: "知道了", closure: nil)
        } else if funcName == jsToOcWithPrams {
            BPAlertManager.showAlertOntBtn(title: "JS调用了有参数函数", description: "函数名:" + funcName + "参数是 : \(parameters)", buttonName: "知道了", closure: nil)
        }
    }
}

// 将web常见视图,转换成原生试视图展示
extension BPBaseWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        BPAlertManager.showAlertOntBtn(title: "捕获到JS的弹框", description: message, buttonName: "知道了", closure: completionHandler)
    }
    
}

// 在处理web请求的时候,可拦截进行自定义处理
extension BPBaseWebViewController: WKNavigationDelegate {
    
}

/// 用来处理WKScriptMessageHandler不释放的问题
class WeakWkScriptMessageHeaderDelegate: NSObject,WKScriptMessageHandler {
    
    weak var scriptDelegate: WKScriptMessageHandler?
    
    init(_ delegate: WKScriptMessageHandler) {
        super.init()
        self.scriptDelegate = delegate
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        scriptDelegate?.userContentController(userContentController, didReceive: message)
    }
}
