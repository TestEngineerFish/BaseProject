//
//  BPPublishViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/25.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPubilshViewController: BPViewController {

    var textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .randomColor()
        return textView
    }()

    var tipsView = UIView()
    var toolsView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.title = "发布帖子"
        self.customNavigationBar?.leftButton.setTitle(IconFont.close.rawValue, for: .normal)
        self.customNavigationBar?.rightFirstButton.setTitle("发布", for: .normal)
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(textView)
        self.view.addSubview(tipsView)
        self.view.addSubview(toolsView)
        textView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
            make.height.equalTo(AdaptSize(200))
        }
        tipsView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(textView.snp.bottom)
            make.height.equalTo(AdaptSize(20))
        }
        toolsView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tipsView.snp.bottom)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.textView.backgroundColor  = .randomColor()
        self.tipsView.backgroundColor  = .randomColor()
        self.toolsView.backgroundColor = .randomColor()
    }
}
