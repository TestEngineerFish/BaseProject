//
//  BPPublishLimitViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/26.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

enum BPPublishLimitType: Int {
    /// 所有人可见
    case all       = 0
    /// 仅个人主页可见
    case home      = 1
    /// 仅陌生人可见
    case stranger  = 2
    /// 仅自己可见
    case me        = 3
    /// 匿名发布
    case anonymity = 4

    var title: String {
        get {
            switch self {
            case .all:
                return "广场可见"
            case .home:
                return "仅主页可见"
            case .stranger:
                return "仅陌生人可见"
            case .me:
                return "仅自己可见"
            case .anonymity:
                return "匿名发布"
            }
        }
    }
    var subtitle: String {
        get {
            switch self {
            case .all:
                return "所有人可见"
            case .home:
                return "他人只能在你的主页看见"
            case .stranger:
                return "你关注的，关注你的均不可见"
            case .me:
                return "只有自己能看见"
            case .anonymity:
                return "头像模糊显示，所有人可见"
            }
        }
    }
}

class BPPublishLimitViewController: BPViewController, UITableViewDelegate, UITableViewDataSource {

    var currentLimitType: BPPublishLimitType = .all
    private let limitTypeList: [BPPublishLimitType]  = [.all, .home, .stranger, .me, .anonymity]
    private let cellID: String = "kBPPublishLimitCell"
    var selectedBlock: ((BPPublishLimitType)->Void)?

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor                = .white
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.isScrollEnabled = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.setCustomNaviation()
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
        self.tableView.register(BPPublishLimitCell.classForCoder(), forCellReuseIdentifier: cellID)
    }

    private func setCustomNaviation() {
        let lineView: BPView = {
            let view = BPView()
            view.backgroundColor = UIColor.gray3
            view.layer.cornerRadius = AdaptSize(2)
            return view
        }()
        self.customNavigationBar?.leftButton.setTitle(IconFont.close1.rawValue, for: .normal)
        self.customNavigationBar?.leftButton.titleLabel?.font = UIFont.iconFont(size: 15)
        self.customNavigationBar?.leftButton.left = AdaptSize(15)
        self.customNavigationBar?.leftButtonAction = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
        self.customNavigationBar?.title = "发布设置"
        self.customNavigationBar?.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(15))
            make.size.equalTo(CGSize(width: AdaptSize(45), height: AdaptSize(4)))
            make.centerX.equalToSuperview()
        }
    }

    // MARK: ==== UITableViewDelegate && UITableViewDataSource ====

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.limitTypeList.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: BPView = {
            let view = BPView()
            view.backgroundColor = UIColor.gray0
            let titleLabel: UILabel = {
                let label = UILabel()
                label.text          = "可见范围"
                label.textColor     = UIColor.gray1
                label.font          = UIFont.regularFont(ofSize: AdaptSize(9))
                label.textAlignment = .left
                return label
            }()
            view.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(AdaptSize(15))
                make.top.equalToSuperview().offset(AdaptSize(10))
                make.bottom.equalToSuperview().offset(AdaptSize(-5))
                make.right.equalToSuperview().offset(AdaptSize(-15))
            }
            return view
        }()
        return headerView
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? BPPublishLimitCell else {
            return UITableViewCell()
        }
        let type = self.limitTypeList[indexPath.row]
        let selected = (type == currentLimitType)
        cell.setData(type: type, selected: selected)
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = self.limitTypeList[indexPath.row]
        self.currentLimitType = type
        BPLog("\(self.currentLimitType.title)")
        self.selectedBlock?(type)
        tableView.reloadData()
    }
}
