//
//  BPEmojiToolView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/18.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPEmojiToolViewDelegate: NSObjectProtocol {
    func selectedEmoji(model: BPEmojiModel)
}

class BPEmojiToolView: BPView, UICollectionViewDelegate, UICollectionViewDataSource, BPEmojiCellDelegate {

    let cellID         = "kBPEmojiCell"
    var emojiModelList = [BPEmojiModel]()

    weak var delegate: BPEmojiToolViewDelegate?

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let w = kScreenWidth / 8
        layout.itemSize                = CGSize(width: w, height: w)
        layout.scrollDirection         = .horizontal
        layout.minimumLineSpacing      = .zero
        layout.minimumInteritemSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(BPEmojiCell.classForCoder(), forCellWithReuseIdentifier: cellID)
    }

    override func bindData() {
        super.bindData()
        let assetUrl = Bundle.main.bundleURL.appendingPathComponent("Emoji.bundle")
        guard let contents = try? FileManager.default.contentsOfDirectory(at: assetUrl, includingPropertiesForKeys: [.nameKey], options: .skipsHiddenFiles) else {
            return
        }
        for item in contents {
            var emojiName    = item.lastPathComponent
            if emojiName.hasSuffix(".png") {
                emojiName = emojiName.substring(fromIndex: 0, length: emojiName.count - 4)
            }
            let imagePath    = "Emoji.bundle/" + emojiName
            let emojiImage   = UIImage(named: imagePath)
            var emojiModel   = BPEmojiModel()
            emojiModel.name  = emojiName
            emojiModel.image = emojiImage
            self.emojiModelList.append(emojiModel)
        }
        self.collectionView.reloadData()
    }

    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.emojiModelList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? BPEmojiCell else {
            return UICollectionViewCell()
        }
        let emojiModel = self.emojiModelList[indexPath.row]
        cell.setData(emoji: emojiModel)
        cell.delegate = self
        return cell
    }

    // MARK: ==== BPEmojiCellDelegate ====
    func selectedEmoji(model: BPEmojiModel) {
        self.delegate?.selectedEmoji(model: model)
    }
}
