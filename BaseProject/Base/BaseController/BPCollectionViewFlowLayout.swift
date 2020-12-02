//
//  BPCollectionViewFlowLayout.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/12/2.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

enum BPCollectionViewFlowType: Int {
    case left
    case center
    case right
}

class BPCollectionViewFlowLayout: UICollectionViewFlowLayout {
    var flowType: BPCollectionViewFlowType = .center
    var sumCellWidth = CGFloat.zero

    init(type: BPCollectionViewFlowType) {
        super.init()
        self.flowType = type
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        var layoutAttributesTmp = [UICollectionViewLayoutAttributes]()

        for index in 0..<layoutAttributes.count {
            let currentAttr  = layoutAttributes[index]
            let previousAttr = index == 0 ? nil : layoutAttributes[index - 1]
            let nextAttr     = (index < layoutAttributes.count - 1) ? layoutAttributes[index + 1] : nil

            layoutAttributesTmp.append(currentAttr)
            sumCellWidth += currentAttr.frame.width

            let previousY = previousAttr?.frame.maxX ?? 0
            let currentY  = currentAttr.frame.maxY
            let nextY     = nextAttr?.frame.maxY ?? 0

            if currentY != previousY && currentY != nextY {
                if currentAttr.representedElementKind == UICollectionView.elementKindSectionHeader || currentAttr.representedElementKind == UICollectionView.elementKindSectionFooter {
                    layoutAttributesTmp.removeAll()
                    sumCellWidth = .zero
                } else {
                    self.setCellFrame(layout: layoutAttributesTmp)
                    layoutAttributesTmp.removeAll()
                    sumCellWidth = .zero
                }
            } else if currentY != nextY {
                self.setCellFrame(layout: layoutAttributesTmp)
                layoutAttributesTmp.removeAll()
                sumCellWidth = .zero
            }
        }
        return layoutAttributes
    }

    private func setCellFrame(layout attributes: [UICollectionViewLayoutAttributes]) {
        var newWidth = CGFloat.zero
        switch flowType {
        case .left:
            newWidth = self.sectionInset.left
            for attribute in attributes {
                var newFrame = attribute.frame
                newFrame.origin.x = newWidth
                attribute.frame   = newFrame
                newWidth         += newFrame.width + self.minimumInteritemSpacing
            }
        case .center:
            newWidth = ((self.collectionView?.width ?? 0) - sumCellWidth - (CGFloat(attributes.count - 1) * self.minimumInteritemSpacing))/2
            for attribute in attributes {
                var newFrame = attribute.frame
                newFrame.origin.x = newWidth
                attribute.frame   = newFrame
                newWidth         += newFrame.width + self.minimumInteritemSpacing
            }
        case .right:
            newWidth = (self.collectionView?.width ?? 0) - self.sectionInset.right
            let _attributes = attributes.reversed()
            for attrbute in _attributes {
                var newFrame  = attrbute.frame
                newFrame.origin.x = newWidth - newFrame.width
                attrbute.frame    = newFrame
                newWidth          = newWidth - newFrame.width - self.minimumInteritemSpacing
            }
        }
    }
}
