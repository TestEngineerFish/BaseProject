//
//  ViewController3.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController3: BPViewController, BPSocketProtocol {

    var socketManager: BPSocketManager?

    var serverHostTextField = UITextField()
    var serverPortTextField = UITextField()
    var sendTextField       = UITextField()
    var serverLabel         = UILabel()
    var statusButton        = BPBaseButton()
    var sendButton          = BPBaseButton()
    var infoShowLabel       = UILabel()
    var infoTextView        = UITextView()
    var clearButton         = BPBaseButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        makeUI()
        makeData()
        print(0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(1)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print(2)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(3)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(4)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(5)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(6)
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

    func makeUI() {
        view.addSubview(serverHostTextField)
        view.addSubview(serverLabel)
        view.addSubview(serverPortTextField)
        view.addSubview(statusButton)
        view.addSubview(sendTextField)
        view.addSubview(sendButton)
        view.addSubview(infoShowLabel)
        view.addSubview(infoTextView)
        view.addSubview(clearButton)

        serverHostTextField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-100)
            make.top.equalToSuperview().offset(150)
            make.size.equalTo(CGSize(width: 150, height: 50))
        }
        serverLabel.snp.makeConstraints { (make) in
            make.left.equalTo(serverHostTextField.snp.right)
            make.top.equalTo(serverHostTextField.snp.top)
            make.size.equalTo(CGSize(width: 20, height: 50))
        }
        serverPortTextField.snp.makeConstraints { (make) in
            make.left.equalTo(serverLabel.snp.right)
            make.top.equalTo(serverHostTextField.snp.top)
            make.size.equalTo(CGSize(width: 70, height: 50))
        }
        statusButton.snp.makeConstraints { (make) in
            make.left.equalTo(serverPortTextField.snp.right).offset(20)
            make.top.equalTo(serverHostTextField)
            make.size.equalTo(CGSize(width: 80, height: 50))
        }
        sendTextField.snp.makeConstraints { (make) in
            make.left.equalTo(serverHostTextField)
            make.top.equalTo(serverHostTextField.snp.bottom).offset(20)
            make.right.equalTo(serverPortTextField)
            make.height.equalTo(50)
        }
        sendButton.snp.makeConstraints { (make) in
            make.left.equalTo(statusButton)
            make.centerY.equalTo(sendTextField)
            make.size.equalTo(statusButton)
        }
        infoShowLabel.snp.makeConstraints { (make) in
            make.left.equalTo(serverHostTextField)
            make.top.equalTo(sendTextField.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        infoTextView.snp.makeConstraints { (make) in
            make.left.equalTo(serverHostTextField)
            make.top.equalTo(infoShowLabel.snp.bottom).offset(10)
            make.right.equalTo(sendButton)
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
        }
        clearButton.snp.makeConstraints { (make) in
            make.right.equalTo(sendButton)
            make.top.height.equalTo(infoShowLabel)
            make.width.equalTo(80)
        }

        serverHostTextField.borderStyle     = .roundedRect
        serverPortTextField.borderStyle     = .roundedRect
        sendTextField.borderStyle           = .roundedRect
        serverHostTextField.keyboardType    = .numbersAndPunctuation
        serverPortTextField.keyboardType    = .numberPad
        serverLabel.textAlignment           = .center
        infoTextView.isEditable             = false
        serverHostTextField.backgroundColor = UIColor.gray1.withAlphaComponent(0.15)
        serverPortTextField.backgroundColor = UIColor.gray1.withAlphaComponent(0.15)
        sendTextField.backgroundColor       = UIColor.gray1.withAlphaComponent(0.15)
        infoTextView.backgroundColor        = UIColor.gray1.withAlphaComponent(0.15)
        serverHostTextField.textColor       = UIColor.black1
        serverPortTextField.textColor       = UIColor.black1
        sendTextField.textColor             = UIColor.black1
        infoTextView.textColor              = UIColor.black1
        serverLabel.textColor               = UIColor.black1
        infoShowLabel.textColor             = UIColor.black1
        clearButton.backgroundColor         = UIColor.clear
        clearButton.contentHorizontalAlignment = .right
    }

    func makeData() {
        serverHostTextField.text = "127.0.0.1"
        serverLabel.text         = ":"
        serverPortTextField.text = "8080"
        sendTextField.text       = "客户端发送的消息"
        infoShowLabel.text       = "以下显示日志内容"
        infoTextView.text        = ""
        statusButton.setTitle("⚽️启动", for: .normal)
        statusButton.setTitle("🥅停止", for: .selected)
        sendButton.setTitle("🚀发送", for: .normal)
        clearButton.setTitle("⚠️Clear", for: .normal)
        clearButton.setTitleColor(UIColor.gray, for: .normal)

        statusButton.addTarget(self, action: #selector(startConnection(_:)), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearInfoLog(_:)), for: .touchUpInside)
    }

    // TODO: Event
    @objc func startConnection(_ button: UIButton) {
        if button.isSelected {
            socketManager?.disconnect()
        } else {
            let host = self.serverHostTextField.text.isNilOrEmpty ? "" : self.serverHostTextField.text!
            let port = UInt16(self.serverPortTextField.text.isNilOrEmpty ? "" : self.serverPortTextField.text!) ?? 0
            socketManager = BPSocketManager()
            socketManager?.delegate = self
            socketManager?.connection(toHost: host, onPort: port)
        }
        button.isSelected = !button.isSelected
    }

    @objc func sendMessage(_ button: UIButton) {
        guard let message = self.sendTextField.text, message.isNotEmpty else {
            self.updateEvent("发送的数据不应为nil", level: .WARN)
            return
        }
        let data = message.data(using: .utf8)
        socketManager?.sendData(data)
    }

    @objc func clearInfoLog(_ button: UIButton) {
        self.infoTextView.text = ""
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
    }

    // TODO: BPSocketProtocol
    func updateEvent(_ log: String, level: LogLevel) {
        let value = String(format: "\n%@", log)
        let color = level.getColor()
        let attriMutStr = NSMutableAttributedString(attributedString: self.infoTextView.attributedText)
        attriMutStr.append(NSAttributedString(string: value))
        attriMutStr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(attriMutStr.length - value.count, value.count))
        self.infoTextView.attributedText = attriMutStr
        self.infoTextView.scrollRectToVisible(CGRect(x: 0, y: self.infoTextView.bounds.height, width: self.infoTextView.width, height: self.infoTextView.height), animated: true)
    }

    func disconnectClientSocket() {
        self.statusButton.isSelected = true
        self.startConnection(self.statusButton)
    }

    func disconnectServerSocket() {
        self.updateEvent("服务端已断开连接",level: .INFO)
    }

}
