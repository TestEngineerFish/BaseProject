//
//  ViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController1: BPViewController, UITableViewDelegate, UITableViewDataSource, BPRefreshProtocol {

    var typeList: [AlgorithmType] = [.bubbleSort, .chooseSort, .insertionSort, .shellSort, .bubbleSort, .chooseSort, .insertionSort, .shellSort,.bubbleSort, .chooseSort, .insertionSort, .shellSort, .bubbleSort, .chooseSort, .insertionSort, .shellSort, .bubbleSort, .chooseSort, .insertionSort, .shellSort, .bubbleSort, .chooseSort, .insertionSort, .shellSort,  ]

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator   = false
        tableView.rowHeight = AdaptSize(44)
        tableView.backgroundColor = .gray1
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
        self.customNavigationBar?.title = "Algorithm"
        self.customNavigationBar?.leftButton.isHidden = true
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.refreshDelegate = self
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
        return .zero
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        BPLog(domainApi)
//        return
        let vc  = AlgorithmViewController()
        vc.type = self.typeList[indexPath.row]
        self.navigationController?.push(vc: vc)
    }
    
    // MARK: ==== BPRefreshProtocol ====
    /// 刷新中
    /// - Parameter scrollView: scrollView
    func loadingHeader(scrollView: UIScrollView, completion block: (()->Void)?) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            block?()
        }
    }
    /// 加载中
    /// - Parameter scrollView: scrollView
    func loadingFooter(scrollView: UIScrollView, completion block: (()->Void)?) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            block?()
        }
    }
}
