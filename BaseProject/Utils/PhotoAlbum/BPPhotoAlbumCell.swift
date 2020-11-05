//
//  BPPhotoAlbumCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/4.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPPhotoAlbumCellDelegate: NSObjectProtocol {
    func selectedImage(image: UIImage?)
    func unselectImage(image: UIImage?)
}

class BPPhotoAlbumCell: UICollectionViewCell {

    var image: UIImage?

    weak var delegate: BPPhotoAlbumCellDelegate?

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private var selectButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.select.rawValue, for: .normal)
        button.setTitleColor(UIColor.black.withAlphaComponent(0.2), for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(22))
        button.titleEdgeInsets  = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0)
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

    private func createSubviews() {
        self.addSubview(imageView)
        self.addSubview(selectButton)
        imageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(0.9)
            make.right.bottom.equalToSuperview().offset(-0.9)
        }
        selectButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(AdaptSize(35))
        }
    }

    private func bindProperty() {
        self.imageView.layer.masksToBounds = true
        self.selectButton.addTarget(self, action: #selector(selectedImage(sender:)), for: .touchUpInside)
    }

    override var isSelected: Bool {
        willSet {

        }
    }

    // MARK: ==== Event ====
    func setData(model: BPMediaModel, isSelected: Bool) {
        model.getThumbImage(progress: nil) { [weak self] (image: UIImage?) in
            self?.imageView.image = image
        }
        let textColor = isSelected ? UIColor.orange1 : UIColor.black.withAlphaComponent(0.2)
        self.selectButton.setTitleColor(textColor, for: .normal)
    }

    @objc private func selectedImage(sender: BPButton) {
        self.isSelected = !self.isSelected
        if self.isSelected {
            self.delegate?.selectedImage(image: image)
        } else {
            self.delegate?.unselectImage(image: image)
        }
    }
}
