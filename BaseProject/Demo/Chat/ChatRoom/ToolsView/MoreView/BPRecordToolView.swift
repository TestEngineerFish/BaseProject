//
//  BPRecordToolView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/22.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPRecordToolView: BPView {
    private var timeLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.orange1
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()

    private var tipsLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()

    private var deleteButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.close.rawValue, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(15))
        button.backgroundColor  = UIColor.gray1
        return button
    }()

    private var comitButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.select.rawValue, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(15))
        button.backgroundColor  = UIColor.gray1
        return button
    }()


}
