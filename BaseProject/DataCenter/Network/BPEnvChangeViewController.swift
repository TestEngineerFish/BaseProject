//
//  BPEnvChangeViewController.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/22.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

enum BPEnvType: Int {
    case dev     = 0
    case test    = 1
    case pre     = 2
    case release = 3
    
    var api: String {
        get {
            switch self {
            case .dev:
                return "https://dev"
            case .test:
                return "https://test"
            case .pre:
                return "https://pre"
            case .release:
                return "https://release"
            }
        }
    }
    var title: String {
        get {
            switch self {
            case .dev:
                return "开发环境v"
            case .test:
                return "测试环境"
            case .pre:
                return "预发布环境"
            case .release:
                return "正式环境"
            }
        }
    }
    
}

class BPEnvChangeViewController: BPViewController , UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = AdaptSize(44)
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    private var changeButton: BPButton = {
        let button = BPButton(.theme)
        button.setTitle("确认切换", for: .normal)
        button.setStatus(.disable)
        return button
    }()
    
    private var backButton: BPButton = {
        let button = BPButton(.normal)
        button.setTitle("返回", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(tableView)
        self.view.addSubview(changeButton)
        self.view.addSubview(backButton)
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(changeButton.snp.top).offset(AdaptSize(20))
        }
        changeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.bottom.equalToSuperview().offset(AdaptSize(-50) - kSafeBottomMargin)
            make.size.equalTo(CGSize(width: kScreenWidth / 3, height: AdaptSize(50)))
        }
        backButton.snp.makeConstraints { (make) in
            make.bottom.size.equalTo(changeButton)
            make.left.equalToSuperview().offset(AdaptSize(15))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.tableView.delegate   = self
        self.tableView.dataSource = self
    }
    
    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let env = BPEnvType(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = env.title
        cell.detailTextLabel?.text = env.api
        return cell
    }
}
