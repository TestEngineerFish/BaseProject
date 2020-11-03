//
//  BPImageBrowser.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/1.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

class BPImageBrowser: BPView, UICollectionViewDelegate, UICollectionViewDataSource, BPImageBrowserCellDelegate {

    let kBPImageBrowserCellID = "kBPImageBrowserCell"
    var imageModelList: [BPImageModel]
    var currentIndex: Int

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = kWindow.size
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.isPagingEnabled = true
        collectionView.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleWidth, .flexibleHeight)
        return collectionView
    }()

    init(dataSource: [BPImageModel], current index: Int) {
        self.imageModelList = dataSource
        self.currentIndex = index
        super.init(frame: .zero)
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
        // 添加长按事件
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPressAction(sender:)))
        self.addGestureRecognizer(longPress)
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(BPImageBrowserCell.classForCoder(), forCellWithReuseIdentifier: kBPImageBrowserCellID)
        self.scrollToCurrentPage()
    }

    override func bindData() {
        super.bindData()
    }

    // MARK: ==== Event ====

    func show() {
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleHeight, .flexibleWidth)
    }

    @objc private func hide() {
        self.removeFromSuperview()
    }

    /// 长按手势事件
    @objc private func handleLongPressAction(sender: UILongPressGestureRecognizer) {

    }

    // MARK: ==== Tools ====
    private func scrollToCurrentPage() {
        let offsetY = kWindow.width * CGFloat(self.currentIndex)
        self.collectionView.setContentOffset(CGPoint(x: 0, y: offsetY), animated: false)
    }

    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageModelList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBPImageBrowserCellID, for: indexPath) as? BPImageBrowserCell else {
            return UICollectionViewCell()
        }
        cell.scrollView.zoomScale = 1
        cell.delegate = self
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }

    // MARK: ==== BPImageBrowserCellDelegate ====
    func clickAction() {
        self.hide()
    }

    func longPressAction() {
        BPAlertManager.share.showZeroButton(title: "提示", description: "长按生效")
    }
}
