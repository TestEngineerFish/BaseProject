//
//  DescriptionFactoryManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/24.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

struct DescriptionFactoryManager {
    static let share = DescriptionFactoryManager()

    func createTableView(type: AlgorithmType, frame rect: CGRect) -> BaseDescriptionView {
        switch type {
            case .bubbleSort:
                return BubbleSortDescriptionView(type: type, frame: rect)
            case .chooseSort:
                return SelectionSortDescriptionView(type: type, frame: rect)
            case .insertionSort:
                return InsertionSortDescriptionView(type: type, frame: rect)
            case .shellSort:
                return ShellSortDescription(type: type, frame: rect)
        }
    }
}
