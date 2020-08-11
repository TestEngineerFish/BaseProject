//
//  TableView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

protocol TableViewProtocol {
    func restart()
    func start()
}

class BaseTableView: BPView, TableViewProtocol {
    var type: AlgorithmType
    var barList = [BarView]()
    var index   = 0
    var offset  = 0

    var normalColor      = UIColor.blue1
    var willSelectColor  = UIColor.orange1.withAlphaComponent(0.4)
    var didSelectedColor = UIColor.orange1

    init(type: AlgorithmType, frame: CGRect) {
        self.type = type
        let frame: CGRect = {
            let _width = kScreenWidth - AdaptSize(30)
            let _height = type.isDouble() ? AdaptSize(400) : AdaptSize(200)
            return CGRect(origin: .zero, size: CGSize(width: _width, height: _height))
        }()
        super.init(frame: frame)
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData() {
        let isRandom   = BPCacheManager.object(forKey: .randomData) as? Bool ?? false
        let numberList = AlgorithmModelManager.share.numberList(random: isRandom)
        let barWidth   = self.size.width / CGFloat(numberList.count * 2)
        let barHeight  = self.type.isDouble() ? self.size.height / 2 : self.size.height
        var offsetX    = barWidth / 2
        for number in numberList {
            let barView = BarView(number: number)
            self.addSubview(barView)
            barView.frame = CGRect(x: offsetX, y: 0, width: barWidth, height: barHeight)
            offsetX += barWidth * 2
            self.barList.append(barView)
        }
    }

    func sort() {}

    /// 交换两个视图的位置
    /// - Parameters:
    ///   - leftBar: 左侧的视图
    ///   - rightBar: 右侧的视图
    ///   - block: 交换后的回调
    internal func exchangeFrame(leftBar: BarView, rightBar: BarView, finished block: (()->Void)?) {
        
        let leftBarFrame = leftBar.frame
        UIView.animate(withDuration: 0.5, animations: {
            leftBar.frame = rightBar.frame
            rightBar.frame = leftBarFrame
        }) { (completed) in
            if completed {
                // 交换数组中对象的位置
                let leftIndex  = self.barList.firstIndex(of: leftBar) ?? 0
                let rightIndex = self.barList.firstIndex(of: rightBar) ?? 0
                self.barList.swapAt(leftIndex, rightIndex)
                block?()
            }
        }
    }

    // MARK: ==== Tools ====
    internal func resetData() {
        self.barList.removeAll()
        self.removeAllSubviews()
        self.index    = 0
        self.offset   = 0
    }
    
    // MARK: ==== TableViewProtocol ====
    func restart() {
        self.resetData()
        self.setData()
    }
    
    func start() {
        self.sort()
    }
}

