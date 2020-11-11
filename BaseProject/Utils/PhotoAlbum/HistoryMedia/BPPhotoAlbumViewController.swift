//
//  BPPhotoAlbumViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/4.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPhotoAlbumViewController: BPViewController, UICollectionViewDelegate, UICollectionViewDataSource, BPPhotoAlbumToolsDelegate, BPPhotoAlbumCellDelegate {

    var isSelect: Bool = false {
        willSet {
            if newValue {
                self.customNavigationBar?.rightFirstButton.setTitle("取消", for: .normal)
                self.showToolsView()
            } else {
                self.customNavigationBar?.rightFirstButton.setTitle("选择", for: .normal)
                self.hideToolsView()
            }
            self.selectedList.removeAll()
            self.collectionView.reloadData()
        }
    }

    let kBPPhotoAlbumCellID = "kBPPhotoAlbumCell"
    /// 总资源
    var modelList: [BPMediaModel] = []
    /// 已选资源
    var selectedList: [BPMediaModel] = []

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
        self.view.addSubview(toolsView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
        toolsView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kScreenHeight)
            make.height.equalTo(AdaptSize(50) + kSafeBottomMargin)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title            = "图片和视频"
        self.customNavigationBar?.rightButtonTitle = "选择"
        self.customNavigationBar?.rightFirstButtonAction = { [weak self] in
            guard let self = self else { return }
            self.isSelect = !self.isSelect
            BPLog("开始选择")
        }
        self.toolsView.delegate        = self
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(BPMediaCell.classForCoder(), forCellWithReuseIdentifier: self.kBPPhotoAlbumCellID)
    }

    // MARK: ==== Event ====
    private func showToolsView() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.toolsView.transform = CGAffineTransform(translationX: 0, y: -self.toolsView.height)
        }
    }

    private func hideToolsView() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.toolsView.transform = .identity
        }
    }

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
        return self.modelList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBPPhotoAlbumCellID, for: indexPath) as? BPMediaCell else {
            return UICollectionViewCell()
        }
        let model     = self.modelList[indexPath.row]
        let selected  = self.selectedList.contains(model)
        cell.delegate = self
        cell.setData(model: model, showSelect: self.isSelect, isSelected: selected)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? BPMediaCell else {
            return
        }
        BPImageBrowser(dataSource: modelList, current: indexPath.row).show(animationView: cell.imageView)
    }

    // MARK: ==== BPPhotoAlbumCellDelegate ====
    func selectedImage(model: Any) {
        guard let _model = model as? BPMediaModel, !self.selectedList.contains(_model) else { return }
        self.selectedList.append(_model)
        self.collectionView.reloadData()
    }

    func unselectImage(model: Any) {
        guard let _model = model as? BPMediaModel, let index = self.selectedList.firstIndex(of: _model) else { return }
        self.selectedList.remove(at: index)
        self.collectionView.reloadData()
    }
}
