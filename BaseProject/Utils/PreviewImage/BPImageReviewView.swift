//
//  BPImageReviewView.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/23.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPImageReviewView: BPView {
    
    var currentIndex: Int
    var imageModelDict = [Int:BPImageReviewModel]()
   
    init(modelDict: [Int:BPImageReviewModel], current index: Int) {
        self.currentIndex = index
        super.init(frame: .zero)
        self.imageModelDict = modelDict
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show() {
        
    }
    
    // MARK: ==== Tools ====
    
    /// 获取上一张图片对象
    /// - Returns: 图片对象模型
    private func getPreviousImageModel() -> BPImageReviewModel? {
        return self.imageModelDict[self.currentIndex - 1]
    }
    
    /// 获取下一张图片对象
    /// - Returns: 图片对象模型
    private func getNextImageModel() -> BPImageReviewModel? {
        return self.imageModelDict[self.currentIndex + 1]
    }
    
}
