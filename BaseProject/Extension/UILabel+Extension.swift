//
//  UILabel+Extension.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/22.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

extension UILabel {
    /// 根据字体和画布宽度,计算文字在画布上的高度
    /// - parameter font: 字体
    /// - parameter width: 限制的宽度
    func textHeight(width: CGFloat) -> CGFloat {
        guard let _text = self.text, let _font = self.font else { return .zero}
        let rect = NSString(string: _text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: _font], context: nil)
        return ceil(rect.height)
    }
}
