//
//  BPEarthViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/12/11.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPEarthViewController: BPViewController {

    private var earthView: BPEarthView?

    private var numberLabel: UILabel = {
        let label = UILabel()
        label.text          = ""
        label.textColor     = UIColor.black1
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.textAlignment = .center
        return label
    }()
    private let sliderView: UISlider = {
        let sliderView = UISlider()
        sliderView.maximumValue = 100
        sliderView.minimumValue = 10
        sliderView.value        = 80
        return sliderView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.showEarthView()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(numberLabel)
        self.view.addSubview(sliderView)
        numberLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(sliderView.snp.top).offset(AdaptSize(-30))
        }
        sliderView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-kSafeBottomMargin - AdaptSize(180))
            make.size.equalTo(CGSize(width: AdaptSize(300), height: AdaptSize(20)))
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.sliderView.addTarget(self, action: #selector(self.updateValue(slider:)), for: .valueChanged)
        self.numberLabel.text = "\(Int(sliderView.value))"
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
        self.hideEarthView()
        self.showEarthView()
    }

    // MARK: ==== Event ====
    private func showEarthView() {
        let earthFrame   = CGRect(x: 50, y: kNavHeight + AdaptSize(30), width: kScreenWidth - 100, height: kScreenWidth - 100)
        let earthMaxItem = Int(self.sliderView.value)
        self.earthView   = BPEarthView(frame: earthFrame, maxItem: earthMaxItem)
        self.view.addSubview(earthView!)

    }

    private func hideEarthView() {
        self.earthView?.removeFromSuperview()
    }

    @objc private func updateValue(slider: UISlider) {
        self.numberLabel.text = "\(Int(slider.value))"
    }
}
