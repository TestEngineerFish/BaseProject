//
//  ShellSortDescriptionView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/25.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class ShellSortDescription: BaseDescriptionView {
    override func bindProperty() {
        super.bindProperty()
        self.setWorstTimeComplexity(content: "O(ns)")
        self.setAverageTimeComplexity(context: "O(nLogn)")
        self.setBestTimeComplexity(context: "O(n)")
        self.spaceComplexityLabel.text = "O(1)"
        self.descriptionLabel.text     = ""
        self.virtueLabel.text          = ""
        self.defectLabel.text          = ""
    }
}
