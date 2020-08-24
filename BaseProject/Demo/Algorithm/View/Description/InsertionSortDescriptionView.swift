//
//  InsertionSortDescriptionView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/24.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class InsertionSortDescriptionView: BaseDescriptionView {
    override func bindProperty() {
        super.bindProperty()
        self.setWorstTimeComplexity(content: "O(n^2)")
        self.setAverageTimeComplexity(context: "O(n^2)")
        self.setBestTimeComplexity(context: "O(n)")
        self.spaceComplexityLabel.text = "O(1)"
        self.descriptionLabel.text     = "从当前位置向前逐个比较，如果小于比较的值，则插入到前方，如此逐个往后执行，直到数组末尾。"
        self.virtueLabel.text          = "相比较选择和冒泡，插入排序可以提前终止，不用执行到最后。因此效率稍微高些。"
        self.defectLabel.text          = "记得使用下标的方式对数组进行插入操作，而不是比较后交换两者的方式来排序，因为对于数组来说，插入的方式更加快，交换方式包含了三次的赋值操作（）"
    }
}
