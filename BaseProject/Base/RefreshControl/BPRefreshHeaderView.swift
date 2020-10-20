//
//  BPRefreshHeaderView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPRefreshHeaderView: BPView {
    var title: UILabel = {
        let label = UILabel()
        label.text      = ""
        label.font      = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textColor = UIColor.black1
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(AdaptSize(13))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = UIColor.red
        self.title.text = "下拉刷新"
    }
}
