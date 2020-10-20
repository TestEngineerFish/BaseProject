//
//  BPRefreshHeaderView.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/20.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPRefreshHeaderView: BPView {
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
        case .headerPulling:
            self.titleLabel.text = "下拉刷新"
        case .headerPullMax:
            self.titleLabel.text = "松手开始刷新"
        case .headerLoading:
            self.titleLabel.text = "刷新中～"
        default:
            return
        }
    }
}
