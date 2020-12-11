//
//  BPPublishTagsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/12/2.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPublishTagsView: BPView, UICollectionViewDelegate, UICollectionViewDataSource, BPPublishTagCellDelegate {

    private let cellID: String = "kBPPublishTagCell"
    private var tagModelList   = [BPTagModel]()

    var collectionView: UICollectionView = {
        let layout = BPCollectionViewFlowLayout(type: .left)
        layout.estimatedItemSize       = CGSize(width: AdaptSize(50), height: AdaptSize(15))
        layout.minimumInteritemSpacing = AdaptSize(15)
        layout.minimumLineSpacing      = AdaptSize(10)
        layout.headerReferenceSize     = CGSize(width: kScreenWidth, height: AdaptSize(36))
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
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
        self.backgroundColor = .randomColor()
        self.collectionView.delegate       = self
        self.collectionView.dataSource     = self
        self.collectionView.register(BPPublishTagCell.classForCoder(), forCellWithReuseIdentifier: cellID)
    }

    // MARK: ==== Event ====
    func setData(tags modelList: [BPTagModel]) {
        self.tagModelList = modelList
        self.collectionView.reloadData()
    }

    // MARK: ==== UICollectionViewDelegate, UICollectionViewDataSource ====
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagModelList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? BPPublishTagCell else {
            return UICollectionViewCell()
        }
        let tagModel  = self.tagModelList[indexPath.row]
        cell.delegate = self
        cell.setData(tag: tagModel, indexPath: indexPath)
        return cell
    }


    // MARK: ==== BPPublishTagCellDelegate ====
    func clickTagButton(tag model: BPTagModel, indexPath: IndexPath) {
        self.tagModelList.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
    }
}
