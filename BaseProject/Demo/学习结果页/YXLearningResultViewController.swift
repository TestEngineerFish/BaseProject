//
//  YXLearningResultViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/9.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


class YXLearningResultViewController: UIViewController {

    let model: YXLearingResultModel = YXLearingResultModel(star: 1, unitStr: "Unit 2", newLearn: 32, review: 20, unlockUnit: "拓展词汇")
    let modelArray: [YXLearningPathModel] = {
        var array = [YXLearningPathModel]()
        for index in 0..<2 {
            var model = YXLearningPathModel()
            model.unit_id = index
            model.name = "Unit \(index + 1)"
            if index > 0 {
                model.rate = 0.0
                model.start = 0
                model.isLearning = false
                model.isLearned  = false
                model.type = .uniteUnstart
            } else {
                model.rate = 1.0
                model.start = Int(arc4random()%4)
                model.isLearned = false
                model.isLearned = true
                model.type = .uniteIng
            }
            array.append(model)
        }
        return array
    }()
    var backButton = UIButton()
    var punchButton = BPBaseButton()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.createSubviews()
    }

    private func createSubviews() {
        // 返回按钮
        backButton.setImage(UIImage(named: "back"), for: .normal)
        self.view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(16))
            make.top.equalToSuperview().offset(AdaptSize(32))
            make.width.height.equalTo(AdaptSize(22))
        }
        backButton.addTarget(self, action: #selector(backClick), for: .touchUpInside)

        // 结果视图
        let headerView = YXLearningResultHeaderView(model)
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(AdaptSize(244))
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }

        // 任务地图视图
        let taskMapViewSize = CGSize(width: AdaptSize(307), height: AdaptSize(245))
        let taskMapView = YXTaskMapView(modelArray, frame: CGRect(origin: CGPoint.zero, size: taskMapViewSize))
        taskMapView.backgroundColor    = UIColor.white
        taskMapView.layer.cornerRadius = 6
        self.view.addSubview(taskMapView)
        taskMapView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(57)
            make.size.equalTo(taskMapViewSize)
            make.centerX.equalToSuperview()
        }
        taskMapView.layer.setDefaultShadow()

        let taskMapLabel = UILabel()
        taskMapLabel.text = "任务地图"
        taskMapLabel.font = UIFont.regularFont(ofSize: 12)
        taskMapLabel.textColor = UIColor.hex(0xFBA217)
        self.view.addSubview(taskMapLabel)
        taskMapLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(taskMapView.snp.top).offset(-7)
            make.left.equalTo(taskMapView)
            make.width.equalTo(48)
            make.height.equalTo(12)
        }

        // 打卡按钮
        let punchSize = CGSize(width: kScreenWidth - AdaptSize(100), height: AdaptSize(42))
        punchButton.setTitle("打卡", for: .normal)
        punchButton.setTitleColor(UIColor.white, for: .normal)
        punchButton.size = punchSize
        punchButton.cornerRadius = punchButton.size.height/2
        punchButton.layer.setGradient(colors: [UIColor.hex(0xFDBA33), UIColor.hex(0xFB8417)], direction: .vertical)
        self.view.addSubview(punchButton)
        punchButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30 - kSafeBottomMargin)
            make.size.equalTo(punchSize)
        }
    }

    @objc private func backClick() {
        self.navigationController?.popViewController(animated: true)
    }
}
