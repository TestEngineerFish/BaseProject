//
//  BubbleAlgorithmViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

class BubbleAlgorithmViewController: BPViewController {

    var type: AlgorithmType

    var numberList: [CGFloat] {
        get {
            var list = [CGFloat]()
            for _ in 0...10 {
                list.append(CGFloat.random(in: 0...10))
            }
            return list
        }
    }
    
    var descriptionView: DescriptionView?
    var tableView: TableView?

    init(type: AlgorithmType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.descriptionView  = DescriptionView(type: self.type)
        let tableSize = CGSize(width: kScreenWidth - AdaptSize(30), height: AdaptSize(200))
        self.tableView = TableFactoryManager.share.createTableView(type: self.type, frame: CGRect(origin: .zero, size: tableSize))
        self.tableView?.layer.setDefaultShadow()
        self.view.addSubview(descriptionView!)
        self.view.addSubview(tableView!)
        self.descriptionView?.snp.makeConstraints({ (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(self.tableView!.snp.top).offset(AdaptSize(-15))
        })
        self.tableView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
            make.size.equalTo(tableSize)
        })
    }

    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.isHidden = true
        self.tableView?.setData(numberList: numberList)
        self.descriptionView?.delegate = self.tableView
    }
}
