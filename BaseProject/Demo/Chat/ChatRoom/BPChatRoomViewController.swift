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
    private var firstScrollToBool = true
    private var messageModelList: [BPMessageModel] = []

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor                = .white
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.estimatedRowHeight = AdaptSize(50)
        tableView.separatorStyle = .none
        return tableView
    }()

    private var toolsView = BPChatRoomToolsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(tableView)
        self.view.addSubview(toolsView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(toolsView.snp.top)
            make.top.equalToSuperview().offset(kNavHeight)
        }
        toolsView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(55) + kSafeBottomMargin)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(BPChatRoomCell.classForCoder(), forCellReuseIdentifier: cellID)
        self.customNavigationBar?.title = "姓名"
        self.toolsView.delegate = self
    }

    override func bindData() {
        super.bindData()
        for index in 0..<100 {
            var message = BPMessageModel()
            if index % 2 > 0 {
                message.text = "Message"
            } else {
                message.text = "Message \(index)\nMessage\nMessage\nMessage\nMessage\nMessage\nMessagenMessagenMessagenMessagenMessagenMessage"
            }
            if index % 3 > 1 {
                message.fromType = .friend
            }
            if index % 4 > 2 {
                message.type = .image
                let model = BPMediaModel()
                message.mediaModel = model
            }
            self.messageModelList.append(message)
        }
        self.tableView.reloadData()
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

    // MARK: ==== Tools ===
    /// 滑动到列表底部
    /// - Parameter animated: 是否显示动画
    private func scrollViewToBottom(animated: Bool) {
        guard self.firstScrollToBool else {
            return
        }
        self.firstScrollToBool = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.005) { [weak self] in
            guard let self = self, !self.messageModelList.isEmpty else { return }
            let offsetIndexPath = IndexPath(row: self.messageModelList.count - 1, section: 0)
            self.tableView.scrollToRow(at: offsetIndexPath, at: .bottom, animated: false)
        }
    }

    // MARK: ==== BPChatRoomToolsViewDelegate ====
    func clickSwitchAction() {
        BPLog("clickSwitchAction")
    }

    func clickEmojiAction() {
        BPLog("clickEmojiAction")
    }

    func clickMoreAction() {
        BPLog("clickMoreAction")
    }

    func recordingAction() {
        BPLog("recordingAction")
    }

    func sendMessage(text: String) {
        BPLog("sendMessage:\(text)")
    }
}
