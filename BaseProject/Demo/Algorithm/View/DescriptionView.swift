//
//  DescriptionView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/9.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class DescriptionView: BPView {
    let type: AlgorithmType
    var delegate: TableViewProtocol?
    
    let startButton: BPBaseButton = {
        let button = BPBaseButton(.theme, frame: .zero)
        button.setTitle("开始", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(16))
        return button
    }()
    
    init(type: AlgorithmType) {
        self.type = type
        super.init(frame: .zero)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.backgroundColor = .green
        self.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(50)))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.startButton.addTarget(self, action: #selector(startSort), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    @objc
    private func startSort() {
        self.delegate?.start()
    }
}
