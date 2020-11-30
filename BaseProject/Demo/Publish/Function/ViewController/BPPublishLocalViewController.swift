//
//  BPPublishLocalViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/26.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPublishLocalViewController: BPViewController, UITableViewDelegate, UITableViewDataSource {

    var currentLocalModel: String?
    private var localModelList: [String] = []

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor                = .white
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.customNavigationBar?.isHidden = true
    }

    override func bindProperty() {
        super.bindProperty()
        self.view.backgroundColor = .randomColor()
        self.tableView.delegate   = self
        self.tableView.dataSource = self
    }

    // MARK: === UITableViewDelegate && UITableViewDataSource ===

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localModelList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
