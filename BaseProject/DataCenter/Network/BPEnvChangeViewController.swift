//
//  BPEnvChangeViewController.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/22.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

public enum BPEnvType: Int {
    /// 偏移量
    static var offset = 1
    
    case dev     = 1
    case test    = 2
    case pre     = 3
    case release = 4
    
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
                return "开发环境"
            case .test:
                return "测试环境"
            case .pre:
                return "预发环境"
            case .release:
                return "正式环境"
            }
        }
    }
}

class BPEnvChangeViewController: BPViewController , UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = AdaptSize(55)
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
        let button = BPButton(.border)
        button.setTitle("返回", for: .normal)
        return button
    }()
    
    private var tmpEnv: BPEnvType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.leftButton.isHidden = true
        self.customNavigationBar?.title = "选择环境"
        self.createSubviews()
        self.bindProperty()
        self.printDocumentPath()
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(tableView)
        self.view.addSubview(changeButton)
        self.view.addSubview(backButton)
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(100))
            make.left.right.equalToSuperview()
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
        self.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.changeButton.addTarget(self, action: #selector(changeAction), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    @objc private func backAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func changeAction() {
        guard let newEnv = self.tmpEnv else { return }
        currentEnv = newEnv
        self.backAction()
    }

    /// 打印当前项目路径
    private func printDocumentPath() {
        BPLog(BPFileManager.share.documentPath)
    }
    
    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let env = BPEnvType(rawValue: indexPath.row + BPEnvType.offset) else {
            return UITableViewCell()
        }
        // 设置选中的Cell样式
        let cellStyle: UITableViewCell.CellStyle = {
            var isSelected = false
            if let tmpEnv = self.tmpEnv {
                isSelected = env == tmpEnv
            } else {
                isSelected = env == currentEnv
            }
            return isSelected ? .value2 : .subtitle
        }()
        let cell = UITableViewCell(style: cellStyle, reuseIdentifier: nil)
        cell.textLabel?.text = env.title
        cell.textLabel?.font = UIFont.mediumFont(ofSize: AdaptSize(20))
        cell.detailTextLabel?.text = env.api
        cell.detailTextLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        cell.detailTextLabel?.textColor = UIColor.gray1
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newEnv = BPEnvType(rawValue: indexPath.row + BPEnvType.offset) else {
            return
        }
        // 临时选择，未确认切换
        self.tmpEnv = newEnv
        self.changeButton.setStatus(.normal)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
