//
//  BPWebSocketServer.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPWebSocketServer: BPViewController, BPSocketProtocol {

    var socketManager: BPServerSocketManager?
    var serverPortLabel     = UILabel()
    var serverLabel         = UILabel()
    var serverPortTextField = UITextField()
    var sendTextField       = UITextField()
    var statusButton        = BPButton()
    var sendButton          = BPButton()
    var infoShowLabel       = UILabel()
    var infoTextView        = UITextView()
    var clearButton         = BPButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.isHidden = true
        self.view.backgroundColor = UIColor.white
        makeUI()
        makeData()
    }

    func makeUI() {
        view.addSubview(serverPortLabel)
        view.addSubview(serverLabel)
        view.addSubview(serverPortTextField)
        view.addSubview(statusButton)
        view.addSubview(sendTextField)
        view.addSubview(sendButton)
        view.addSubview(infoShowLabel)
        view.addSubview(infoTextView)
        view.addSubview(clearButton)

        serverPortLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview().offset(-100)
            make.top.equalToSuperview().offset(150)
            make.size.equalTo(CGSize(width: 150, height: 50))
        }
        serverLabel.snp.makeConstraints { (make) in
            make.left.equalTo(serverPortLabel.snp.right)
            make.top.equalTo(serverPortLabel.snp.top)
            make.size.equalTo(CGSize(width: 20, height: 50))
        }
        serverPortTextField.snp.makeConstraints { (make) in
            make.left.equalTo(serverLabel.snp.right)
            make.top.equalTo(serverPortLabel.snp.top)
            make.size.equalTo(CGSize(width: 70, height: 50))
        }
        statusButton.snp.makeConstraints { (make) in
            make.left.equalTo(serverPortTextField.snp.right).offset(20)
            make.top.equalTo(serverPortLabel)
            make.size.equalTo(CGSize(width: 80, height: 50))
        }
        sendTextField.snp.makeConstraints { (make) in
            make.left.equalTo(serverPortLabel)
            make.top.equalTo(serverPortLabel.snp.bottom).offset(20)
            make.right.equalTo(serverPortTextField)
            make.height.equalTo(50)
        }
        sendButton.snp.makeConstraints { (make) in
            make.left.equalTo(statusButton)
            make.centerY.equalTo(sendTextField)
            make.size.equalTo(statusButton)
        }
        infoShowLabel.snp.makeConstraints { (make) in
            make.left.equalTo(serverPortLabel)
            make.top.equalTo(sendTextField.snp.bottom).offset(20)
            make.size.equalTo(CGSize(width: 300, height: 40))
        }
        infoTextView.snp.makeConstraints { (make) in
            make.left.equalTo(serverPortLabel)
            make.top.equalTo(infoShowLabel.snp.bottom).offset(10)
            make.right.equalTo(sendButton)
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
        }
        clearButton.snp.makeConstraints { (make) in
            make.right.equalTo(sendButton)
            make.top.height.equalTo(infoShowLabel)
            make.width.equalTo(80)
        }

        serverPortTextField.borderStyle     = .roundedRect
        sendTextField.borderStyle           = .roundedRect
        serverPortTextField.keyboardType    = .numberPad
        infoTextView.isEditable             = false
        serverPortTextField.backgroundColor = UIColor.gray1.withAlphaComponent(0.15)
        sendTextField.backgroundColor       = UIColor.gray1.withAlphaComponent(0.15)
        infoTextView.backgroundColor        = UIColor.gray1.withAlphaComponent(0.15)
        serverPortLabel.textColor           = UIColor.black1
        serverPortTextField.textColor       = UIColor.black1
        sendTextField.textColor             = UIColor.black1
        infoShowLabel.textColor             = UIColor.black1
        infoTextView.textColor              = UIColor.black1
        clearButton.backgroundColor         = UIColor.clear
        clearButton.contentHorizontalAlignment = .right
    }

    func makeData() {
        serverPortLabel.text     = "服务端监听的端口"
        serverLabel.text         = ":"
        serverPortTextField.text = "8080"
        sendTextField.text       = "服务端发送的内容"
        infoShowLabel.text       = "以下显示日志内容"
        infoTextView.text        = ""
        statusButton.setTitle("⚽️启动", for: .normal)
        statusButton.setTitle("🥅停止", for: .selected)
        sendButton.setTitle("🚀发送", for: .normal)
        clearButton.setTitle("⚠️Clear", for: .normal)
        clearButton.setTitleColor(UIColor.gray, for: .normal)

        statusButton.addTarget(self, action: #selector(startListen(_:)), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendMessage(_:)), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearInfoLog(_:)), for: .touchUpInside)
    }

    // TODO: Event
    @objc func startListen(_ button: UIButton) {
        if button.isSelected {
            socketManager?.disconnect()
        } else {
            let port = UInt16(self.serverPortTextField.text.isNilOrEmpty ? "" : self.serverPortTextField.text!) ?? 0
            socketManager = BPServerSocketManager()
            socketManager?.delegate = self
            socketManager?.listen(toPort: port)
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
        self.updateEvent("客户端已断开连接",level: .DEBUG)
    }

    func disconnectServerSocket() {
        self.statusButton.isSelected = true
        self.startListen(self.statusButton)
        self.updateEvent("服务端已停止监听", level: .DEBUG)
    }

}

