//
//  BPPublishTagHeaderView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/12/2.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPPublishTagHeaderViewDelegate: NSObjectProtocol {
    func refreshAction()
}

class BPPublishTagHeaderView: UICollectionReusableView {

    weak var delegate: BPPublishTagHeaderViewDelegate?

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(11))
        label.textAlignment = .left
        return label
    }()

    private var refreshButton: BPButton = {
        let button = BPButton()
        button.setTitle("换一换", for: .normal)
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(11))
        button.contentHorizontalAlignment = .right
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(titleLabel)
        self.addSubview(refreshButton)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(AdaptSize(15))
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
            make.right.equalTo(refreshButton.snp.left).offset(AdaptSize(-15))
        }

        refreshButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(AdaptSize(100))
            make.right.equalToSuperview()
        }
    }

    private func bindProperty() {
        self.refreshButton.addTarget(self, action: #selector(refreshAction), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc private func refreshAction() {
        self.delegate?.refreshAction()
    }

    func setData(isSelected: Bool) {
        if isSelected {
            self.titleLabel.text = "当前标签"
            self.refreshButton.isHidden = true
        } else {
            self.titleLabel.text = "推荐标签"
            self.refreshButton.isHidden = false
        }
    }
}
