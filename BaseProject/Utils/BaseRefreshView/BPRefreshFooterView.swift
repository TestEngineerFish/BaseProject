//
//  BPRefreshFooterView.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/20.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPRefreshFooterView: BPView {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor     = .orange1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .red
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
    
    func setStatus(status: BPRefreshStatus) {
        switch status {
        case .footerPulling:
            self.titleLabel.text = "上拉加载更多"
        case .footerPullMax:
            self.titleLabel.text = "松手开始加载"
        case .footerLoading:
            self.titleLabel.text = "加载中～"
        default:
            self.titleLabel.text = ""
            return
        }
    }
}
