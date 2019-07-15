//
//  Data+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
let componentFlags = Set<Calendar.Component>([.day, .month, .year, .hour,.minute,.second,.weekday,.weekdayOrdinal])

public extension Date {
    
    /**
     *  当前系统小时制
     */
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
    
    func date(datestr: String, format: String) -> Date {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "zh_CN")
        fmt.timeZone = TimeZone(identifier: "UTC")
        fmt.dateFormat = format
        let date = fmt.date(from: datestr)
        return date!
    }
    
    var year: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.year!
        }
    }
    
    var day: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.day!
        }
    }
    
    var month: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.month!
        }
    }
    
    var calendar: Calendar {
        get{
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: "zh_CN")
            calendar.timeZone = TimeZone(identifier: "UTC")!
            return calendar
        }
    }
    
    var hour: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.hour!
        }
    }
    
    var minute: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.minute!
        }
    }
    
    var second: Int {
        get{
            let components = calendar.dateComponents(componentFlags, from: self)
            return components.second!
        }
    }
    
    func dateWithFormatter(formatter: String) -> Date {
        let fmt = DateFormatter()
        fmt.locale = Locale(identifier: "zh_CN")
        fmt.timeZone = TimeZone(identifier: "UTC") //TimeZone(secondsFromGMT: +28800)!
        fmt.dateFormat = formatter
        let selfStr = fmt.string(from: self)
        return fmt.date(from: selfStr)!
    }
    
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
    static let Format_YYYY_MM_dd = "YYYY-MM-dd"
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.Format_YYYY_MM_dd
        return formatter.string(from: self)
    }
}

extension Date {
    
    /** 获取当前时间 */
    public static func getCurrentDate() -> Date {
        let date = Date()
        let interval: Int = NSTimeZone.system.secondsFromGMT(for: date)
        return date.addingTimeInterval(TimeInterval(interval))
    }
    
    /** 根据时间获取年龄 */
    func age() -> Int {
        let components: Set<Calendar.Component> = Set(arrayLiteral: .year, .month, .day)
        
        // 出生日期转换 年月日
        let components1 = Calendar.current.dateComponents(components, from: self)
        let brithDateYear  = components1.year ?? 0
        let brithDateDay   = components1.day ?? 0
        let brithDateMonth = components1.month ?? 0
        
        // 获取系统当前 年月日
        let components2 = Calendar.current.dateComponents(components, from: Date())
        let currentDateYear  = components2.year ?? 0
        let currentDateDay   = components2.day ?? 0
        let currentDateMonth = components2.month ?? 0
        
        // 计算年龄
        var iAge: Int = currentDateYear - brithDateYear - 1
        if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
            iAge = iAge + 1
        }
        
        return iAge
    }
    
}
