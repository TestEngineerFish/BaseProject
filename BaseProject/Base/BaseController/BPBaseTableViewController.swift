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
        let refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "刷新咯")
        refresh .addTarget(self, action: #selector(_refresh), for: .valueChanged)
        self.refreshControl = refresh
    }

    @objc func _refresh() {
        if self.refreshControl?.isRefreshing ?? false {
            print("refreshing")
        } else {
            print("refresh end")
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
