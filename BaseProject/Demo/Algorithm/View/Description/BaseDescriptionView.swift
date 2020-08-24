//
//  BaseDescriptionView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/8/9.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BaseDescriptionView: BPView {
    let type: AlgorithmType
    var delegate: TableViewProtocol?

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator   = false
        return scrollView
    }()
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    var timeComplexityTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "时间复杂度："
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        return label
    }()
    var timeComplexityLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var spaceComplexityTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "空间复杂度："
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        return label
    }()
    var spaceComplexityLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    /// 通俗描述
    var descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "描述："
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        return label
    }()
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    /// 优点
    var virtueTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "优点："
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        return label
    }()
    var virtueLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    /// 缺点
    var defectTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "缺点："
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        return label
    }()
    var defectLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.gray1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

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
    
    init(type: AlgorithmType, frame: CGRect) {
        self.type = type
        super.init(frame: frame)
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
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(timeComplexityTitleLabel)
        contentView.addSubview(timeComplexityLabel)
        contentView.addSubview(spaceComplexityTitleLabel)
        contentView.addSubview(spaceComplexityLabel)
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(virtueTitleLabel)
        contentView.addSubview(defectTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(virtueLabel)
        contentView.addSubview(defectLabel)

        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).offset(AdaptSize(-15))
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        timeComplexityTitleLabel.sizeToFit()
        timeComplexityTitleLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(AdaptSize(30))
            make.width.equalTo(timeComplexityTitleLabel.width)
        }
        timeComplexityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeComplexityTitleLabel)
            make.left.equalTo(timeComplexityTitleLabel.snp.right)
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        spaceComplexityTitleLabel.sizeToFit()
        spaceComplexityTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeComplexityTitleLabel)
            make.top.equalTo(timeComplexityTitleLabel.snp.bottom).offset(AdaptSize(5))
            make.width.equalTo(spaceComplexityTitleLabel.width)
        }
        spaceComplexityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(spaceComplexityTitleLabel.snp.right)
            make.top.equalTo(spaceComplexityTitleLabel)
            make.right.equalTo(timeComplexityLabel)
        }
        descriptionTitleLabel.sizeToFit()
        descriptionTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeComplexityTitleLabel)
            make.top.equalTo(spaceComplexityLabel.snp.bottom).offset(AdaptSize(30))
            make.width.equalTo(descriptionTitleLabel.width)
        }
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTitleLabel)
            make.left.equalTo(descriptionTitleLabel.snp.right)
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        virtueTitleLabel.sizeToFit()
        virtueTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeComplexityTitleLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(AdaptSize(10))
            make.width.equalTo(virtueTitleLabel.width)
        }
        virtueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(virtueTitleLabel)
            make.left.right.equalTo(descriptionLabel)
        }
        defectTitleLabel.sizeToFit()
        defectTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(timeComplexityTitleLabel)
            make.top.equalTo(virtueLabel.snp.bottom).offset(AdaptSize(10))
            make.width.equalTo(defectTitleLabel.width)
        }
        defectLabel.snp.makeConstraints { (make) in
            make.top.equalTo(defectTitleLabel)
            make.left.right.equalTo(descriptionLabel)
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
        }
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
        self.switchView.isOn = BPCacheManager.object(forKey: .randomData) as? Bool ?? false
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

