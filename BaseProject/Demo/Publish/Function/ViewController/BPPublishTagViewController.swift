//
//  BPPublishTagViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/26.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPublishTagViewController: BPViewController, UICollectionViewDelegate, UICollectionViewDataSource, BPPublishTagCellDelegate, BPPublishTagHeaderViewDelegate {

    private let cellID: String = "kBPPublishTagCell"
    private let headID: String = "kBPCollectionHeader"
    private var selectedTagModelList = [BPTagModel]()
    private var unSelectTagModelList = [BPTagModel]()
    var setTagBlock:(([BPTagModel])->Void)?

    private var collectionView: UICollectionView = {
        let layout = BPCollectionViewFlowLayout(type: .left)
        layout.estimatedItemSize       = CGSize(width: AdaptSize(50), height: AdaptSize(15))
        layout.minimumInteritemSpacing = AdaptSize(15)
        layout.minimumLineSpacing      = AdaptSize(10)
        layout.headerReferenceSize     = CGSize(width: kScreenWidth, height: AdaptSize(36))
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.setCustomNavigation()
        self.bindData()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.collectionView.delegate       = self
        self.collectionView.dataSource     = self
        self.collectionView.register(BPPublishTagHeaderView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headID)
        self.collectionView.register(BPPublishTagCell.classForCoder(), forCellWithReuseIdentifier: cellID)
    }

    override func bindData() {
        super.bindData()
        self.unSelectTagModelList.removeAll()
        // 添加测试数据
        for index in 0..<10 {
            var tagModel = BPTagModel()
            tagModel.id   = index
            tagModel.name = "标签\(index)"
            self.unSelectTagModelList.append(tagModel)
        }
        self.collectionView.reloadData()
    }

    private func setCustomNavigation() {
        self.customNavigationBar?.title = "添加标签"
        self.customNavigationBar?.leftButton.setTitle(IconFont.close1.rawValue, for: .normal)
        self.customNavigationBar?.leftButton.titleLabel?.font = UIFont.iconFont(size: 15)
        self.customNavigationBar?.leftButton.left  = AdaptSize(15)
        self.customNavigationBar?.leftButtonAction = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
        self.customNavigationBar?.rightButtonTitle = "完成"
        self.customNavigationBar?.rightFirstButton.titleLabel?.font = UIFont.regularFont(ofSize: 15)
        self.customNavigationBar?.rightFirstButton.right = AdaptSize(15)
        self.customNavigationBar?.rightFirstButtonAction = { [weak self] in
            guard let self = self else { return }
            self.setTagBlock?(self.selectedTagModelList)
            self.dismiss(animated: true, completion: nil)
        }
        
        let lineView: BPView = {
            let view = BPView()
            view.backgroundColor = UIColor.gray3
            view.layer.cornerRadius = AdaptSize(2)
            return view
        }()
        self.customNavigationBar?.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(15))
            make.size.equalTo(CGSize(width: AdaptSize(45), height: AdaptSize(4)))
            make.centerX.equalToSuperview()
        }
    }

    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource && UICollectionViewDelegateFlowLayout ====

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? selectedTagModelList.count : unSelectTagModelList.count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headID, for: indexPath) as? BPPublishTagHeaderView else {
            return UICollectionReusableView()
        }
        cell.delegate = self
        cell.setData(isSelected: indexPath.section == 0)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? BPPublishTagCell else {
            return UICollectionViewCell()
        }
        var tagModel: BPTagModel?
        if indexPath.section == 0 {
            tagModel = self.selectedTagModelList[indexPath.row]
        } else {
            tagModel = self.unSelectTagModelList[indexPath.row]
        }
        cell.delegate = self
        cell.setData(tag: tagModel, indexPath: indexPath)
        return cell
    }

    // MARK: ==== BPPublishTagCellDelegate ====
    func clickTagButton(tag model: BPTagModel, indexPath: IndexPath) {
        if indexPath.section == 0 {
            self.selectedTagModelList.remove(at: indexPath.row)
            self.unSelectTagModelList.append(model)
            self.collectionView.reloadData()
        } else {
            self.unSelectTagModelList.remove(at: indexPath.row)
            self.selectedTagModelList.append(model)
            self.collectionView.reloadData()
        }
    }

    // MARK: ==== BPPublishTagHeaderViewDelegate ====
    func refreshAction() {
        BPLog("换一换")
        self.bindData()
    }
}
