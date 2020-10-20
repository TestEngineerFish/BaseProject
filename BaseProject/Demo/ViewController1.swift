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
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "Algorithm"
        self.customNavigationBar?.leftButton.isHidden = true
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.refreshHeaderEnable = true
        self.tableView.refreshFooterEnable = true
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.contentInset = .zero
        return
        let vc  = AlgorithmViewController()
        vc.type = self.typeList[indexPath.row]
        self.navigationController?.push(vc: vc)
    }
    
    // MARK: ==== BPRefreshProtocol ====
    /// 恢复头部视图
    /// - Parameter scrollView: scrollView
    func recoverHeaderView(scrollView: UIScrollView) {

    }
    /// 下拉Header中
    /// - Parameter scrollView: scrollView
    func pullingHeader(scrollView: UIScrollView) {

    }
    /// 下拉Header超过最大长度
    /// - Parameter scrollView: scrollView
    func pullMaxHeader(scrollView: UIScrollView) {

    }
    /// 刷新中
    /// - Parameter scrollView: scrollView
    func loadingHeader(scrollView: UIScrollView) {

    }
    // -------- Footer ---------
    /// 恢复底部视图
    /// - Parameter scrollView: scrollView
    func recoverFooterView(scrollView: UIScrollView) {

    }
    /// 上拉Footer中
    /// - Parameter scrollView: scrollView
    func pullingFooter(scrollView: UIScrollView) {

    }
    /// 上拉Footer超过最大长度
    /// - Parameter scrollView: scrollView
    func pullMaxFooter(scrollView: UIScrollView) {

    }
    /// 加载中
    /// - Parameter scrollView: scrollView
    func loadingFooter(scrollView: UIScrollView) {

    }
}
