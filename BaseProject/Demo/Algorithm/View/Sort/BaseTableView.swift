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
    var barList   = [BarView]()
    var offset    = 0
    var skipCount = 0

    init(type: AlgorithmType, frame: CGRect) {
        self.type = type
        super.init(frame: frame)
        self.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(numberList: [CGFloat]) {
        let barWidth  = self.size.width / CGFloat(numberList.count * 2)
        var offsetX   = barWidth / 2
        for number in numberList {
            let barView = BarView(number: number)
            self.addSubview(barView)
            barView.frame = CGRect(x: offsetX, y: 0, width: barWidth, height: self.size.height)
            offsetX += barWidth * 2
            self.barList.append(barView)
        }
    }

    func sort() {}

    internal func exchangeFrame(leftBar: BarView, rightBar: BarView, finished block: (()->Void)?) {
        
        let leftBarFrame = leftBar.frame

        UIView.animate(withDuration: 0.25, animations: {
            leftBar.frame = rightBar.frame
            rightBar.frame = leftBarFrame
        }) { (completed) in
            if completed {
                let leftIndex  = self.barList.firstIndex(of: leftBar) ?? 0
                let rightIndex = self.barList.firstIndex(of: rightBar) ?? 0
                self.barList.swapAt(leftIndex, rightIndex)
                block?()
            }
        }
    }
    
    // MARK: ==== TableViewProtocol ====
    func restart() {
        
    }
    
    func start() {
        self.sort()
    }
}

