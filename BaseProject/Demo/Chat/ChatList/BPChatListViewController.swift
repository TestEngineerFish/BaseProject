//
//  BPChatListViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPChatListViewController: BPViewController, UITableViewDelegate, UITableViewDataSource {

    private let cellID: String = "kBPChatCell"
    private var chatModelList: [BPChatModel] = []

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

    override func createSubviews() {
        super.createSubviews()
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
        self.tableView.register(BPChatCell.classForCoder(), forCellReuseIdentifier: cellID)
        // 设置导航栏
        self.customNavigationBar?.title = "消息"
        self.customNavigationBar?.leftButton.isHidden = true
    }

    override func bindData() {
        super.bindData()
        for index in 0..<100 {
            var model = BPChatModel()
            model.id       = index
            model.name     = "Name\(index)"
            model.lastMsg  = "Message\(index)"
            model.lastTime = "10:11"
            self.chatModelList.append(model)
        }
        self.tableView.reloadData()
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? BPChatCell else {
            return UITableViewCell()
        }
        let model = self.chatModelList[indexPath.row]
        cell.setData(model: model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let charRoomVC = BPChatRoomViewController()
        self.navigationController?.push(vc: charRoomVC, animation: true)
    }
}
