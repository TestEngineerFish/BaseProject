//
//  BPSystemPhotoViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/8.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Photos

class BPSystemPhotoViewController: BPViewController, BPSystemAlbumListViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, BPPhotoAlbumCellDelegate {

    let kBPPhotoAlbumCellID = "kBPPhotoAlbumCell"
    /// 当前相册对象
    var albumModel: BPPhotoAlbumModel?
    /// 所有相册列表
    var collectionList: [BPPhotoAlbumModel] = []
    /// 已选中的资源
    var selectedList: [PHAsset] = []

    /// 相册列表视图
    var albumListView: BPSystemAlbumListView?
    /// 照片列表
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
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
        self.customNavigationBar?.backgroundColor = .white
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(BPMediaCell.classForCoder(), forCellWithReuseIdentifier: self.kBPPhotoAlbumCellID)
        // 点击相册名可更换其他相册
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.showAlbumList))
        self.customNavigationBar?.titleLabel.isUserInteractionEnabled = true
        self.customNavigationBar?.titleLabel.addGestureRecognizer(tapAction)
    }

    override func bindData() {
        super.bindData()
        self.setAlbum()
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

    // MARK: ==== Tools ====
    private func setAlbum() {
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

    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albumModel?.assets.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBPPhotoAlbumCellID, for: indexPath) as? BPMediaCell, let asset = self.albumModel?.assets[indexPath.row] else {
            return UICollectionViewCell()
        }
        let selected = self.selectedList.contains(asset)
        cell.setData(asset: asset, showSelect: true, isSelected: selected)
        cell.delegate = self
        return cell
    }

    // MARK: ==== BPPhotoAlbumCellDelegate ====
    func selectedImage(model: Any) {
        guard let _model = model as? PHAsset, !self.selectedList.contains(_model) else { return }
        self.selectedList.append(_model)
        self.collectionView.reloadData()
    }

    func unselectImage(model: Any) {
        guard let _model = model as? PHAsset, let index = self.selectedList.firstIndex(of: _model) else { return }
        self.selectedList.remove(at: index)
        self.collectionView.reloadData()
    }

    // MARK: ==== BPSystemAlbumListViewDelegate ====
    func selectedAlbum(model: BPPhotoAlbumModel) {
        self.albumModel = model
        self.collectionView.reloadData()
    }
}
