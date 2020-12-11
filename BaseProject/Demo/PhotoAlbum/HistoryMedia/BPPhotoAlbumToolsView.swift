//
//  BPPhotoAlbumToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/4.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPPhotoAlbumToolsDelegate: NSObjectProtocol {
    func clickShareAction()
    func clickSaveAction()
    func clickDeleteAction()
}

class BPPhotoAlbumToolsView: BPView {

    weak var delegate: BPPhotoAlbumToolsDelegate?

    private var shareButton: BPButton = {
        let button = BPButton()
        button.setTitle("分享", for: .normal)
        button.setTitleColor(UIColor.white1, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()
    private var saveButton: BPButton = {
        let button = BPButton()
        button.setTitle("保存", for: .normal)
        button.setTitleColor(UIColor.white1, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()
    private var deleteButton: BPButton = {
        let button = BPButton()
        button.setTitle("删除", for: .normal)
        button.setTitleColor(UIColor.white1, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(13))
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        let itemSize = CGSize(width: AdaptSize(50), height: 50)
        shareButton.size    = itemSize
        saveButton.size     = itemSize
        deleteButton.size   = itemSize
        let stackView = UIStackView(arrangedSubviews: [shareButton, saveButton, deleteButton])
        stackView.alignment    = .center
        stackView.axis         = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing      = AdaptSize(50)
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
}
