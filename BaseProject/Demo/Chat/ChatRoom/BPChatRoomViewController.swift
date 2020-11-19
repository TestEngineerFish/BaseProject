//
//  BPChatRoomViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPChatRoomViewController: BPViewController, UITableViewDelegate, UITableViewDataSource, BPChatRoomToolsViewDelegate, BPChatRoomCellDelegate {

    private let textCellID: String  = "kBPChatRoomCell"
    private let localCellID: String = "kBPChatRoomLocalTimeCell"
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        guard var _sessionModel = self.sessionModel else {
            return
        }
        let draftContent = self.toolsView.textFieldView.text ?? ""
        if draftContent.isEmpty {
            if _sessionModel.lastMessageType == .draft, _sessionModel.lastMessage?.isEmpty != .some(true) {
                guard let lastMessageModel = self.messageModelList.last else {
                    return
                }
                // 移除草稿，显示最后一条已发消息
                _sessionModel.lastMessage       = lastMessageModel.text
                _sessionModel.lastTimestamp     = lastMessageModel.time
                _sessionModel.lastMessageType   = lastMessageModel.type
                _sessionModel.lastMessageStatus = lastMessageModel.status
                BPIMDBCenter.default.updateSessionModel(model: _sessionModel)
            }
        } else {
            if draftContent != sessionModel?.lastMessage {
                // 存储草稿
                _sessionModel.lastMessage       = draftContent
                _sessionModel.lastMessageTime   = Date()
                _sessionModel.lastMessageType   = .draft
                _sessionModel.lastMessageStatus = .editing
                BPIMDBCenter.default.updateSessionModel(model: _sessionModel)
            }
        }
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
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(toolsView.moreViewHeight)
            make.top.equalToSuperview().offset(kNavHeight)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(toolsView.snp.top)
            make.top.equalToSuperview()
        }
        toolsView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.view.sendSubviewToBack(contentView)
    }

    override func bindProperty() {
        super.bindProperty()
        self.view.backgroundColor = .gray3
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(BPChatRoomCell.classForCoder(), forCellReuseIdentifier: textCellID)
        self.tableView.register(BPChatRoomLocalTimeCell.classForCoder(), forCellReuseIdentifier: localCellID)
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
        if _sessionModel.lastMessageType == .draft {
            self.toolsView.textFieldView.text = _sessionModel.lastMessage
        }
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
        let model = self.messageModelList[indexPath.row]
        switch model.fromType {
        case .me, .friend:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: textCellID, for: indexPath) as? BPChatRoomCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.setData(model: model, indexPath: indexPath)
            return cell
        case .local:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: localCellID, for: indexPath) as? BPChatRoomLocalTimeCell else {
                return UITableViewCell()
            }
            cell.setData(time: model.time)
            return cell
        default:
            return UITableViewCell()
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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

    /// 发送时间消息
    private func sendTimeMessage() {
        guard var _sessionModel = self.sessionModel else { return }
        var messageModel = BPMessageModel()
        messageModel.id        = "\(Date().local().timeIntervalSince1970)"
        messageModel.sessionId = _sessionModel.id
        messageModel.time      = Date()
        messageModel.type      = .time
        messageModel.fromType  = .local
        messageModel.status    = .success
        messageModel.unread    = false
        self.sendMessageBlock(updateSession: false, checkTime: false, message: messageModel)
        // 更新最后一条时间戳
        _sessionModel.lastTimestamp      = messageModel.time
        BPIMDBCenter.default.updateSessionLastShowTime(model: _sessionModel)
        self.sessionModel?.lastTimestamp = messageModel.time
    }

    /// 发送文本消息
    private func sendTextMessage(text: String) {
        guard let _sessionModel = self.sessionModel else { return }
        var messageModel = BPMessageModel()
        messageModel.id        = "\(Date().local().timeIntervalSince1970)"
        messageModel.sessionId = _sessionModel.id
        messageModel.text      = text
        messageModel.time      = Date()
        messageModel.type      = .text
        messageModel.fromType  = .me
        messageModel.status    = .success
        messageModel.unread    = false
        self.sendMessageBlock(message: messageModel)
    }

    /// 发送图片消息
    private func sendImageMessage(image: UIImage) {
        guard let _sessionModel = self.sessionModel, let imageData = image.pngData() else { return }
        let imageName = "\(Date().hashValue)"
        let path = BPFileManager.share.saveMediaFile(name: imageName, data: imageData, type: .originImage)
        var mediaModel = BPMediaModel()
        mediaModel.name            = imageName
        mediaModel.originLocalPath = path
        mediaModel.id              = "\(Date().local().timeIntervalSince1970)"

        var messageModel = BPMessageModel()
        messageModel.id         = "\(Date().local().timeIntervalSince1970)"
        messageModel.sessionId  = _sessionModel.id
        messageModel.time       = Date()
        messageModel.type       = .image
        messageModel.fromType   = .me
        messageModel.status     = .success
        messageModel.unread     = false
        messageModel.mediaModel = mediaModel
        self.sendMessageBlock(message: messageModel)
    }

    /// 发送消息
    /// - Parameters:
    ///   - updateSession: 是否更新最近会话列表
    ///   - checkTime: 是否检测时间戳
    ///   - model: 消息对象
    private func sendMessageBlock(updateSession: Bool = true, checkTime: Bool = true, message model: BPMessageModel) {
        guard var _sessionModel = self.sessionModel else { return }
        if checkTime {
            self.checkLastShowTime()
        }
        if updateSession {
            // 更新session表
            _sessionModel.lastMessage       = model.text
            _sessionModel.lastMessageTime   = model.time
            _sessionModel.lastMessageType   = model.type
            _sessionModel.lastMessageStatus = model.status
            BPIMDBCenter.default.updateSessionModel(model: _sessionModel)
        }
        // 插入message表
        BPIMDBCenter.default.insertMessage(message: model)
        // 更新列表
        self.messageModelList.append(model)
        let nextIndexPath = IndexPath(row: self.messageModelList.count - 1, section: 0)
        self.tableView.insertRows(at: [nextIndexPath], with: .none)
    }

    /// 检查当前时间与上一条消息的时间
    private func checkLastShowTime() {
        if let lastTime = self.sessionModel?.lastTimestamp {
            // 如果距离上一次的时间消息，则发送时间戳
            if Date().timeIntervalSince(lastTime).minute() >= 5 {
                self.sendTimeMessage()
            }
        } else {
            self.sendTimeMessage()
        }
    }

    // MARK: ==== BPChatRoomToolsViewDelegate ====
    func clickEmojiAction(transform:CGAffineTransform) {
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
    func clickPhotoAction() {
        BPSystemPhotoManager.share.showPhoto { [weak self] (image: UIImage?) in
            guard let self = self, let _image = image else { return }
            self.sendImageMessage(image: _image)
        }
    }
    func clickCameraAction() {
        BPSystemPhotoManager.share.showCamera { [weak self] (image: UIImage?) in
            guard let self = self, let _image = image else { return }
            self.sendImageMessage(image: _image)
        }
        BPLog("clickCameraAction")
    }
    func clickRecordAction(transform:CGAffineTransform) {
        BPLog("clickRecordAction")
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
    func clickGiftAction(transform:CGAffineTransform) {
        BPLog("clickGiftAction")
    }
    func clickMoreAction(transform:CGAffineTransform) {
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
        self.sendTextMessage(text: text)
    }

    // MARK: ==== BPChatRoomCellDelegate ====
    func clickBubble(model: BPMessageModel, indexPath: IndexPath) {
        var currentIndex   = 0
        var tmpIndex       = 0
        var mediaModelList = [BPMediaModel]()
        // 过滤得到图片资源数组，并得到当前图片的下标
        for messageModel in self.messageModelList {
            if messageModel.type == .image {
                guard let mediaModel = messageModel.mediaModel else {
                    break
                }
                if model.mediaModel?.id == mediaModel.id {
                    currentIndex = tmpIndex
                }
                tmpIndex += 1
                mediaModelList.append(mediaModel)
            }
        }
        if model.type == .image {
            guard let cell = self.tableView.cellForRow(at: indexPath) as? BPChatRoomCell, let bubbleView = cell.bubbleView as? BPChatRoomImageMessageBubble else {
                return
            }
            BPImageBrowser(dataSource: mediaModelList, current: currentIndex).show(animationView: bubbleView.imageView)
        }
    }
}
