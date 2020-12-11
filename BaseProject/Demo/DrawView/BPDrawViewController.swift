//
//  BPDrawViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/12/11.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPDrawViewController: BPViewController {

    private let drawView = DrawView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(drawView)
        drawView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavHeight)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(kScreenWidth)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.view.backgroundColor = .gray0
    }

}
