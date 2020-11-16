//
//  BPChatRoomViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPChatRoomViewController: BPViewController, UITableViewDelegate, UITableViewDataSource, BPChatRoomToolsViewDelegate {

    private let cellID: String = "kBPChatRoomCell"
    var sessionModel: BPSessionModel?
    private var messageModelList: [BPMessageModel] = []

    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor                = .clear
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.estimatedRowHeight             = AdaptSize(50)
        tableView.separatorStyle                 = .none
        return tableView
    }()

    private var toolsView = BPChatRoomToolsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.registerNotification()
        self.bindData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
        NotificationCenter.default.removeObserver(self)
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(contentView)
        contentView.addSubview(tableView)
        contentView.addSubview(toolsView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(toolsView.snp.top)
            make.top.equalToSuperview()
        }
        toolsView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(toolsView.moreViewHeight)
        }
        self.view.sendSubviewToBack(contentView)
    }

    override func bindProperty() {
        super.bindProperty()
        self.view.backgroundColor = .gray3
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(BPChatRoomCell.classForCoder(), forCellReuseIdentifier: cellID)
        self.customNavigationBar?.title = "姓名"
        self.customNavigationBar?.backgroundColor  = .white
        self.customNavigationBar?.rightButtonTitle = "👮‍♀️"
        self.toolsView.delegate = self
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }

    override func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func bindData() {
        super.bindData()
        guard let _sessionModel = self.sessionModel else {
            return
        }
        self.messageModelList = BPIMDBCenter.default.selectAllMessage(session: _sessionModel.id)
        self.tableView.reloadData()
    }

    // MARK: ==== Event ====
    @objc private func showKeyboard(notification: Notification) {
        guard let frameValue = notification.userInfo?[BPChatRoomViewController.keyboardFrameEndUserInfoKey] as? CGRect, let durationTime = notification.userInfo?[BPChatRoomViewController.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        self.scrollViewToBottom()
        UIView.animate(withDuration: durationTime) { [weak self] in
            guard let self = self else { return }
            let offsetY = -(frameValue.height - kSafeBottomMargin)
            self.contentView.transform = CGAffineTransform(translationX: 0, y: offsetY)
        }
    }

    @objc private func hideKeyboard(notification: Notification) {
        guard let durationTime = notification.userInfo?[BPChatRoomViewController.keyboardAnimationDurationUserInfoKey] as? TimeInterval else {
            return
        }
        UIView.animate(withDuration: durationTime) { [weak self] in
            guard let self = self else { return }
            self.contentView.transform = .identity
        }
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.messageModelList.count
        self.scrollViewToBottom(animated: false)
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? BPChatRoomCell else {
            return UITableViewCell()
        }
        let model = self.messageModelList[indexPath.row]
        cell.setData(model: model)
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        BPLog(scrollView.contentOffset)
    }

    // MARK: ==== Tools ===
    /// 滑动到列表底部
    /// - Parameter animated: 是否显示动画
    private func scrollViewToBottom(animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) { [weak self] in
            guard let self = self, !self.messageModelList.isEmpty else { return }
            let offsetIndexPath = IndexPath(row: self.messageModelList.count - 1, section: 0)
            self.tableView.scrollToRow(at: offsetIndexPath, at: .bottom, animated: false)
        }
    }

    // MARK: ==== BPChatRoomToolsViewDelegate ====
    func clickSwitchAction(transform: CGAffineTransform) {
        BPLog("clickSwitchAction")
    }

    func clickEmojiAction(transform: CGAffineTransform) {
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.contentView.transform = transform
        } completion: { (finished) in
            if finished {
                self.view.isUserInteractionEnabled = true
            }
        }
        BPLog("clickEmojiAction")
    }

    func clickMoreAction(transform: CGAffineTransform) {
        self.view.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.contentView.transform = transform
        } completion: { (finished) in
            if finished {
                self.view.isUserInteractionEnabled = true
            }
        }
    }

    func recordingAction() {
        BPLog("recordingAction")
    }

    func sendMessage(text: String) {
        guard var _sessionModel = self.sessionModel else { return }
        BPLog("sendMessage:\(text)")
        var messageMode = BPMessageModel()
        messageMode.id        = "\(Date().local().timeIntervalSince1970)"
        messageMode.sessionId = _sessionModel.id
        messageMode.text      = text
        messageMode.time      = Date().local()
        messageMode.type      = .text
        messageMode.fromType  = .me
        messageMode.status    = .success
        messageMode.unread    = true
        // 插入message表
        BPIMDBCenter.default.insertMessage(message: messageMode)
        // 更新session表
        _sessionModel.lastMsgModel = messageMode
        BPIMDBCenter.default.updateSessionModel(model: _sessionModel)
        self.messageModelList.append(messageMode)
        let nextIndexPath = IndexPath(row: self.messageModelList.count - 1, section: 0)
        self.tableView.insertRows(at: [nextIndexPath], with: .none)
    }
}
