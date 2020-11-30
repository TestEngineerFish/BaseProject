//
//  BPPublishImageListView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/27.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPublishImageListView: BPView {

    private var imageViewList = [BPView]()
    private var itemSize      = CGFloat.zero
    private let space         = AdaptSize(10)

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
    }

    override func bindProperty() {
        super.bindProperty()
        self.itemSize = (kScreenWidth - AdaptSize(20)) / 4 - space
    }

    // MARK: ==== Event ====
    func addImage() {
        guard imageViewList.count < 4 else {
            return
        }
        let imageView: BPView = {
            let view = BPView()
            view.backgroundColor = UIColor.randomColor()
            let offsetX = (itemSize + space) * CGFloat(imageViewList.count)
            view.frame  = CGRect(x: offsetX, y: 0, width: itemSize, height: itemSize)
            return view
        }()
        self.addSubview(imageView)
        self.imageViewList.append(imageView)
        // 首次添加
        if self.imageViewList.isEmpty {
            let addView: BPView = {
                let view = BPView()
                view.backgroundColor = UIColor.gray0
                view.frame = CGRect(x: imageView.right + space, y: 0, width: itemSize, height: itemSize)
                return view
            }()
            self.addSubview(addView)
            self.imageViewList.append(addView)
        } else {
            
        }

    }
}
