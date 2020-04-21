//
//  Date+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
let componentFlags = Set<Calendar.Component>([.day, .month, .year, .hour,.minute,.second,.weekday,.weekdayOrdinal])

public extension Date {
    
    /// 当前系统时间是否是24小时制
    static var checkDateSetting24Hours: Bool {
        var is24Hours: Bool = true
        let dateStr: String = Date().description(with: Locale.current)
        let sysbols: [String] = [Calendar.current.amSymbol, Calendar.current.pmSymbol]
        for symbol in sysbols where dateStr.range(of: symbol) != nil {
            is24Hours = false
            break
        }
        
        return is24Hours
    }

    /// 获取当前时间 (格林威治标准时间)
    static func getCurrentDate() -> Date {
        let date = Date()
        let interval = NSTimeZone.system.secondsFromGMT(for: date)
        return date.addingTimeInterval(TimeInterval(interval))
    }

    /// 系统日历(中国制)
    var calendar: Calendar {
        get{
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale   = Locale(identifier: "zh_CN")
            calendar.timeZone = TimeZone(identifier: "UTC")!
            return calendar
        }
    }

    /// 系统当前年(中国制)
    var year: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.year!
        }
    }

    /// 系统当前月(中国制)
    var month: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.month!
        }
    }

    /// 系统当前天(中国制)
    var day: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.day!
        }
    }

    /// 系统当前小时(中国制)
    var hour: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.hour!
        }
    }

    /// 系统当前分钟(中国制)
    var minute: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.minute!
        }
    }

    /// 系统当前秒(中国制)
    var second: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.second!
        }
    }

    /// 返回当前系统日期字符串,格式:年-月-日 时:分:秒
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }

    /// 字符串转成制定格式的日期(中国制)
    func date(datestr: String, format: String) -> Date? {
        let fmt = DateFormatter()
        fmt.locale     = Locale(identifier: "zh_CN")
        fmt.timeZone   = TimeZone(identifier: "UTC")
        fmt.dateFormat = format
        let date = fmt.date(from: datestr)
        return date
    }

    /// 根据指定格式,返回系统时间(中国制)
    /// e.g. "YYYY-MM-dd HH:mm:ss" 年-月-日 时:分:秒
    func dateWithFormatter(formatter: String) -> Date? {
        let fmt = DateFormatter()
        fmt.locale     = Locale(identifier: "zh_CN")
        fmt.timeZone   = TimeZone(identifier: "UTC") //TimeZone(secondsFromGMT: +28800)!
        fmt.dateFormat = formatter
        let selfStr    = fmt.string(from: self)
        return fmt.date(from: selfStr)
    }

    /// 根据间隔时间,获得与当前系统时间间隔的时间值.
    /// 返回类型如下:
    ///
    ///     [calendar: gregorian (current) year: 0 month: 0 day: 0 hour: -1 minute: 0 second: 0 weekday: 0 isLeapMonth: false]
    ///
    /// - parameter second: 与当前系统时间间隔的秒数,如果是负数,则返回也是相应的负数时间
    static func dateComponentFrom(second: Double) -> DateComponents {
        let interval = TimeInterval(second)
        let date1 = Date()
        let date2 = Date(timeInterval: interval, since: date1)
        let c = NSCalendar.current
        
        var components = c.dateComponents([.year,.month,.day,.hour,.minute,.second,.weekday], from: date1, to: date2)
        components.calendar = c
        return components
    }
}

extension Date {

    /// 根据时间获取年龄
    func age() -> Int {
        let components: Set<Calendar.Component> = Set(arrayLiteral: .year, .month, .day)

        // 出生日期转换 年月日
        let componentsUser = Calendar.current.dateComponents(components, from: self)
        let brithDateYear  = componentsUser.year  ?? 0
        let brithDateDay   = componentsUser.day   ?? 0
        let brithDateMonth = componentsUser.month ?? 0

        // 获取系统当前 年月日
        let componentsSystem = Calendar.current.dateComponents(components, from: Date())
        let currentDateYear  = componentsSystem.year  ?? 0
        let currentDateDay   = componentsSystem.day   ?? 0
        let currentDateMonth = componentsSystem.month ?? 0

        // 计算年龄
        var iAge: Int = currentDateYear - brithDateYear - 1
        if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
            iAge = iAge + 1
        }

        return iAge
    }
}
