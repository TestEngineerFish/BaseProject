//
//  BPImageReviewView.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/23.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPImageScrollView: BPView, UIScrollViewDelegate {
    
    var currentIndex: Int
    var imageModelDict = [Int:BPImageScrollModel]()
    var previousImageView = UIImageView()
    var currentImageView  = UIImageView()
    var nextImageView     = UIImageView()

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = .black
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator   = false
        return scrollView
    }()
   
    init(modelDict: [Int:BPImageScrollModel], current index: Int) {
        self.currentIndex = index
        super.init(frame: .zero)
        self.imageModelDict = modelDict
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(scrollView)
        scrollView.addSubview(previousImageView)
        scrollView.addSubview(currentImageView)
        scrollView.addSubview(nextImageView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        previousImageView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.size.equalTo(CGSize(width: kScreenWidth, height: kScreenHeight))
        }
        currentImageView.snp.makeConstraints { (make) in
            make.left.equalTo(previousImageView.snp.right)
            make.top.size.equalTo(previousImageView)
        }
        nextImageView.snp.makeConstraints { (make) in
            make.left.equalTo(currentImageView.snp.right)
            make.right.equalToSuperview()
            make.top.size.equalTo(previousImageView)
        }
        scrollView.contentSize = CGSize(width: kScreenWidth * 3, height: kScreenHeight)
    }

    override func bindProperty() {
        super.bindProperty()
        self.scrollView.delegate = self
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.hide))
        self.addGestureRecognizer(tapAction)
    }

    override func bindData() {
        super.bindData()
        let previousImageModel = self.imageModelDict[self.currentIndex - 1]
        let currentImageModel  = self.imageModelDict[self.currentIndex]
        let nextImageModel     = self.imageModelDict[self.currentIndex + 1]
        self.previousImageView.image = previousImageModel?.thumImage
        self.currentImageView.image  = currentImageModel?.thumImage
        self.nextImageView.image     = nextImageModel?.thumImage
    }
    
    func show() {
        
    }

    // MARK: ==== Event ====
    @objc
    private func hide() {
        self.removeFromSuperview()
    }
    
    // MARK: ==== Tools ====
    
    /// 获取上一张图片对象
    /// - Returns: 图片对象模型
    private func getPreviousImageModel() -> BPImageScrollModel? {
        return self.imageModelDict[self.currentIndex - 1]
    }
    
    /// 获取下一张图片对象
    /// - Returns: 图片对象模型
    private func getNextImageModel() -> BPImageScrollModel? {
        return self.imageModelDict[self.currentIndex + 1]
    }

    // MARK: ==== UIScrollViewDelegate ====
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

    }
    
}
