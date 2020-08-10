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

    let restartButton: BPBaseButton = {
        let button = BPBaseButton(.theme, frame: .zero)
        button.setTitle("重置", for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(16))
        return button
    }()
    var switchLabel: UILabel = {
        let label = UILabel()
        label.text          = "随机："
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.textAlignment = .center
        return label
    }()
    let switchView: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = false
        return switchView
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
        self.backgroundColor = .white
        self.addSubview(startButton)
        self.addSubview(restartButton)
        self.addSubview(switchLabel)
        self.addSubview(switchView)
        startButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(50)))
        }
        restartButton.snp.makeConstraints { (make) in
            make.left.equalTo(startButton.snp.right).offset(AdaptSize(15))
            make.centerY.equalTo(startButton)
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(50)))
        }
        switchLabel.snp.makeConstraints { (make) in
            make.left.equalTo(restartButton.snp.right).offset(AdaptSize(15))
            make.centerY.equalTo(startButton)
            make.size.equalTo(CGSize(width: AdaptSize(50), height: 20))
        }
        switchView.snp.makeConstraints { (make) in
            make.left.equalTo(switchLabel.snp.right)
            make.centerY.equalTo(startButton)
            make.size.equalTo(CGSize(width: AdaptSize(50), height: 30))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.startButton.addTarget(self, action: #selector(startSort), for: .touchUpInside)
        self.restartButton.addTarget(self, action: #selector(restart), for: .touchUpInside)
        self.switchView.addTarget(self, action: #selector(switchChange), for: .valueChanged)
    }
    
    // MARK: ==== Event ====
    @objc
    private func startSort() {
        self.delegate?.start()
    }
    @objc
    private func restart() {
        self.delegate?.restart()
    }
    @objc
    private func switchChange() {
        let isOn = self.switchView.isOn
        BPCacheManager.set(isOn, forKey: .randomData)
    }
}
