//
//  BPPublishImageListView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/27.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPublishImageListView: BPView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, BPPublishImageCellDelegate {

    private let cellID = "kBPPublishImageCell"
    private var imageViewList = [UIImage]()
    let imageHeight: CGFloat  = AdaptSize(60)

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = AdaptSize(5)
        layout.scrollDirection    = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
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
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView.register(BPPublishImageCell.classForCoder(), forCellWithReuseIdentifier: cellID)
    }

    // MARK: ==== Event ====
    func addImage(image: UIImage) {
        self.imageViewList.append(image)
        self.collectionView.reloadData()
    }

    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource && UICollectionViewDelegateFlowLayout ====

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? BPPublishImageCell else {
            return UICollectionViewCell()
        }
        let image = self.imageViewList[indexPath.row]
        cell.delegate = self
        cell.setImage(image: image, indexPath: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: imageHeight, height: imageHeight)
    }

    // MARK: ==== BPPublishImageCellDelegate ====
    func deleteImage(indexPath: IndexPath) {
        self.imageViewList.remove(at: indexPath.row)
        self.collectionView.deleteItems(at: [indexPath])
        // 如果无照片，则不显示当前视图
        if imageViewList.isEmpty && self.superview != nil {
            self.snp.updateConstraints { (make) in
                make.height.equalTo(0)
            }
        }
    }
}
