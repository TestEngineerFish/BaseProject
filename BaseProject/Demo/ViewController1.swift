//
//  ViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class ViewController1: BPViewController, UITableViewDelegate, UITableViewDataSource {

    var typeList: [AlgorithmType] = [.bubbleSort, .chooseSort, .insertionSort, .shellSort]

    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator   = false
        tableView.rowHeight = AdaptSize(44)
        tableView.backgroundColor = .gray1
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNavHeight)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func bindProperty() {
        self.customNavigationBar?.title = "Algorithm"
        self.customNavigationBar?.leftButton.isHidden = true
        self.tableView.delegate   = self
        self.tableView.dataSource = self
    }

    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = self.typeList[indexPath.row]
        let cell = UITableViewCell(style: .default, reuseIdentifier: "algorithm")
        cell.textLabel?.text = type.rawValue
        cell.selectionStyle  = .none
        cell.accessoryType   = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc  = AlgorithmViewController()
        vc.type = self.typeList[indexPath.row]
        self.navigationController?.addChild(vc)
        (self.navigationController as? BPBaseNavigationController)?.selectedIndex = 1
    }

}

// 转场代理
extension ViewController2: UIViewControllerTransitioningDelegate {

}
// 动画控制器
//extension ViewController2: UIViewControllerAnimatedTransitioning {
//    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
//        transitionContext?.containerView.backgroundColor = .blue
//        let fromVC   = transitionContext?.viewController(forKey: .from)
//        let toVC     = transitionContext?.viewController(forKey: .to)
//        let fromView = transitionContext?.view(forKey: .from)
//        let toView   = transitionContext?.view(forKey: .to)
//        return 0.5
//    }
//
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//
//    }
//}
// 交互控制器
//extension ViewController2: UIViewControllerInteractiveTransitioning {
//    func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
//
//    }
//}
// 转场环境(生成转场需要的数据)
//extension ViewController2: UIViewControllerContextTransitioning {
//
//}
// 转场协调器
//extension ViewController2: UIViewControllerTransitionCoordinator {
//
//}
