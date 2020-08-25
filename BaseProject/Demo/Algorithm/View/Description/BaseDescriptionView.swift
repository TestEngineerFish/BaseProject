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
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    var timeComplexityTitleLabel: UILabel = {
        let label = UILabel()
        label.text          = "时间复杂度："
        label.textColor     = UIColor.black1
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(16))
        label.textAlignment = .left
        return label
    }()
    var timeComplexityStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing      = AdaptSize(5)
        stackView.alignment    = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    /// 最坏时间复杂度
    var worstTimeComplexityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    /// 最好时间复杂度
    var bestTimeComplexityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    /// 平均时间复杂度
    var averageTimeComplexityLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
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
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
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
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
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
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
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

    let resetButton: BPBaseButton = {
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
        self.addSubview(resetButton)
        self.addSubview(switchLabel)
        self.addSubview(switchView)
        self.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(spaceComplexityTitleLabel)
        contentView.addSubview(spaceComplexityLabel)
        contentView.addSubview(timeComplexityTitleLabel)
        contentView.addSubview(timeComplexityStackView)
        contentView.addSubview(descriptionTitleLabel)
        contentView.addSubview(virtueTitleLabel)
        contentView.addSubview(defectTitleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(virtueLabel)
        contentView.addSubview(defectLabel)
        timeComplexityStackView.addArrangedSubview(worstTimeComplexityLabel)
        timeComplexityStackView.addArrangedSubview(averageTimeComplexityLabel)
        timeComplexityStackView.addArrangedSubview(bestTimeComplexityLabel)

        scrollView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).offset(AdaptSize(-15))
        }
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        spaceComplexityTitleLabel.sizeToFit()
        spaceComplexityTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.top.equalToSuperview()
            make.width.equalTo(spaceComplexityTitleLabel.width)
        }
        spaceComplexityLabel.snp.makeConstraints { (make) in
            make.top.equalTo(spaceComplexityTitleLabel)
            make.left.equalTo(spaceComplexityTitleLabel.snp.right)
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
        timeComplexityTitleLabel.sizeToFit()
        timeComplexityTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(spaceComplexityTitleLabel)
            make.top.equalTo(spaceComplexityTitleLabel.snp.bottom).offset(AdaptSize(5))
            make.width.equalTo(timeComplexityTitleLabel.width)
        }
        timeComplexityStackView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(30))
            make.right.equalToSuperview().offset(AdaptSize(-30))
            make.top.equalTo(timeComplexityTitleLabel.snp.bottom).offset(AdaptSize(5))
            make.height.equalTo(AdaptSize(20))
        }
        descriptionTitleLabel.sizeToFit()
        descriptionTitleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.top.equalTo(timeComplexityStackView.snp.bottom).offset(AdaptSize(30))
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
        resetButton.snp.makeConstraints { (make) in
            make.left.equalTo(startButton.snp.right).offset(AdaptSize(15))
            make.centerY.equalTo(startButton)
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(50)))
        }
        switchLabel.snp.makeConstraints { (make) in
            make.left.equalTo(resetButton.snp.right).offset(AdaptSize(15))
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
        self.startButton.addTarget(self, action: #selector(self.startSort), for: .touchUpInside)
        self.resetButton.addTarget(self, action: #selector(self.reset), for: .touchUpInside)
        self.switchView.addTarget(self, action: #selector(self.switchChange), for: .valueChanged)
    }
    
    // MARK: ==== Event ====
    @objc
    private func startSort() {
        self.delegate?.start()
    }
    @objc
    private func reset() {
        self.delegate?.reset()
    }
    @objc
    private func switchChange() {
        let isOn = self.switchView.isOn
        BPCacheManager.set(isOn, forKey: .randomData)
    }

    /// 设置最坏时间复杂度
    /// - Parameter text: 复杂度
    internal func setWorstTimeComplexity(content text: String) {
        let prefixStr = "最坏："
        let attrStr   = NSMutableAttributedString(string: prefixStr + text, attributes:  [NSAttributedString.Key.foregroundColor : UIColor.gray1, NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptSize(14))])
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red1, NSAttributedString.Key.font : UIFont.mediumFont(ofSize: AdaptSize(14))], range: NSRange(location: 0, length: prefixStr.count))
        self.worstTimeComplexityLabel.attributedText = attrStr
    }

    /// 设置平均时间复杂度
    /// - Parameter text: 复杂度
    internal func setAverageTimeComplexity(context text: String) {
        let prefixStr = "平均："
        let attrStr   = NSMutableAttributedString(string: prefixStr + text, attributes:  [NSAttributedString.Key.foregroundColor : UIColor.gray1, NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptSize(14))])
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black1, NSAttributedString.Key.font : UIFont.mediumFont(ofSize: AdaptSize(14))], range: NSRange(location: 0, length: prefixStr.count))
        self.averageTimeComplexityLabel.attributedText = attrStr
    }

    /// 设置最好时间复杂度
    /// - Parameter text: 复杂度
    internal func setBestTimeComplexity(context text: String) {
        let prefixStr = "最好："
        let attrStr   = NSMutableAttributedString(string: prefixStr + text, attributes:  [NSAttributedString.Key.foregroundColor : UIColor.gray1, NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptSize(14))])
        attrStr.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.green1, NSAttributedString.Key.font : UIFont.mediumFont(ofSize: AdaptSize(14))], range: NSRange(location: 0, length: prefixStr.count))
        self.bestTimeComplexityLabel.attributedText = attrStr
    }
}

