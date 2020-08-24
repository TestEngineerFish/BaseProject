//
//  AlgorithmViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

class AlgorithmViewController: BPViewController {

    var type: AlgorithmType = .bubbleSort
    
    var descriptionView: BaseDescriptionView?
    var tableView: BaseTableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.descriptionView = DescriptionFactoryManager.share.createTableView(type: self.type, frame: .zero)
        self.tableView       = TableFactoryManager.share.createTableView(type: self.type, frame: .zero)
        self.tableView?.layer.setDefaultShadow()
        self.view.addSubview(descriptionView!)
        self.view.addSubview(tableView!)
        self.descriptionView?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(15))
            make.bottom.equalTo(self.tableView!.snp.top).offset(AdaptSize(-15))
        })
        self.tableView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-15) - kSafeBottomMargin)
            make.size.equalTo(self.tableView!.size)
        })
    }

    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.leftButton.isHidden = true
        self.customNavigationBar?.title = self.type.rawValue
        self.tableView?.setData()
        self.descriptionView?.delegate = self.tableView
    }
}
