//
//  BPEmojiCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/18.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPEmojiCellDelegate: NSObjectProtocol {
    func selectedEmoji(model: BPEmojiModel)
}

class BPEmojiCell: UICollectionViewCell {

    weak var delegate: BPEmojiCellDelegate?
    var emojiModel: BPEmojiModel?

    private var emojiButton: BPButton = {
        let button = BPButton()
        button.imageEdgeInsets = UIEdgeInsets(top: AdaptSize(10), left: AdaptSize(10), bottom: AdaptSize(10), right: AdaptSize(10))
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
        self.addSubview(emojiButton)
        emojiButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    private func bindProperty() {
        self.emojiButton.addTarget(self, action: #selector(clickButtonAction(sender:)), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    func setData(emoji model: BPEmojiModel) {
        self.emojiModel = model
        self.emojiButton.setImage(model.image, for: .normal)
    }

    @objc private func clickButtonAction(sender: BPButton) {
        guard let model = self.emojiModel else {
            return
        }
        self.delegate?.selectedEmoji(model: model)
    }
}
