//
//  BPPubilshToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/25.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPubilshToolsView: BPView {

    var toolBar = BPPubilshToolBar()
    private var contentView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.randomColor()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(toolBar)
        self.addSubview(contentView)
        toolBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(AdaptSize(40))
        }
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(toolBar.snp.bottom)
        }
        self.layer.cornerRadius = AdaptSize(10)
        self.layer.borderWidth  = 0.9
        self.layer.borderColor  = UIColor.gray0.cgColor
    }
}
