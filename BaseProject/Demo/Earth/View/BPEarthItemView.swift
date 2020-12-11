//
//  BPEarthItemView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

class BPEarthItemView: BPView {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.white
        label.font          = UIFont.regularFont(ofSize: AdaptSize(12))
        label.textAlignment = .center
        return label
    }()

    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.titleLabel.text = title
        self.backgroundColor = .randomColor()
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
