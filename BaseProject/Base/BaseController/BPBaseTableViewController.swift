//
//  BPBaseTableViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPBaseTableViewController: UITableViewController {

    let dataSourceArray = Array(repeating: "好的", count: 20)

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    override func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    
    override func scrollViewDidChangeAdjustedContentInset(_ scrollView: UIScrollView) {
        
    }
    
    override func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
    
    override func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(scrollView.contentOffset.y)
        if decelerate {
            let minY = (-50 - kNavHeight)
            // 显示loading动画
            if scrollView.contentOffset.y < minY {
                UIView.animate(withDuration: 0.25) {
                    // 显示顶部loading动画的时候,设置TableView加载动画
                    scrollView.contentOffset = CGPoint(x: 0, y: abs(minY))
                }
                // 显示loading动画
                self.view.showTopLoading()
            }
        }
    }

    // - MARK: Delegate
    // - MARK: DataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceArray.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.textLabel?.text = dataSourceArray[indexPath.row]
        return cell
    }
}
