//
//  ViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

enum BPFunctionType: String {
    case algorithm = "算法图解"
    case chat      = "聊天"
    case webSocket = "WebSocket"
    case earth     = "球形动效"
}

class ViewController1: BPViewController, UITableViewDelegate, UITableViewDataSource, BPRefreshProtocol {

    var typeList: [BPFunctionType] = [.algorithm, .chat, .webSocket, .earth]

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator   = false
        tableView.rowHeight           = AdaptSize(44)
        tableView.backgroundColor     = .white
        tableView.refreshFooterEnable = true
        tableView.refreshHeaderEnable = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavHeight)
            make.left.right.bottom.equalToSuperview()
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "Function"
        self.customNavigationBar?.leftButton.isHidden = true
        self.tableView.delegate   = self
        self.tableView.dataSource = self
    }

    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = self.typeList[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "algorithm")
        cell.textLabel?.text = type.rawValue
        cell.selectionStyle  = .none
        cell.accessoryType   = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = self.typeList[indexPath.row]
        switch type {
        case .algorithm:
            let vc = BPAlgorithmListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .chat:
            let vc = BPSessionListViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case .webSocket:
            let vc = BPWebSocketClient()
            self.navigationController?.pushViewController(vc, animated: true)
        case .earth:
            let vc = BPEarthViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
}
