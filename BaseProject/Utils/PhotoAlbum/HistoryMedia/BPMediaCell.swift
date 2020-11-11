//
//  BPPhotoAlbumCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/4.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Photos

protocol BPPhotoAlbumCellDelegate: NSObjectProtocol {
    func selectedImage(model: Any)
    func unselectImage(model: Any)
}

class BPMediaCell: UICollectionViewCell {
    /// 历史照片列表使用
    var model: BPMediaModel?
    /// 系统相册列表使用
    var assetMode: PHAsset?

    weak var delegate: BPPhotoAlbumCellDelegate?

    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private var selectedBgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        view.isHidden = true
        return view
    }()

    private var videoIconLabel: UILabel = {
        let label = UILabel()
        label.text          = IconFont.video.rawValue
        label.textColor     = UIColor.white
        label.font          = UIFont.iconFont(size: AdaptSize(18))
        label.textAlignment = .center
        label.isHidden      = true
        return label
    }()

    private var videoTimeLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptSize(10))
        label.textAlignment = .left
        label.isHidden      = true
        return label
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
        self.addSubview(selectedBgView)
        self.addSubview(selectButton)
        self.addSubview(videoIconLabel)
        self.addSubview(videoTimeLabel)
        imageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(0.9)
            make.right.bottom.equalToSuperview().offset(-0.9)
        }
        selectedBgView.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView)
        }
        selectButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.width.height.equalTo(AdaptSize(35))
        }
        videoIconLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(5))
            make.bottom.equalToSuperview().offset(AdaptSize(-5))
            make.size.equalTo(CGSize(width: AdaptSize(20), height: AdaptSize(18)))
        }
        videoTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(videoIconLabel.snp.right).offset(AdaptSize(5))
            make.centerY.equalTo(videoIconLabel).offset(AdaptSize(2))
            make.right.equalToSuperview().offset(AdaptSize(-10))
            make.height.equalTo(AdaptSize(10))
        }
    }

    private func bindProperty() {
        self.imageView.layer.masksToBounds = true
        self.selectButton.addTarget(self, action: #selector(selectedImage(sender:)), for: .touchUpInside)
    }

    // MARK: ==== Event ====
    func setData(model: BPMediaModel, showSelect: Bool, isSelected: Bool) {
        self.model     = model
        self.isSelected              = isSelected
        self.selectButton.isHidden   = !showSelect
        self.videoIconLabel.isHidden = model.type != .video
        self.videoTimeLabel.isHidden = model.type != .video
        self.videoTimeLabel.text     = {
            var timeStr = ""
            if Int(model.videoTime) >= hour {
                timeStr = model.videoTime.hourMinuteSecondStr()
            } else {
                timeStr = model.videoTime.minuteSecondStr()
            }
            return timeStr
        }()
        model.getThumbImage(progress: nil) { [weak self] (image: UIImage?) in
            self?.imageView.image = image
        }
        let textColor = isSelected ? UIColor.orange1 : UIColor.black.withAlphaComponent(0.2)
        self.selectButton.setTitleColor(textColor, for: .normal)
    }

    /// 显示系统相册中的照片
    func setData(asset: PHAsset, showSelect: Bool, isSelected: Bool) {
        self.assetMode               = asset
        self.isSelected              = isSelected
        self.selectedBgView.isHidden = !isSelected
        self.imageView.image         = nil
        self.selectButton.isHidden   = !showSelect
        let imageSize = (kScreenWidth - 20) / 5.5 * UIScreen.main.scale
        let options   = PHImageRequestOptions()
        options.isSynchronous = false
        PHCachingImageManager.default().requestImage(for: asset, targetSize: CGSize(width: imageSize, height: imageSize), contentMode: .default, options: options) { [weak self] (image: UIImage?, info:[AnyHashable : Any]?) in
            self?.imageView.image = image
        }
//        self.videoIconLabel.isHidden = model.type != .video
//        self.videoTimeLabel.isHidden = model.type != .video
//        self.videoTimeLabel.text     = {
//            var timeStr = ""
//            if Int(model.videoTime) >= hour {
//                timeStr = model.videoTime.hourMinuteSecondStr()
//            } else {
//                timeStr = model.videoTime.minuteSecondStr()
//            }
//            return timeStr
//        }()
        let textColor = isSelected ? UIColor.orange1 : UIColor.black.withAlphaComponent(0.2)
        self.selectButton.setTitleColor(textColor, for: .normal)
    }

    @objc private func selectedImage(sender: BPButton) {
        self.isSelected = !self.isSelected
        var imageModel: Any
        if let _model = self.model {
            imageModel = _model
        } else if let _model = self.assetMode {
            imageModel = _model
        } else {
            return
        }
        if self.isSelected {
            self.delegate?.selectedImage(model: imageModel)
        } else {
            self.delegate?.unselectImage(model: imageModel)
        }
    }

}
