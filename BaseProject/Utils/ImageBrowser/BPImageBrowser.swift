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
    var imageModelList: [BPMediaModel]
    var currentIndex: Int
    var startFrame: CGRect?

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize           = kWindow.size
        layout.scrollDirection    = .horizontal
        layout.minimumLineSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.isPagingEnabled  = true
        collectionView.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleWidth, .flexibleHeight)
        collectionView.backgroundColor  = .clear
        return collectionView
    }()

    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()

    private var albumButton: BPButton = {
        let button = BPButton()
        button.setTitle("全部", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(14))
        button.backgroundColor  = UIColor.gray1
        button.layer.cornerRadius = AdaptSize(5)
        return button
    }()

    init(dataSource: [BPMediaModel], current index: Int) {
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
        self.addSubview(backgroundView)
        self.addSubview(collectionView)
        self.addSubview(albumButton)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        albumButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(40))
            make.right.equalToSuperview().offset(-AdaptSize(20))
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(25)))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .clear
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(BPImageBrowserCell.classForCoder(), forCellWithReuseIdentifier: kBPImageBrowserCellID)
        self.collectionView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.scrollToCurrentPage()
        }
        self.albumButton.addTarget(self, action: #selector(self.showAlubmVC), for: .touchUpInside)
    }

    // MARK: ==== Animation ====
    private func showAnimation(startView: UIImageView) {
        self.startFrame = startView.convert(startView.bounds, to: kWindow)
        let imageView = UIImageView()
        imageView.frame       = startFrame!
        imageView.image       = startView.image
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        self.collectionView.isHidden = true
        UIView.animate(withDuration: 0.25) {
            imageView.frame = CGRect(origin: .zero, size: kWindow.size)
        } completion: { [weak self] (finished) in
            if (finished) {
                imageView.removeFromSuperview()
                self?.collectionView.isHidden = false
            }
        }
    }

    private func hideAnimation(currentView: UIImageView) {
        guard let startFrame = self.startFrame else {
            self.hide()
            return
        }
        let imageView = UIImageView()
        imageView.frame       = currentView.frame
        imageView.image       = currentView.image
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        self.collectionView.isHidden = true
        UIView.animate(withDuration: 0.25) { [weak self] in
            imageView.frame = startFrame
            self?.backgroundView.layer.opacity = 0.0
        } completion: { [weak self] (finished) in
            guard let self = self else { return }
            if (finished) {
                imageView.removeFromSuperview()
                self.layer.opacity = 0.0
                self.hide()
            }
        }
    }

    // MARK: ==== Event ====

    /// 显示入场动画
    /// - Parameter animationView: 动画参考对象
    func show(animationView: UIImageView?) {
        UIViewController.currentViewController?.view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleHeight, .flexibleWidth)
        guard let imageView = animationView else {
            return
        }
        // 显示进入动画
        self.showAnimation(startView: imageView)
    }

    @objc private func hide() {
        self.removeFromSuperview()
    }

    @objc private func showAlubmVC() {
        let vc = BPPhotoAlbumViewController()
        vc.modelList = self.imageModelList
        UIViewController.currentNavigationController?.pushViewController(vc, animated: true)
    }

    // MARK: ==== Tools ====
    private func scrollToCurrentPage() {
        let offsetX = kWindow.width * CGFloat(self.currentIndex)
        self.collectionView.contentOffset = CGPoint(x: offsetX, y: 0)
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
        cell.setData(model: self.imageModelList[indexPath.row])
        return cell
    }

    // 滑动结束通知Cell
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: BPNotificationName.kScrollDidEndDecelerating, object: nil)
    }

    // MARK: ==== BPImageBrowserCellDelegate ====
    func clickAction(imageView: UIImageView) {
        if self.startFrame != nil {
            self.hideAnimation(currentView: imageView)
        } else {
            self.hide()
        }
    }

    func longPressAction() {
        BPActionSheet().addItem(title: "保存") {
            BPAlertManager.share.showZeroButton(title: nil, description: "保存成功")
        }.show()
    }

    func scrolling(reduce scale: Float) {
        self.backgroundView.layer.opacity = scale
    }

    func closeAction(imageView: UIImageView) {
        if self.startFrame != nil {
            self.hideAnimation(currentView: imageView)
        } else {
            self.hide()
        }
    }
}
