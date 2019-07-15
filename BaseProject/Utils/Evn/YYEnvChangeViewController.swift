//
//  YYEnvChangeViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

typealias YYEVC = YYEnvChangeViewController

class YYEnvChangeViewController: YYBaseViewController {
    
    private enum EnvType: Int {
        case dev = 0
        case test = 1
        case pre = 2
        case release = 3
    }
    
    private static let envKey = "YYEnvChangeView_Key";
    
    private var currentSelected: Int = 3
    
    private static let envData = [
        EnvType.dev  : ["title" : "开发环境", "api" : "https://api-dev.helloyouyou.com",  "h5" : "https://dev.helloyouyou.com"],
        EnvType.test : ["title" : "测试环境", "api" : "https://api-test.helloyouyou.com", "h5" : "https://test.helloyouyou.com"],
        EnvType.pre  : ["title" : "预发环境", "api" : "https://api-pre.helloyouyou.com",  "h5" : "https://pre.helloyouyou.com"],
        EnvType.release : ["title" : "正式环境", "api" : "https://api.helloyouyou.com",   "h5" : "https://www.helloyouyou.com"]
    ]
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.frame = CGRect(x: 0 , y: YYConstants.contentView_TopOffset, width: screenWidth, height: screenHeight - YYConstants.contentView_TopOffset)
        tv.delegate = self
        tv.dataSource = self
        tv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 120))
        tv.tableFooterView?.backgroundColor = UIColor.white1
        tv.tableFooterView?.addSubview(self.button)
        tv.tableFooterView?.addSubview(self.tipsLabel)
        return tv
    }()
    
    
    private lazy var button: UIButton = {
        let button = UIButton()
        
        button.frame = CGRect(x: 30, y: 40, width: screenWidth - 60, height: 50)
        button.setTitle("确认切换", for: .normal)
        button.titleLabel?.textColor = UIColor.black2
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.green1), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.green1.withAlphaComponent(0.4)), for: .highlighted)
        button.addTarget(self, action: #selector(buttonDidClick), for: .touchUpInside)
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        
        button.isEnabled = false
        
        return button
    }()
    
    private lazy var tipsLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 90, width: screenWidth, height: 30)
        label.text = "点击确认切换，会杀掉App"
        label.textColor = UIColor.gray1
        label.font = UIFont.lightFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customNavigationBar?.title = "选择环境"
        
        self.view.addSubview(self.tableView)
        self.view.backgroundColor = UIColor.white1
        self.currentSelected = (YYCache.object(forKey: YYEVC.envKey) as? Int) ?? 1
    }
    
}


extension YYEnvChangeViewController {
    public static var apiUrl: String {
        #if DEBUG
        if let selected = YYCache.object(forKey: envKey) as? Int, let e = EnvType(rawValue: selected) {
            return envData[e]?["api"] ?? ""
        }
        return envData[.test]?["api"] ?? ""
        #else
        return envData[.release]?["api"] ?? ""
        #endif
    }
    
    public static var h5Url: String {
        #if DEBUG
        if let selected = YYCache.object(forKey: envKey) as? Int, let e = EnvType(rawValue: selected) {
            return envData[e]?["h5"] ?? ""
        }
        return envData[.test]?["h5"] ?? ""
        #else
        return envData[.release]?["h5"] ?? ""
        #endif
    }
}


extension YYEnvChangeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return YYEVC.envData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idf = "kUITableViewCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: idf)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: idf)
        }
        
        let type = EnvType(rawValue: indexPath.row) ?? .test
        
        cell?.textLabel?.text = YYEVC.envData[type]?["title"]
        cell?.textLabel?.font = UIFont.mediumFont(ofSize: 17)
        
        let detailText = "API: \(YYEVC.envData[type]?["api"] ?? "")\nH5: \(YYEVC.envData[type]?["h5"] ?? "")"
        cell?.detailTextLabel?.numberOfLines = 0
        cell?.detailTextLabel?.text = detailText
        cell?.detailTextLabel?.textColor = UIColor.gray2
        
        
        if indexPath.row == currentSelected {
            cell?.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell!
    }
    
}


extension YYEnvChangeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let lastCell = tableView.cellForRow(at: IndexPath(row: currentSelected, section: 0))
        lastCell?.accessoryType = .none
        
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        self.currentSelected = indexPath.row
        
        if let selected = YYCache.object(forKey: YYEVC.envKey) as? Int, selected == currentSelected {
            self.button.isEnabled = false
        } else {
            self.button.isEnabled = true
        }
    }
}

extension YYEnvChangeViewController {
    @objc private func buttonDidClick() {
        
        YYCache.set(currentSelected, forKey: YYEVC.envKey)
        
        let exitBlock = {
            self.view.toast("正在关闭App")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                exit(0)
            }
        }
        
        if YYUserModel.hasBeenLogin() {
            YYSettingManager.logout(completion: { (resultModel, errorMsg) in
                AppDelegate.default.appLogout()
                exitBlock()
            })
        } else {
            exitBlock()
        }
        
    }
}
