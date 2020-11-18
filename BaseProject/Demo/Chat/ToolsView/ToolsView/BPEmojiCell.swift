//
//  BPEmojiCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/18.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPEmojiCell: UICollectionViewCell {
    private var emojiButton: BPButton = {
        let button = BPButton()
        button.imageEdgeInsets = UIEdgeInsets(top: AdaptSize(10), left: AdaptSize(10), bottom: AdaptSize(10), right: AdaptSize(10))
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(emojiButton)
        emojiButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: ==== Event ====
    func setData(image: UIImage?) {
        self.emojiButton.setImage(image, for: .normal)
    }
}
