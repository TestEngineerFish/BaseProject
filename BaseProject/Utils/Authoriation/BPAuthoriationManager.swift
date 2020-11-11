//
//  BPAuthoriationManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/4.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Photos
import UserNotifications
import UIKit

enum BPAuthorizationType: String {
    /// 相册
    case photo        = "相册"
    /// 照相机
    case camera       = "照相机"
    /// 麦克风
    case microphone   = "麦克风"
    /// 定位
    case location     = "定位"
    /// 通知
    case notification = "通知"
    /// 网络
    case network      = "网络"
}

struct BPAuthorizationManager {

    static let share = BPAuthorizationManager()
    
    // MARK: - ---获取相册权限
    func photo(completion:@escaping (Bool) -> Void) {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            kWindow.makeToast("相册不可用")
            return
        }
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
            self.showAlert(type: .photo)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    let result = status == PHAuthorizationStatus.authorized
                    completion(result)
                    if (!result) {
                        self.showAlert(type: .photo)
                    }
                }
            })
        case .limited:
            completion(true)
        @unknown default:
            return
        }
    }
    
    // MARK: - --相机权限
    func camera(completion:@escaping (Bool) -> Void ) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            kWindow.makeToast("照相机不可用")
            return
        }
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch status {
        case .authorized:
            completion(true)
        case .denied:
            completion(false)
            self.showAlert(type: .camera)
        case .restricted:
            completion(false)
            self.showAlert(type: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) in
                DispatchQueue.main.async {
                    completion(granted)
                    if (!granted) {
                        self.showAlert(type: .camera)
                    }
                }
            })
        @unknown default:
            return
        }
    }
    
    // MARK: - --麦克风权限
    func authorizeMicrophoneWith(_ autoAlert: Bool = true, completion:@escaping (Bool) -> Void ) {
        
        let status = AVAudioSession.sharedInstance().recordPermission
        
        switch status {
        case .granted:
            completion(true)
            break
        case .denied:
            completion(false)
            if autoAlert { self.showAlert(type: .microphone) }
            break
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { (allow) in
                DispatchQueue.main.async {
                    completion(allow)
                    if (!allow && autoAlert) {
                        self.showAlert(type: .microphone)
                    }
                }
            }
        @unknown default:
            return
        }
    }
    
    // MARK: - --位置权限
    func authorizeLocationWith(_ autoAlert: Bool = true, completion:@escaping (Bool) -> Void ) {
        
        if CLLocationManager.locationServicesEnabled() {
            let authStatus = CLLocationManager.authorizationStatus()
            if authStatus == .notDetermined || authStatus == .authorizedWhenInUse { // App没有显示过授权，或者已经授权
                completion(true)
            } else if authStatus == .restricted || authStatus == .denied { // App没有授权，或者授权后用户手动关闭了
                completion(false)
                if autoAlert { self.showAlert(type: .location) }
            }
        } else {
            completion(false)
            if autoAlert {
                self.jumpToSystemLocationSetting()
            }
        }
        
    }
    
    // MARK: - --远程通知权限
    func authorizeRemoteNotification(_ completion:@escaping (Bool) -> Void) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                DispatchQueue.main.async {
                    if settings.authorizationStatus == .denied || settings.authorizationStatus == .notDetermined {
                        completion(false)
                    }else{
                        completion(true)
                    }
                }
            }
        } else {
            if let userNotificationSettingTyps = UIApplication.shared.currentUserNotificationSettings?.types {
                if userNotificationSettingTyps.contains(.alert) ||
                    userNotificationSettingTyps.contains(.badge) ||
                    userNotificationSettingTyps.contains(.sound) {
                    completion(true)
                }else{
                    completion(false)
                }
            }else{
                completion(false)
            }
        }
    }
    
    ///请求地理位置权限
//    private lazy var locationManager: CLLocationManager = {
//        let _locationManager = CLLocationManager()
//        _locationManager.delegate = self
//        return _locationManager
//    }()
    
    private var authorizationComplet: (() -> Void)?
    
//    func requestWhenInUseAuthorization(_ complet: (() -> Void)?) {
//        self.authorizationComplet = complet
//        locationManager.requestWhenInUseAuthorization()
//    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied, .authorizedWhenInUse, .authorizedAlways:
            self.authorizationComplet?()
        default:
            break
        }
    }

    // MARK: ==== Event ====
    private func showAlert(type: BPAuthorizationType) {
        let title        = String(format: "无法访问你的%@", type.rawValue)
        let description  = String(format: "请到设置 -> %@ -> %@，打开访问权限", projectName, type.rawValue)

        BPAlertManager.share.showTwoButton(title: title, description: description, leftBtnName: "取消", leftBtnClosure: nil, rightBtnName: "打开") {
            self.jumpToAppSetting()
        }
    }

    // MARK: 跳转到APP内设置界面
    private func jumpToAppSetting() {
        let appSetting = URL(string: UIApplication.openSettingsURLString)

        if appSetting != nil {
            if #available(iOS 10, *) {
                UIApplication.shared.open(appSetting!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(appSetting!)
            }
        }
    }

    /** 跳转定位服务设置界面 ，使用私有链接，被拒绝了，因此只能提示，不能跳转 */
    func jumpToSystemLocationSetting() {
        BPAlertManager.share.showOneButton(title: "APP定位服务未开启", description: "请到【设置 -> 隐私 -> 定位服务 -> 定位服务】进行开启", buttonName: "好的", closure: nil)
    }
}
