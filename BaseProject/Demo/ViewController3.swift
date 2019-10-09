//
//  ViewController3.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController3: UIViewController, BPSocketProtocol, UITextFieldDelegate {

    var socketManager: BPSocketManager?

    var serverHostTextField = UITextField()
    var serverPortTextField = UITextField()
    var sendTextField       = UITextField()
    var serverLabel         = UILabel()
    var statusButton        = BPBaseButton()
    var sendButton          = BPBaseButton()
    var infoShowLabel       = UILabel()
    var infoTextView        = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        makeUI()
        makeData()
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
            make.size.equalTo(CGSize(width: 60, height: 50))
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

        serverHostTextField.borderStyle  = .roundedRect
        serverPortTextField.borderStyle  = .roundedRect
        sendTextField.borderStyle        = .roundedRect
        serverHostTextField.keyboardType = .numbersAndPunctuation
        serverPortTextField.keyboardType = .numberPad
        serverLabel.textAlignment        = .center

        serverHostTextField.delegate = self
    }

    func makeData() {
        serverHostTextField.placeholder = "127.0.0.1"
        serverLabel.text                = ":"
        serverPortTextField.placeholder = "8080"
        sendTextField.placeholder       = "消息内容"
        infoShowLabel.text              = "以下显示日志内容"
        infoTextView.text               = ""
        statusButton.setTitle("启动", for: .normal)
        statusButton.setTitle("暂停", for: .selected)
        sendButton.setTitle("发送", for: .normal)

        statusButton.addTarget(self, action: #selector(startConnection(_:)), for: .touchUpInside)
    }

    // TODO: Event
    @objc func startConnection(_ button: UIButton) {
        if button.isSelected {
            socketManager?.disconnect()
        } else {
            let host = self.serverHostTextField.text ?? ""
            let port = UInt16(self.serverPortTextField.text ?? "") ?? 0
            socketManager = BPSocketManager()
            socketManager?.delegate = self
            socketManager?.connection(toHost: host, onPort: port)
        }
        button.isSelected = !button.isSelected
    }

    // TODO: BPSocketProtocol
    func updateEvent(_ log: String) {
        self.infoTextView.text += String(format: "\n%@", log)
        self.infoTextView.scrollRectToVisible(CGRect(x: 0, y: self.infoTextView.bounds.height, width: self.infoTextView.width, height: self.infoTextView.height), animated: true)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

}
