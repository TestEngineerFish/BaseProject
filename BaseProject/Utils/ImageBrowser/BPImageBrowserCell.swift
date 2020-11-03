//
//  BPImageBrowserCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/2.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

protocol BPImageBrowserCellDelegate: NSObjectProtocol {
    func clickAction()
    func longPressAction()
}

class BPImageBrowserCell: UICollectionViewCell, UIScrollViewDelegate {

    var delegate: BPImageBrowserCellDelegate?

    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 1
        return scrollView
    }()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dog")
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.addSubview(scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(self)
        }
        scrollView.contentSize = kWindow.size
    }

    private func bindProperty() {
//        self.imageView.isUserInteractionEnabled = true
        self.scrollView.delegate = self
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction))
        self.addGestureRecognizer(tapGes)
        self.addGestureRecognizer(longPressGes)
    }

    // MARK: ==== Event ====
    /// 点击手势事件
    @objc private func tapAction() {
        self.delegate?.clickAction()
    }

    /// 长按手势事件
    @objc private func longPressAction() {
        self.delegate?.longPressAction()
    }


    // MARK: ==== UIScrollViewDelegate ====
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
