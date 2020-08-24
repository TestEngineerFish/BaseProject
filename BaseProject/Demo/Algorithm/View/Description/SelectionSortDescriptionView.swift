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
        self.setWorstTimeComplexity(content: "O(n^2)")
        self.setAverageTimeComplexity(context: "O(n^2)")
        self.setBestTimeComplexity(context: "O(n)")
        self.spaceComplexityLabel.text = "O(1)"
        self.descriptionLabel.text     = "从下标0开始往后找最小的值，找到后移动到下标位置，下标+1，继续往后查找，往复如此，直到下标等于数组长度"
        self.virtueLabel.text          = "不占用额外的内存空间"
        self.defectLabel.text          = "效率低！因为是逐个对比，所以数组越长，效率越低！"
    }
}
