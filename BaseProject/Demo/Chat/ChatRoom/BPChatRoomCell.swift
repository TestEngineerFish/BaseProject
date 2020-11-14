//
//  BPChatRoomCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPChatRoomCell: UITableViewCell {

    private var messageModel: BPMessageModel?

    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius  = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private var leftArrowLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: AdaptSize(8), y: 0))
        path.addLine(to: CGPoint(x: 0, y: AdaptSize(5)))
        path.addLine(to: CGPoint(x: AdaptSize(8), y: AdaptSize(10)))
        path.close()
        let arrowLayer = CAShapeLayer()
        arrowLayer.path = path.cgPath
        arrowLayer.backgroundColor = UIColor.clear.cgColor
        arrowLayer.fillColor = UIColor.clear.cgColor
        arrowLayer.isHidden  = true
        return arrowLayer
    }()

    private var rightArrowLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: AdaptSize(8), y: AdaptSize(5)))
        path.addLine(to: CGPoint(x: 0, y: AdaptSize(10)))
        path.close()
        let arrowLayer = CAShapeLayer()
        arrowLayer.path = path.cgPath
        arrowLayer.lineJoin = .round
        arrowLayer.backgroundColor = UIColor.clear.cgColor
        arrowLayer.fillColor = UIColor.clear.cgColor
        arrowLayer.isHidden  = true
        return arrowLayer
    }()

    private var bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.randomColor()
        return view
    }()

    // 替换为自定义视图
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: 14)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.rightArrowLayer.frame = CGRect(x: kScreenWidth - AdaptSize(70), y: AdaptSize(20), width: AdaptSize(8), height: AdaptSize(10))
        self.leftArrowLayer.frame = CGRect(x: AdaptSize(70 - 8), y: AdaptSize(20), width: AdaptSize(8), height: AdaptSize(10))
        self.addSubview(avatarImageView)
        self.addSubview(bubbleView)
        bubbleView.addSubview(contentLabel)
        self.layer.addSublayer(leftArrowLayer)
        self.layer.addSublayer(rightArrowLayer)
    }

    // MARK: ==== Evnet ====
    func setData(model: BPMessageModel) {
        self.contentLabel.text     = model.text
        self.avatarImageView.image = UIImage(named: "dog")
        switch model.fromType {
        case .me:
            self.leftArrowLayer.isHidden   = true
            self.rightArrowLayer.isHidden  = false
            self.leftArrowLayer.fillColor  = UIColor.clear.cgColor
            self.rightArrowLayer.fillColor = UIColor.orange1.cgColor
            self.avatarImageView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(AdaptSize(5))
                make.right.equalToSuperview().offset(AdaptSize(-15))
                make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(40)))
                make.bottom.lessThanOrEqualToSuperview().offset(AdaptSize(-5)).priority(.high)
            }
            self.bubbleView.snp.remakeConstraints { (make) in
                make.right.equalTo(avatarImageView.snp.left).offset(AdaptSize(-15))
                make.top.equalTo(avatarImageView)
                make.left.greaterThanOrEqualToSuperview().offset(AdaptSize(80))
                make.bottom.lessThanOrEqualToSuperview().offset(AdaptSize(-5)).priority(.low)
            }
            self.contentLabel.snp.remakeConstraints { (make) in
                make.left.top.equalToSuperview().offset(AdaptSize(8))
                make.bottom.right.equalToSuperview().offset(AdaptSize(-8))
            }
        case .friend:
            self.leftArrowLayer.isHidden   = false
            self.rightArrowLayer.isHidden  = true
            self.leftArrowLayer.fillColor  = UIColor.orange1.cgColor
            self.rightArrowLayer.fillColor = UIColor.clear.cgColor
            self.avatarImageView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(AdaptSize(5))
                make.left.equalToSuperview().offset(AdaptSize(15))
                make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(40)))
                make.bottom.lessThanOrEqualToSuperview().offset(AdaptSize(-5)).priority(.high)
            }
            self.bubbleView.snp.remakeConstraints { (make) in
                make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(15))
                make.top.equalTo(avatarImageView)
                make.right.lessThanOrEqualToSuperview().offset(AdaptSize(-80))
                make.bottom.lessThanOrEqualToSuperview().offset(AdaptSize(-5)).priority(.low)
            }
            self.contentLabel.snp.remakeConstraints { (make) in
                make.left.top.equalToSuperview().offset(AdaptSize(8))
                make.bottom.right.equalToSuperview().offset(AdaptSize(-8))
            }
        default:
            break
        }
    }

    // MARK: ==== Tools ===
}
