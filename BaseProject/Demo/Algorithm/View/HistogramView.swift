//
//  HistogramView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

class BarView: BPView {

    var numberLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(11))
        label.textAlignment = .center
        return label
    }()

    var barView: UIView = {
        let view = UIView()
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        self.addSubview(barView)
        self.addSubview(numberLabel)
        self.barView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(numberLabel.snp.bottom).offset(AdaptSize(2))
        }
        numberLabel.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(AdaptSize(12))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.barView.backgroundColor = UIColor.randomColor()
    }

}
