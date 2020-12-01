//
//  BPPublishImageCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/12/1.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation
protocol BPPublishImageCellDelegate: NSObjectProtocol {
    func deleteImage(indexPath: IndexPath)
}

class BPPublishImageCell: UICollectionViewCell {

    weak var delegate: BPPublishImageCellDelegate?
    var indexPath: IndexPath?

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius  = AdaptSize(5)
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private var deleteButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.close.rawValue, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(13))
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
        self.addSubview(imageView)
        self.addSubview(deleteButton)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        deleteButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(AdaptSize(20))
        }
    }

    private func bindProperty() {
        self.deleteButton.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
    }

    // MARK: ==== Event ====

    @objc private func deleteImage() {
        guard let _indexPath = self.indexPath else { return }
        self.delegate?.deleteImage(indexPath: _indexPath)
    }

    func setImage(image: UIImage?, indexPath: IndexPath) {
        self.indexPath       = indexPath
        self.imageView.image = image
    }
}
