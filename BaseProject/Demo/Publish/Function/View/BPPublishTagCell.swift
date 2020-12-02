//
//  BPPublishTagCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/12/2.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPPublishTagCellDelegate: NSObjectProtocol {
    func clickTagButton(tag model: BPTagModel, indexPath: IndexPath)
}

class BPPublishTagCell: UICollectionViewCell {

    weak var delegate: BPPublishTagCellDelegate?
    private var tagMode: BPTagModel?
    private var indexPath: IndexPath?

    private var tagButton: BPButton = {
        let button = BPButton()
        button.setTitleColor(UIColor.black1, for: .normal)
        button.titleLabel?.font  = UIFont.regularFont(ofSize: AdaptSize(13))
        button.backgroundColor   = .white
        button.layer.borderWidth = 0.9
        button.layer.borderColor = UIColor.gray1.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: AdaptSize(2), left: AdaptSize(15), bottom: AdaptSize(2), right: AdaptSize(15))
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
        self.addSubview(tagButton)
        tagButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func bindProperty() {
        self.tagButton.layer.cornerRadius = self.tagButton.height / 2
        self.tagButton.addTarget(self, action: #selector(self.clickTagAction), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    @objc private func clickTagAction() {
        guard let _indexPath = self.indexPath, let _tagModel = self.tagMode else { return }
        self.delegate?.clickTagButton(tag: _tagModel, indexPath: _indexPath)
    }

    func setData(tag model: BPTagModel?, indexPath: IndexPath) {
        self.tagMode   = model
        self.indexPath = indexPath

        guard let _model = model else { return }
        let name: String = {
            if indexPath.section == 0 {
                return "#" + _model.name + " X" + "\(indexPath.row)"
            } else {
                return "#" + _model.name + "\(indexPath.row)"
            }
        }()
        self.tagButton.setTitle(name, for: .normal)
        // 设置圆角
        self.tagButton.sizeToFit()
        self.tagButton.layer.cornerRadius = self.tagButton.height/2
    }
}
