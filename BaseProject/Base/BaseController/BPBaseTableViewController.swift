//
//  BPBaseTableViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPBaseTableViewController: UITableViewController {

    let dataSourceArray = Array(repeating: "好的", count: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)
        // 显示loading动画
        if scrollView.contentOffset.y < -50 {
            UIView.animate(withDuration: 0.25) {
                // 显示顶部loading动画的时候,设置TableView加载动画
                self.tableView.contentOffset = CGPoint(x: 0, y: 100)
            }
            // 显示loading动画
            self.view.showTopLoading(with: -20)
        }
    }

    // - MARK: Delegate
    // - MARK: DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.textLabel?.text = dataSourceArray[indexPath.row]
        return cell
    }
}
