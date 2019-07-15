//
//  YYDateUtils.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

public struct YYDateUtils {

    public static func dynamicListDataToStringDay(timeInterval: TimeInterval) -> String? {
        let nowDate: Date = Date()
        let dynamicDate: Date = Date(timeIntervalSince1970: timeInterval)

        let secondsPerDay: TimeInterval = 24 * 60 * 60
        let yearsterDay: Date = Date(timeIntervalSinceNow: -secondsPerDay)
        let calendar = Calendar.current
        let components: Set<Calendar.Component> = Set(arrayLiteral: .year, .month, .day)
        let nowDateComponents: DateComponents = calendar.dateComponents(components, from: nowDate)
        let yearsterDateComponents: DateComponents = calendar.dateComponents(components, from: yearsterDay)
        let dynamicDateComponents: DateComponents = calendar.dateComponents(components, from: dynamicDate)

        guard let nowDateYear = nowDateComponents.year,
            let nowDateMonth = nowDateComponents.month,
            let nowDateDay = nowDateComponents.day,
            let yearsterDateYear = yearsterDateComponents.year,
            let yearsterDateMonth = yearsterDateComponents.month,
            let yearsterDateDay = yearsterDateComponents.day,
            let dynamicDateYear = dynamicDateComponents.year,
            let dynamicDateMonth = dynamicDateComponents.month,
            let dynamicDateDay = dynamicDateComponents.day else {
                return nil
        }

        if dynamicDateYear == nowDateYear {
            if dynamicDateYear == nowDateYear
                && dynamicDateMonth == nowDateMonth
                && dynamicDateDay == nowDateDay {
                return "今天"
            }else if dynamicDateYear == yearsterDateYear
                && dynamicDateMonth == yearsterDateMonth
                && dynamicDateDay == yearsterDateDay {
                return "昨天"
            }else{
                return "\(dynamicDateMonth)-\(dynamicDateDay)"
            }
        }else{
            return "\(dynamicDateYear)年"
        }
    }
}

public struct YYDateFormater {
    private static var _dateFormater: YYDateFormater?
    private let kDataFormatter: String = "kDataFormatter"
    private var dateFormatter: DateFormatter?

    public static var share: YYDateFormater {
        if _dateFormater == nil {
            _dateFormater = YYDateFormater()
        }

        return _dateFormater!
    }

    private init() {
        var thredDictionary: [String : DateFormatter]? = Thread.current.threadDictionary as? [String : DateFormatter]

        var _dataFormatter: DateFormatter? = thredDictionary?[kDataFormatter]
        if _dataFormatter == nil {
            _dataFormatter = DateFormatter()
            let timeZone: TimeZone = TimeZone(identifier: "UTC")!
            _dataFormatter!.timeZone = timeZone
            _dataFormatter!.dateStyle = .medium
            _dataFormatter!.timeStyle = .none
            _dataFormatter!.locale = Locale.current

            thredDictionary?[kDataFormatter] = _dataFormatter!
            dateFormatter = _dataFormatter
        }else{
            dateFormatter = _dataFormatter
        }
    }

    public func absoluteTimeToDateTimeString(timeInterval: TimeInterval) -> String? {
        let date = Date(timeIntervalSinceReferenceDate: timeInterval)
        dateFormatter?.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return dateFormatter?.string(from: date)
    }

    public func dateFromYMD(with dataStr: String) -> Date? {
        dateFormatter?.dateFormat = "YYYY-MM-dd"
        return dateFormatter?.date(from: dataStr)
    }

    public func dataToString(with date: Date,
                             dateFormat: String = "YYYY_MM_dd") -> String? {
        dateFormatter?.dateFormat = dateFormat
        return dateFormatter?.string(from: date)
    }

    public func dateToStringDay(timeInterval: TimeInterval) -> String {
        return timeDistanceWitholdTime(timeInterval: timeInterval)
    }

    public func timeDistanceWitholdTime(timeInterval: TimeInterval, withAllowFuture allowFuture:Bool = true) -> String {
        let oldTime = timeInterval

        //获取当前系统时间
        let date = Date().timeIntervalSince1970

        var timedis = date - oldTime
        timedis = (!allowFuture && timedis < 0) ? 0 : timedis

        //几秒前
        if timedis < 60 {
            return "刚刚"
        }

        //X分钟前
        if timedis / 60 < 60 {
            return String(format: "%d", Int((timedis / 60))) + "分钟前"
        }else if(timedis / 60 / 60 < 24) {
            return String(format: "%d", Int((timedis / 60 / 60))) + "小时前"
        }else if (timedis / 60 / 60 / 24 <= 7) {
            return String(format: "%d", Int((timedis / 60 / 60 / 24))) + "天前"

        }else {
            let detaildate = Date(timeIntervalSince1970: timeInterval)
            let dateFormatter = DateFormatter()
            let timeZone: TimeZone? = TimeZone(identifier: "UTC")

            dateFormatter.timeZone = timeZone
            dateFormatter.dateFormat = "yyyy"

            //当前年份
            let nowYear = dateFormatter.string(from: Date())

            let oldYear = dateFormatter.string(from: detaildate)

            if nowYear.compare(oldYear) == .orderedSame {
                dateFormatter.dateFormat = "M月d日"
            }else{
                dateFormatter.dateFormat = "yyyy年M月d日"
            }

            return dateFormatter.string(from: detaildate)
        }
    }

}
