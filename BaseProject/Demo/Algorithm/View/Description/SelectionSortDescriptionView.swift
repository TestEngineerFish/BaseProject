//
//  SelectionSortDescriptionView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/24.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class SelectionSortDescriptionView: BaseDescriptionView {
    override func bindProperty() {
        super.bindProperty()
        self.spaceComplexityLabel.text = "O(1)"
        self.setWorstTimeComplexity(content: "O(n^2)")
        self.setAverageTimeComplexity(context: "O(n^2)")
        self.setBestTimeComplexity(context: "O(n^2)")
        self.descriptionLabel.text     = "比较相邻的两个元素，如果第一个比第二大，则交换他们。如此反复，直到不需要交换。"
        self.virtueLabel.text          = "经典！简单！就相当于学代码先学“Hello word”，学算法先学“冒泡排序”"
        self.defectLabel.text          = "效率低！因为是逐个对比，所以数组越长，效率越低！"
    }
}
