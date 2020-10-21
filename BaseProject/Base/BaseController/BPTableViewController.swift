//
//  BPBaseTableViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPTableViewController: UITableViewController {

    let dataSourceArray = Array(repeating: "好的", count: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.refreshHeaderEnable = true
//        self.tableView.refreshFooterEnable = true
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
