//
//  BPEmojiToolView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/18.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPEmojiToolView: BPView, UICollectionViewDelegate, UICollectionViewDataSource {

    let cellID    = "kBPEmojiCell"
    var emojiList = [UIImage?]()

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
        for index in 0..<63 {
            let imageName  = "f_static_0\(index)"
            let imagePath  = "Emoji.bundle/" + imageName
            let emojiImage = UIImage(named: imagePath)
            self.emojiList.append(emojiImage)
        }
        self.collectionView.reloadData()
    }

    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.emojiList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? BPEmojiCell else {
            return UICollectionViewCell()
        }
        let emojiImage = self.emojiList[indexPath.row]
        cell.setData(image: emojiImage)
        return cell
    }
}
