//
//  ViewController3.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController3: BPViewController {
    var earthView: BPEarthView?
    var textField: UITextField = {
        let textField = UITextField()
        textField.keyboardType       = .numberPad
        textField.placeholder        = "Item数量"
        textField.backgroundColor    = .white
        textField.layer.borderWidth  = AdaptSize(0.9)
        textField.layer.borderColor  = UIColor.gray1.cgColor
        textField.layer.cornerRadius = AdaptSize(8)
        textField.textColor          = UIColor.black1
        textField.leftView           = UIView()
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        self.customNavigationBar?.isHidden = true
        self.createSubviews()
        self.showEarthView()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin - AdaptSize(180))
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(40)))
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
        self.hideEarthView()
        self.showEarthView()
    }

    // MARK: ==== Event ====
    private func showEarthView() {
//        let earthFrame   = CGRect(x: 50, y: kNavHeight + AdaptSize(30), width: kScreenWidth - 100, height: kScreenWidth - 100)
//        let earthMaxItem = Int(self.textField.text ?? "100") ?? 100
//        self.earthView   = BPEarthView(frame: earthFrame, maxItem: earthMaxItem)
//        self.view.addSubview(earthView!)
        let drawView = DrawView(frame: self.view.bounds)
        self.view.addSubview(drawView)
    }

    private func hideEarthView() {
        self.earthView?.removeFromSuperview()
    }
}
