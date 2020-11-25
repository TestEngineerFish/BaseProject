//
//  BPPublishViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/25.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPubilshViewController: BPViewController {

    private var textView: IQTextView = {
        let textView = IQTextView()
        textView.placeholder = "记录你的心情"
        textView.font = UIFont.regularFont(ofSize: AdaptSize(16))
        return textView
    }()
    private var lineView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.gray0
        return view
    }()
    private var tipsView  = BPPubilshTipsView()
    private var toolsView = BPPubilshToolsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.title = "发布帖子"
        self.customNavigationBar?.leftButton.setTitle(IconFont.close.rawValue, for: .normal)
        self.customNavigationBar?.rightFirstButton.setTitle("发布", for: .normal)
        self.customNavigationBar?.setNeedsLayout()
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(lineView)
        self.view.addSubview(textView)
        self.view.addSubview(tipsView)
        self.view.addSubview(toolsView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
            make.height.equalTo(0.9)
        }
        textView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(lineView.snp.bottom)
            make.bottom.equalTo(tipsView.snp.top)
        }
        tipsView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(textView.snp.bottom)
            make.height.equalTo(AdaptSize(30))
        }
        toolsView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(tipsView.snp.bottom)
            make.height.equalTo(AdaptSize(180))
        }
    }

    override func bindProperty() {
        super.bindProperty()
    }
}
