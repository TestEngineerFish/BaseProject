//
//  BPPhotoAlbumCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/4.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPhotoAlbumCell: UICollectionViewCell {
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(AdaptSize(2))
            make.right.bottom.equalToSuperview().offset(AdaptSize(-2))
        }
    }

    func setData(image: UIImage?) {
        self.imageView.image = image
    }
}
