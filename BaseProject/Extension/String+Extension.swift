//
//  String+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import CommonCrypto

public extension String {
    
    static func stringWithUTFCharacter(UTFCharacter: UTF32Char) -> String {
        if (UTFCharacter & 0xFFFF0000) != 0 {
            return stringWithUTF32Char(char32: UTFCharacter)
        } else {
            return stringWithUTF16Char(char16: UTF16Char(UTFCharacter & 0xFFFF))
        }
    }
    
    static func stringWithUTF32Char(char32: UTF32Char) -> String {
        var char32 = char32
        char32 -= 0x10000
        var highSurrogate:UniChar = UniChar(char32 >> 10)
        highSurrogate += 0xD800
        var lowSurrogate = char32 & 0x3FF
        lowSurrogate += 0xDC00
        
        return String(utf16CodeUnits: [highSurrogate, lowSurrogate] as! [unichar], count: 2)
    }
    
    static func stringWithUTF16Char(char16: UTF16Char) -> String {
        return String(utf16CodeUnits: [char16], count: 1)
    }
}

public extension String {
    
    /// 去除字符串前后空格
    var trimed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// 是否为空(仅有空格也属于空)
    var isEmpty: Bool {
        return trimed.count == 0
    }
    
    /// 是否不为空
    var isNotEmpty: Bool {
        return trimed.count > 0
    }
    
    /// 获取指定范围的内容
    func substring(fromIndex minIndex: Int, toIndex maxIndex: Int) -> String {
        let start = index(startIndex, offsetBy: minIndex)
        let end = index(startIndex, offsetBy: maxIndex, limitedBy: endIndex)
        
        let range = start ..< end!
        return String(self[range])
    }
    
    /// 获取指定长度的内容
    func substring(fromIndex from: Int, length: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: length)
        
        let range = start ..< end
        return String(self[range])
    }
    
    /// 获取指定索引之后的内容
    /// - parameter minIndex: 指定的索引位置
    func substring(minIndex min: Int) -> String {
        let start = index(startIndex, offsetBy: min)
        return String(self[start...])
    }
    
    /// 获取指定索引之前的内容
    /// - parameter maxIndex: 指定的索引位置
    func substring(maxIndex max: Int) -> String {
        var index = max
        if index >= self.count {
            index = self.count - 1
        }
        return substring(fromIndex: 0, toIndex: max)
    }
    
    /// 获取Bool值
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    
    /// 是否是Double类型
    func isDouble() -> Bool {
        let scan = Scanner(string: self)
        var val:Double = 0.0
        // 扫描的内容符合Double格式内容,并且已扫描到内容的末尾
        return scan.scanDouble(&val) && scan.isAtEnd
    }
    
    /// 是否是Float类型
    func isFloat() -> Bool {
        let scan = Scanner(string: self)
        var val:Float = 0.0
        // 扫描的内容符合Float格式内容,并且已扫描到内容的末尾
        return scan.scanFloat(&val) && scan.isAtEnd
    }
    
    /// 是否是Int类型
    func isInt() -> Bool {
        let scan = Scanner(string: self)
        var val:Int = 0
        // 扫描的内容符合Int格式内容,并且已扫描到内容的末尾
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    /// 是否包含英文字符,仅限:[A-Za-z]
    ///
    /// 也可用于匹配密码是否符合要求,可通过符合条件的count来做比较(数字+英文的可结合isContainNumber()函数)
    func isContainLetter() -> Bool {
        var result = false
        do {
            let regular = try NSRegularExpression(pattern: "[A-Za-z]", options: NSRegularExpression.Options.caseInsensitive)
            let count = regular.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: self.count))
            result = count > 0
        } catch {
            print("Regular expression error!!")
        }
        return result
    }
    
    /// 是否包含英文字符,仅限:[A-Za-z]
    ///
    /// 也可用于匹配密码是否符合要求,可通过符合条件的count来做比较(数字+英文的可结合isContainLetter()函数)
    func isContainNumber() -> Bool {
        var result = false
        do {
            let regular = try NSRegularExpression(pattern: "[0-9]", options: NSRegularExpression.Options.caseInsensitive)
            let count = regular.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: self.count))
            result = count > 0
        } catch {
            print("Regular expression error!!")
        }
        return result
    }
    
    /// 获取字符占位数
    ///
    /// 英文(半角)字符占位: 1
    ///
    /// 中文(全角)字符占位: 2
    ///
    /// 表情占位: 3
    func numberOfChars() -> Int {
        var number = 0
        guard self.count > 0 else {
            return number
        }
        for i in 0..<self.count {
            let c: unichar = (self as NSString).character(at: i)
            if (c >= 0x4E00) {
                number += 2
            } else {
                number += 1
            }
        }
        return number
    }
}


//MARK: -
public extension String {
    
    /// 根据字体和画布宽度,计算文字在画布上的Size
    /// - parameter font: 字体大小
    /// - parameter width: 限制的宽度
    func layoutSize(font: UIFont, preferredMaxLayoutWidth width: CGFloat = kScreenWidth) -> CGSize {
        let str = self as NSString
        let size = str.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine],
            attributes: [.font: font],
            context: nil
            ).size
        return size
    }
    
    /// 根据字体和画布高度,计算文字在画布上的宽度
    /// - parameter font: 字体
    /// - parameter height: 限制的高度
    func textWidth(font: UIFont, height: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.width)
    }
    
    /// 根据字体和画布宽度,计算文字在画布上的高度
    /// - parameter font: 字体
    /// - parameter width: 限制的宽度
    func textHeight(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.height)
    }
    
    /// 将数组各个内容结合给定字符拼接后返回
    /// - parameter keys: 字符串数组
    /// - parameter separator: 需要拼接的字符
    func regularPattern(_ keys: [String], separator: String) -> String {
        return String(format: "%@", keys.joined(separator: separator))
    }
    
    /// 查询数组中有哪些key,被包含在当前字符中
    /// - parameter keys: 需要查找的字符串数组
    /// - returns: 返回符合的key和范围
    ///
    /// 符合的范围可通过NSValue的rangeValue属性.来获取具体的Range值
    func rangeRegularPattern(_ keys: [String]) -> [(String,NSValue)] {
        let templetStr = self as NSString
        var resultList: [(String,NSValue)] = []
        if templetStr.length > 0 {
            for value in keys {
                let includeRange = templetStr.range(of: value)
                if includeRange.location != NSNotFound {
                    resultList.append((value,NSValue(range: includeRange)))
                }
            }
        }
        return resultList
    }
    
}

extension String {
    func sha1() -> String {
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
}

/**
 *  String/Json互转
 */
extension String {
    
    func convertToDictionary() -> [AnyHashable : Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
