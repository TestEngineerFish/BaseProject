//
//  BPChatRoomCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/13.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPChatRoomCellDelegate: NSObjectProtocol {
    func clickBubble(model: BPMessageModel, indexPath: IndexPath)
}

class BPChatRoomCell: UITableViewCell {

    private var messageModel: BPMessageModel?
    private var indexPath: IndexPath?
    weak var delegate: BPChatRoomCellDelegate?

    private var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius  = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode         = .scaleAspectFill
        return imageView
    }()

    private var leftArrowLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: AdaptSize(8), y: 0))
        path.addLine(to: CGPoint(x: 0, y: AdaptSize(5)))
        path.addLine(to: CGPoint(x: AdaptSize(8), y: AdaptSize(10)))
        path.close()
        let arrowLayer = CAShapeLayer()
        arrowLayer.path            = path.cgPath
        arrowLayer.backgroundColor = UIColor.clear.cgColor
        arrowLayer.fillColor       = UIColor.clear.cgColor
        arrowLayer.isHidden        = true
        return arrowLayer
    }()

    private var rightArrowLayer: CAShapeLayer = {
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: AdaptSize(8), y: AdaptSize(5)))
        path.addLine(to: CGPoint(x: 0, y: AdaptSize(10)))
        path.close()
        let arrowLayer = CAShapeLayer()
        arrowLayer.path            = path.cgPath
        arrowLayer.lineJoin        = .round
        arrowLayer.backgroundColor = UIColor.clear.cgColor
        arrowLayer.fillColor       = UIColor.clear.cgColor
        arrowLayer.isHidden        = true
        return arrowLayer
    }()

    var bubbleView: BPChatRoomBaseMessageBubble?

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
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSubviews() {
        self.rightArrowLayer.frame = CGRect(x: kScreenWidth - AdaptSize(71), y: AdaptSize(20), width: AdaptSize(8), height: AdaptSize(10))
        self.leftArrowLayer.frame  = CGRect(x: AdaptSize(70 - 7), y: AdaptSize(20), width: AdaptSize(8), height: AdaptSize(10))
        self.addSubview(avatarImageView)
        self.layer.addSublayer(leftArrowLayer)
        self.layer.addSublayer(rightArrowLayer)
    }

    private func bindProperty() {
        self.selectionStyle  = .none
        self.backgroundColor = .clear
    }

    // MARK: ==== Evnet ====
    func setData(model: BPMessageModel, indexPath: IndexPath) {
        self.messageModel = model
        self.indexPath    = indexPath
        // 设置内容展示视图
        self.setBubbleView()
        // 设置箭头视图
        self.setArrowView()
        // 设置头像
        self.avatarImageView.image = UIImage(named: "dog")
        switch model.fromType {
        case .me:
            self.avatarImageView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(AdaptSize(5))
                make.right.equalToSuperview().offset(AdaptSize(-15))
                make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(40)))
                make.bottom.lessThanOrEqualToSuperview().offset(AdaptSize(-5)).priority(.high)
            }
            self.bubbleView?.snp.remakeConstraints { (make) in
                make.right.equalTo(avatarImageView.snp.left).offset(AdaptSize(-15))
                make.top.equalTo(avatarImageView)
                make.left.greaterThanOrEqualToSuperview().offset(AdaptSize(100))
                make.bottom.lessThanOrEqualToSuperview().offset(AdaptSize(-5)).priority(.low)
            }
        case .friend:
            self.avatarImageView.snp.remakeConstraints { (make) in
                make.top.equalToSuperview().offset(AdaptSize(5))
                make.left.equalToSuperview().offset(AdaptSize(15))
                make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(40)))
                make.bottom.lessThanOrEqualToSuperview().offset(AdaptSize(-5)).priority(.high)
            }
            self.bubbleView?.snp.remakeConstraints { (make) in
                make.left.equalTo(avatarImageView.snp.right).offset(AdaptSize(15))
                make.top.equalTo(avatarImageView)
                make.right.lessThanOrEqualToSuperview().offset(AdaptSize(-100))
                make.bottom.lessThanOrEqualToSuperview().offset(AdaptSize(-5)).priority(.low)
            }
        default:
            break
        }
    }

    /// 点击bubble区域事件
    @objc private func clickBubbleAction() {
        guard let model = self.messageModel, let indexPath = self.indexPath else {
            return
        }
        self.delegate?.clickBubble(model: model, indexPath: indexPath)
    }

    // MARK: ==== Tools ===

    private func setBubbleView() {
        guard let model = self.messageModel else { return }
        if self.bubbleView?.superview != nil {
            self.bubbleView?.removeFromSuperview()
        }
        self.bubbleView = BPChatRoomMessageBubbleFactory.buildView(message: model)
        var bgColor = UIColor.clear
        switch model.fromType {
        case .me:
            bgColor = .green0
        case .friend:
            bgColor = .white0
        default:
            break
        }
        self.bubbleView?.backgroundColor    = bgColor
        self.bubbleView?.layer.cornerRadius = 5
        self.addSubview(bubbleView!)
        // 设置事件
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.clickBubbleAction))
        self.bubbleView?.addGestureRecognizer(tapAction)
    }

    private func setArrowView() {
        guard let model = self.messageModel else { return }
        if model.fromType == .me || model.type == .image {
            self.leftArrowLayer.isHidden = true
        } else {
            self.leftArrowLayer.isHidden = false
        }
        if model.fromType == .friend || model.type == .image {
            self.rightArrowLayer.isHidden = true
        } else {
            self.rightArrowLayer.isHidden = false
        }
        // 设置箭头颜色
        self.leftArrowLayer.fillColor  = self.bubbleView?.backgroundColor?.cgColor
        self.rightArrowLayer.fillColor = self.bubbleView?.backgroundColor?.cgColor
    }
}
