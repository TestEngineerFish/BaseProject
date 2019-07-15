//
//  YYLocationManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import CoreLocation

class YYLocationManager: NSObject {

    static var `default` = YYLocationManager()

    private var locationManager: CLLocationManager?

    private override init() {
        super.init()
    }


    public func start() {
        // 系统权限设置
        YYAuthorizationManager.authorizeLocationWith(false) { (result) in
            if result {
                self.startUpdatingLocation()
            }
        }
    }

}

extension YYLocationManager {

    private func startUpdatingLocation() {

        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            //使用应用程序期间允许访问位置数据
            locationManager?.requestWhenInUseAuthorization()
            locationManager?.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager?.distanceFilter = kCLLocationAccuracyKilometer
            // 设置iOS设备是否可暂停定位来节省电池的电量。如果该属性设为“YES”，则当iOS设备不再需要定位数据时，iOS设备可以自动暂停定位。
            locationManager?.pausesLocationUpdatesAutomatically = true
        }

        locationManager?.startUpdatingLocation()
    }
}

extension YYLocationManager : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            UserDefaults.standard.archive(object: location.coordinate.latitude.format(), forkey: YYCacheKeyName.kLocationLatitude)
            UserDefaults.standard.archive(object: location.coordinate.longitude.format(), forkey: YYCacheKeyName.kLocationLongitude)
            UserDefaults.standard.archive(object: location.altitude.format(), forkey: YYCacheKeyName.kLocationAltitude)

            //            print("经纬度\(location.coordinate)")
        }
    }
}


extension YYLocationManager {

    var latitude: String {
        if let lat = UserDefaults.standard.unarchivedObject(forkey: YYCacheKeyName.kLocationLatitude) as? CLLocationDegrees {
            return String(lat)
        }
        return ""
    }

    var longitude: String {
        if let lng = UserDefaults.standard.unarchivedObject(forkey: YYCacheKeyName.kLocationLongitude) as? CLLocationDegrees {
            return String(lng)
        }
        return ""
    }

    var altitude: String {
        if let alt = UserDefaults.standard.unarchivedObject(forkey: YYCacheKeyName.kLocationAltitude) as? CLLocationDegrees {
            return String(alt)
        }
        return ""
    }

}
