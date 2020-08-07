//
//  BarView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/7.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

class BarView: BPView {

    let number: CGFloat
    let maxHeight = CGFloat(10)
    var numberLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(10))
        label.textAlignment = .center
        return label
    }()

    var barView: UIView = {
        let view = UIView()
        return view
    }()

    init(number: CGFloat) {
        self.number = number
        super.init(frame: .zero)
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
            make.height.equalToSuperview().multipliedBy(number/(maxHeight + 1))
        }
        numberLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(barView.snp.top).offset(AdaptSize(-2))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.barView.backgroundColor = UIColor.randomColor()
        let numberStr = String(format: "%0.1f", number)
        self.numberLabel.text        = numberStr
    }

}
