//
//  AppDelegate.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public static let `default` = UIApplication.shared.delegate as! AppDelegate

    var window: UIWindow?

    let networkManager = NetworkReachabilityManager()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.monitorNetWork() //添加网络监听
        Bugly.start(withAppId: buglyAppId)
        // 设置自定义的NavigationController为初始NavigationController
        window = UIWindow(frame: UIScreen.main.bounds)
        let tabBarController = BPBaseTabBarController()
        tabBarController.selectedIndex = 0
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        // 初始化第三方配置
        self.initThirdPartyServices()
        return true
    }

    func initThirdPartyServices() {
        // ---- 日志 ----
        BPOCLog.shared()?.launch()
        // ---- 软件盘 ----
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /// 禁止使用第三方软件盘
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard {
            return false
        }
        return true
    }

}

