//
//  BPSystemPhotoViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/8.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Photos

class BPSystemPhotoViewController: BPPhotoAlbumViewController, BPSystemAlbumListViewDelegate {

    var collectionList: [BPPhotoAlbumModel] = []
    var albumModel: BPPhotoAlbumModel?
    var albumListView: BPSystemAlbumListView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindData()
    }

    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.backgroundColor = .white
        self.customNavigationBar?.title = ""
        self.isSelect = true
    }

    override func bindData() {
        super.bindData()

        // 点击相册名可更换其他相册
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.showAlbumList))
        self.customNavigationBar?.titleLabel.isUserInteractionEnabled = true
        self.customNavigationBar?.titleLabel.addGestureRecognizer(tapAction)
        BPAuthorizationManager.share.photo { [weak self] (result) in
            guard let self = self, result else { return }
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                // 收藏相册
                let favoritesCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
                // 相机照片
                let assetCollections     = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumUserLibrary, options: nil)
                // 全部照片
                let cameraRolls          = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)

                cameraRolls.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    let model = BPPhotoAlbumModel(collection: collection)
                    self?.collectionList.append(model)
                }
                favoritesCollections.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    let model = BPPhotoAlbumModel(collection: collection)
                    self?.collectionList.append(model)
                }
                assetCollections.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    let model = BPPhotoAlbumModel(collection: collection)
                    self?.collectionList.append(model)
                }
                self.albumModel = self.collectionList.first
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    // 相册名称
                    self.customNavigationBar?.title = self.albumModel?.assetCollection?.localizedTitle
                    // 更新数据
                    self.collectionView.reloadData()
                }
            }
        }
    }

    // MARK: ==== Event ====
    @objc private func showAlbumList() {
        if let listView = self.albumListView {
            listView.hideView()
            self.albumListView = nil
        } else {
            self.albumListView = BPSystemAlbumListView()
            self.albumListView?.delegate = self
            self.view.addSubview(self.albumListView!)
            albumListView?.snp.makeConstraints { (make) in
                make.edges.equalTo(self.collectionView)
            }
            self.albumListView?.setData(albumList: self.collectionList, current: self.albumModel)
            self.albumListView?.tableView.reloadData()
            self.albumListView?.showView()
        }
    }

    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumModel?.assets.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBPPhotoAlbumCellID, for: indexPath) as? BPMediaCell, let collection = self.albumModel else {
            return UICollectionViewCell()
        }

        let asset    = collection.assets[indexPath.row]
        let selected = self.selectedList.contains(indexPath)
        cell.setData(asset: asset, showSelect: self.isSelect, isSelected: selected, indexPath: indexPath)
        cell.delegate = self
        return cell
    }

    // MARK: ==== BPPhotoAlbumCellDelegate ====
    override func selectedImage(indexPath: IndexPath) {
        super.selectedImage(indexPath: indexPath)
    }

    override func unselectImage(indexPath: IndexPath) {
        super.unselectImage(indexPath: indexPath)
    }

    // MARK: ==== BPSystemAlbumListViewDelegate ====
    func selectedAlbum(model: BPPhotoAlbumModel) {
        self.albumModel = model
        self.collectionView.reloadData()
    }
}
