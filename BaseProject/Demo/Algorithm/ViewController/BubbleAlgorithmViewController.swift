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
    var restartButton: BPBaseButton = {
        let button = BPBaseButton()
        button.setTitle("Restart", for: .normal)
        button.setTitleColor(UIColor.orange1, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(16))
        return button
    }()
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
        let histogramViewSize = CGSize(width: kScreenWidth - AdaptSize(30), height: AdaptSize(200))
        self.tableView = TableView(type: self.type, frame: CGRect(origin: .zero, size: histogramViewSize))
        self.tableView?.layer.setDefaultShadow()
        self.view.addSubview(tableView!)
        self.view.addSubview(restartButton)
        self.tableView?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
            make.size.equalTo(histogramViewSize)
        })
    }

    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.isHidden = true
        self.tableView?.setData(numberList: numberList)
    }
}
