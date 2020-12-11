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
        tableView.rowHeight = AdaptSize(55)
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
    }

    override func bindData() {
        super.bindData()
        self.chatModelList = BPIMDBCenter.default.fetchAllRecnetSession()
        // 获取数据
        self.tableView.reloadData()
    }

    // MARK: ==== Event ====
    @objc private func resetTestData() {
        BPToastManager.share.showToast(message: "插入测试数据中……", complete: nil)
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            var imageLocalPath: String?
            // 写入测试图片
            if let imageData = UIImage(named: "dog")?.pngData() {
                imageLocalPath = BPFileManager.share.saveMediaFile(name: "dog", data: imageData, type: .thumbImage)
            }
            // 清空数据库数据
            BPIMDBCenter.default.deleteAllSession()
            // 插入测试数据
            for index in 0..<10 {
                // 插入会话
                var sessionModel = BPSessionModel()
                sessionModel.isTop    = index % 10 == 0
                sessionModel.id       = "\(index)"
                sessionModel.type     = BPSessionType(rawValue: index % 3) ?? .normal
                sessionModel.friendId = "\(index * 1000)"
                sessionModel.friendName = "Name\(index)"

                // 删除所有当前会话消息
                BPIMDBCenter.default.deleteAllMessage(session: sessionModel.id)
                // 插入会话对应的消息
                let maxMessageCount = 100
                for index in 1...maxMessageCount {
                    var message = BPMessageModel()
                    message.id        = "\(index)"
                    message.sessionId = sessionModel.id
                    message.time      = NSDate().afterDay(-index)
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
                        message.type     = .time
                        let model = BPMediaModel()
                        message.mediaModel = model
                    }
                    if index % 5 > 3 {
                        message.fromType = .me
                        message.type     = .image
                        var model = BPMediaModel()
                        model.id                  = "\(index + 100)"
                        model.thumbnailLocalPath  = imageLocalPath ?? ""
                        model.originLocalPath     = imageLocalPath ?? ""
                        model.thumbnailRemotePath = "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1588620919,359805583&fm=26&gp=0.jpg"
                        model.originRemotePath = "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3313838802,2768404782&fm=26&gp=0.jpg"
                        message.mediaModel = model
                    }
                    BPIMDBCenter.default.insertMessage(message: message)
                    if index == maxMessageCount {
                        sessionModel.lastMessage       = message.text
                        sessionModel.lastMessageTime   = message.time
                        sessionModel.lastMessageType   = message.type
                        sessionModel.lastMessageStatus = message.status
                    }
                }
                BPIMDBOperator.default.insertSession(model: sessionModel)
            }
            DispatchQueue.main.async { [weak self] in
                self?.bindData()
            }
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

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let model = self.chatModelList[indexPath.row]
        let title = model.isTop ? "取消置顶" : "置顶"
        let color = model.isTop ? UIColor.gray1 : UIColor.orange1

        let topAction = UITableViewRowAction(style: .normal, title: title) { [weak self] (action, indexPath) in
            guard let self = self else { return }
            let sessionModel = self.chatModelList[indexPath.row]
            let result       = BPIMDBCenter.default.updateSessionTop(isTop: !sessionModel.isTop, session: sessionModel.id)
            if result {
                self.bindData()
            }
        }
        topAction.backgroundColor = color

        let deleteAction = UITableViewRowAction(style: .destructive, title: "删除") { [weak self] (action:UITableViewRowAction, indexPath) in
            guard let self = self else { return }
            let sessionModel = self.chatModelList[indexPath.row]
            // 删除会话在（数据库）
            BPIMDBCenter.default.deleteSession(session: sessionModel.id)
            // 删除会话对应的消息（数据库）
            BPIMDBCenter.default.deleteAllMessage(session: sessionModel.id)
            // 删除会话在（内存）
            self.chatModelList.remove(at: indexPath.row)
            // 删除会话（列表）
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction, topAction]
    }
}
