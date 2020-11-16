//
//  BPChatListViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPSessionListViewController: BPViewController, UITableViewDelegate, UITableViewDataSource {

    private let cellID: String = "kBPChatCell"
    private var chatModelList: [BPSessionModel] = []

    private var addButton: BPButton = {
        let button = BPButton()
        button.backgroundColor = .randomColor()
        button.setTitle(IconFont.more.rawValue, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(25))
        return button
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor                = .white
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.rowHeight = AdaptSize(50)
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.bindData()
    }

    override func createSubviews() {
        super.createSubviews()
        self.customNavigationBar?.rightButtonTitle = "Test"
        self.customNavigationBar?.rightFirstButtonAction = { [weak self] in
            guard let self = self else { return }
            BPAlertManager.share.showTwoButton(title: "提示", description: "添加、重置测试数据？", leftBtnName: "cancel", leftBtnClosure: nil, rightBtnName: "Agree") {
                self.resetTestData()
            }
        }
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(BPSessionCell.classForCoder(), forCellReuseIdentifier: cellID)
        // 设置导航栏
        self.customNavigationBar?.title = "消息"
        self.customNavigationBar?.leftButton.isHidden = true
    }

    override func bindData() {
        super.bindData()
        self.chatModelList = BPIMDBCenter.default.fetchAllRecnetSession()
        // 获取数据
        self.tableView.reloadData()
    }

    // MARK: ==== Event ====
    @objc private func resetTestData() {
        DispatchQueue.global().async {
            // 清空数据库数据
            BPIMDBCenter.default.deleteAllSession()
            // 插入测试数据
            for index in 0..<3 {
                // 插入会话
                var model = BPSessionModel()
                model.id       = "\(index)"
                model.type     = BPSessionType(rawValue: index % 3) ?? .normal
                model.isTop    = index < 2
                model.friendId = "\(index * 1000)"
                model.name     = "Name\(index)"
                var messageModel   = BPMessageModel()
                messageModel.text  = "Message\(index)"
                messageModel.time  = NSDate().afterDay(-index)
                model.lastMsgModel = messageModel
                BPIMDBOperator.default.insertSession(model: model)
                // 删除所有当前会话消息
                BPIMDBCenter.default.deleteAllMessage(session: model.id)
                // 插入会话对应的消息
                for index in 0..<100 {
                    var message = BPMessageModel()
                    message.id = "\(index)"
                    message.sessionId = model.id
                    message.time = NSDate().afterDay(-index)
                    if index % 2 > 0 {
                        message.text = "Message"
                    } else {
                        message.text = "Message \(index)\nMessage\nMessage\nMessage\nMessage\nMessage\nMessagenMessagenMessagenMessagenMessagenMessage"
                    }
                    if index % 3 > 1 {
                        message.fromType = .friend
                    }
                    if index % 4 > 2 {
                        message.fromType = .local
                        message.type = .time
                        let model = BPMediaModel()
                        message.mediaModel = model
                    }
                    if index % 5 > 2 {
                        message.fromType = .me
                        message.type = .image
                        let model = BPMediaModel()
                        message.mediaModel = model
                    }
                    BPIMDBCenter.default.insertMessage(message: message)
                }
            }
        }
        BPToastManager.share.showToast(message: "插入测试数据中……") { [weak self] in
            self?.bindData()
        }
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? BPSessionCell else {
            return UITableViewCell()
        }
        let model = self.chatModelList[indexPath.row]
        cell.setData(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let charRoomVC = BPChatRoomViewController()
        charRoomVC.sessionModel = self.chatModelList[indexPath.row]
        self.navigationController?.push(vc: charRoomVC, animation: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 删除会话在（数据库）
            BPIMDBCenter.default.deleteAllSession()
            // 删除会话对应的消息（数据库）
            let sessionModel = self.chatModelList[indexPath.row]
            BPIMDBCenter.default.deleteAllMessage(session: sessionModel.id)
            // 删除会话在（内存）
            self.chatModelList.remove(at: indexPath.row)
            // 删除会话（列表）
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
