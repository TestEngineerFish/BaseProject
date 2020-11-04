//
//  BPPhotoAlbumViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/4.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPhoteAlbumViewController: BPViewController, UICollectionViewDelegate, UICollectionViewDataSource, BPPhotoAlbumToolsDelegate {

    var isSelect: Bool = false {
        willSet {
            if newValue {
                self.customNavigationBar?.title = "取消"
                self.toolsView.show()
            } else {
                self.customNavigationBar?.title = "选择"
                self.toolsView.hide()
            }
            self.collectionView.reloadData()
        }
    }

    let kBPPhotoAlbumCellID = "kBPPhotoAlbumCell"
    var imageModelList: [UIImage?] = []

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width  = kScreenWidth / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumLineSpacing      = .zero
        layout.minimumInteritemSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        return collectionView
    }()

    private var toolsView = BPPhotoAlbumToolsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.collectionView.reloadData()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "图片和视频"
        self.customNavigationBar?.rightButtonTitle = "选择"
        self.customNavigationBar?.rightFirstButtonAction = { [weak self] in
            guard let self = self else { return }
            self.isSelect = !self.isSelect
            BPLog("开始选择")
        }
        self.toolsView.delegate = self
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(BPPhotoAlbumCell.classForCoder(), forCellWithReuseIdentifier: self.kBPPhotoAlbumCellID)
    }

    // MARK: ==== Event ====


    // MARK: ==== BPPhotoAlbumToolsDelegate ====
    func clickShareAction() {
        BPLog("clickShareAction")
    }

    func clickSaveAction() {
        BPLog("clickSaveAction")
    }

    func clickDeleteAction() {
        BPLog("clickDeleteAction")
    }

    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageModelList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBPPhotoAlbumCellID, for: indexPath) as? BPPhotoAlbumCell else {
            return UICollectionViewCell()
        }
        cell.setData(image: imageModelList[indexPath.row])
        return cell
    }
}
