//
//  BPSystemAlbumCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/10.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

class BPSystemAlbumCell: UITableViewCell {
    private var albumImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        return label
    }()
    private var selectedLabel: UILabel = {
        let label = UILabel()
        label.text          = IconFont.select.rawValue
        label.textColor     = UIColor.orange1
        label.font          = UIFont.iconFont(size: AdaptSize(14))
        label.textAlignment = .center
        label.isHidden      = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(albumImageView)
        self.addSubview(nameLabel)
        self.addSubview(selectedLabel)
        albumImageView.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.width.height.equalTo(self.snp.height)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(albumImageView.snp.right).offset(AdaptSize(15))
            make.right.equalTo(selectedLabel.snp.left).offset(AdaptSize(-5))
            make.centerY.height.equalToSuperview()
        }
        selectedLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(AdaptSize(16))
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
    }

    private func bindProperty() {
        self.selectionStyle = .none
    }

    func setData(model: BPPhotoAlbumModel, isCurrent: Bool) {
        self.albumImageView.image   = UIImage(named: "dog")
        self.nameLabel.text         = (model.assetCollection?.localizedTitle ?? "") + "(\(model.assets.count))"
        self.selectedLabel.isHidden = !isCurrent
    }
}
