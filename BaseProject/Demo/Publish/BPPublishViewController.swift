//
//  BPPublishViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/25.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPPubilshViewController: BPViewController, UITextViewDelegate, BPPubilshTipsViewDelegate, BPPubilshToolsViewDelegate {

    var model: BPPublishModel = BPPublishModel()

    private var textView: IQTextView = {
        let textView = IQTextView()
        textView.placeholder = "记录你的心情"
        textView.font = UIFont.regularFont(ofSize: AdaptSize(16))
        textView.backgroundColor = .randomColor()
        return textView
    }()
    private var lineView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.gray0
        return view
    }()
    private var imageListView = BPPublishImageListView()
    private var tipsView      = BPPubilshTipsView()
    private var toolsView     = BPPubilshToolsView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.setCustomNaviation()
        self.view.addSubview(lineView)
        self.view.addSubview(textView)
        self.view.addSubview(imageListView)
        self.view.addSubview(tipsView)
        self.view.addSubview(toolsView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
            make.height.equalTo(0.9)
        }
        textView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(lineView.snp.bottom)
        }
        imageListView.snp.makeConstraints { (make) in
            make.left.right.equalTo(textView)
            make.height.equalTo(0)
            make.top.equalTo(textView.snp.bottom)
        }
        tipsView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageListView.snp.bottom)
            make.height.equalTo(AdaptSize(30))
        }
        toolsView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(tipsView.snp.bottom)
            make.height.equalTo(toolsView.toolBarHeight)
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.textView.delegate = self
        self.tipsView.delegate = self
        self.toolsView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard(notification:)), name: BPPubilshViewController.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(notification:)), name: BPPubilshViewController.keyboardWillHideNotification, object: nil)
    }

    private func setCustomNaviation() {
        self.customNavigationBar?.title = "发布帖子"
        self.customNavigationBar?.leftButton.setTitle(IconFont.close1.rawValue, for: .normal)
        self.customNavigationBar?.leftButton.titleLabel?.font = UIFont.iconFont(size: AdaptSize(15))
        self.customNavigationBar?.rightFirstButton.setTitle("发布", for: .normal)
        self.customNavigationBar?.leftButton.left = AdaptSize(15)
        self.customNavigationBar?.leftButtonAction = { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: ==== Event ====
    @objc private func showKeyboard(notification: Notification) {
        guard let frameValue = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] as? CGRect, let _ = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] as? Double else {
            return
        }
        let margin = kScreenHeight - frameValue.minY - kSafeBottomMargin + toolsView.toolBarHeight
        self.toolsView.snp.updateConstraints { (make) in
            make.height.equalTo(margin)
        }
//        DispatchQueue.main.async {
//            self.toolsView.resetContentView()
//        }
    }

    @objc private func hideKeyboard(notification: Notification) {
        self.toolsView.snp.updateConstraints { (make) in
            make.height.equalTo(toolsView.toolBarHeight)
        }
    }

    private func updateTipsView() {
        self.tipsView.setDate(model: model)
    }

    // MARK: ==== UITextViewDelegate ====
    func textViewDidBeginEditing(_ textView: UITextView) {

    }

    // MARK: ==== BPPubilshTipsViewDelegate ====
    func clickLocalAction() {
        BPLog("selectLocalAction")
        let vc = BPPublishLocalViewController()
        self.present(vc, animated: true, completion: nil)
    }

    func clickTagAction() {
        let vc = BPPublishTagViewController()
        self.present(vc, animated: true, completion: nil)
        BPLog("appendTagAction")
    }

    func clickLimitAction() {
        BPLog("setLimitAction")
        let vc = BPPublishLimitViewController()
        vc.currentLimitType = model.limitType
        vc.selectedBlock = { [weak self] (type: BPPublishLimitType) in
            guard let self = self else { return }
            self.model.limitType = type
            self.updateTipsView()
        }
        self.present(vc, animated: true, completion: nil)
    }

    // MARK: ==== BPPubilshToolsViewDelegate ====
    func clickRecordAction(content height:CGFloat) {
        BPLog("clickRecordAction")
        self.textView.resignFirstResponder()
        self.toolsView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }

    func clickCameraAction() {
        BPSystemPhotoManager.share.showCamera { [weak self] (image: UIImage?) in
            guard let self = self, let _image = image else { return }
            self.imageListView.backgroundColor = .randomColor()
            self.imageListView.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(100))
            }
        }
        BPLog("clickCameraAction")
    }

    func clickPhotoAction() {
        BPSystemPhotoManager.share.showPhoto { [weak self] (image: UIImage?) in
            guard let self = self, let _image = image else { return }
            self.imageListView.backgroundColor = .randomColor()
            self.imageListView.snp.updateConstraints { (make) in
                make.height.equalTo(AdaptSize(100))
            }
        }
        BPLog("clickPhotoAction")
    }

    func clickEmojiAction(content height:CGFloat) {
        BPLog("clickEmojiAction")
        self.textView.resignFirstResponder()
        self.toolsView.snp.updateConstraints { (make) in
            make.height.equalTo(height)
        }
    }

    func clickRemindAction() {
        BPLog("clickRemindAction")
        let vc = BPPublishRemindViewController()
        self.present(vc, animated: true, completion: nil)
    }
}
