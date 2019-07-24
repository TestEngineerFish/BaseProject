//
//  String+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import CommonCrypto

/**
 *  IconFont
 */
public extension String {
    public static func iconfont(iconfont: Iconfont) -> String? {
        return "\\u{" + iconfont.rawValue + "}"
    }
    
    public static func stringWithUTFCharacter(UTFCharacter: UTF32Char) -> String {
        if (UTFCharacter & 0xFFFF0000) != 0 {
            return stringWithUTF32Char(char32: UTFCharacter)
        } else {
            return stringWithUTF16Char(char16: UTF16Char(UTFCharacter & 0xFFFF))
        }
    }
    
    public static func stringWithUTF32Char(char32: UTF32Char) -> String {
        var char32 = char32
        char32 -= 0x10000
        var highSurrogate:UniChar = UniChar(char32 >> 10)
        highSurrogate += 0xD800
        var lowSurrogate = char32 & 0x3FF
        lowSurrogate += 0xDC00
        
        return String(utf16CodeUnits: [highSurrogate, lowSurrogate] as! [unichar], count: 2)
    }
    
    public static func stringWithUTF16Char(char16: UTF16Char) -> String {
        return String(utf16CodeUnits: [char16], count: 1)
    }
    
}

//MARK: -
public extension String {
    
    public var trimed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public var isEmpty: Bool {
        return 0 == trimed.count
    }
    
    public var isNotEmpty: Bool {
        return trimed.count > 0
    }
    
    public subscript (rang: Range<Index>) -> String {
        return String(self[rang])
    }
    
    public func substring(fromIndex minIndex: Int, toIndex maxIndex: Int) -> String {
        let start = index(startIndex, offsetBy: minIndex)
        let end = index(startIndex, offsetBy: maxIndex, limitedBy: endIndex)
        
        let rang = start ..< end!
        return String(self[rang])
    }
    
    public func substring(fromIndex minIndex: Int) -> String {
        let start = index(startIndex, offsetBy: minIndex)
        return String(self[start...])
    }
    
    public func substring(toIndex maxIndex: Int) -> String {
        return substring(fromIndex: 0, toIndex: maxIndex)
    }
    
    /** 获取安全的子字符串 */
    public func safeSubstring(toIndex index: Int) -> String {
        var index = index
        if index >= self.count {
            index = self.count - 1
        }
        return substring(toIndex: index)
    }
    
    /** 是否为整数字 */
    func isNumber() -> Bool {
        let scan: Scanner = Scanner(string: self)
        var val:Int = 0
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    /** 是否包括英文字符 */
    func isContainLetter() -> Bool {
        guard self.count > 0 else {
            return false
        }
        
        for i in 0 ... self.count - 1 {
            let c: unichar = (self as NSString).character(at: i)
            if (c >= 0x4E00) { return true }
        }
        
        return false
    }
    
    /** 根据字符串的组成计算字符所占位数 */
    func numberOfChars() -> Int {
        var number = 0
        
        guard self.count > 0 else {
            return 0
        }
        
        for i in 0 ... self.count - 1 {
            let c: unichar = (self as NSString).character(at: i)
            if (c >= 0x4E00) {
                number += 2
            } else {
                number += 1
            }
        }
        
        return number
    }
    
    func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
}

extension String {
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
}


//MARK: -
public extension String {
    
    func layoutSize(font: UIFont, preferredMaxLayoutWidth width: CGFloat = kScreenWidth) -> CGSize {
        let str: NSString = self as NSString
        return str.boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading, .truncatesLastVisibleLine],
            attributes: [.font: font],
            context: nil
            ).size
    }
    
    /**
     * 获取字符串宽度
     * @param font 字体
     * @param height 行高
     */
    func textWidth(font: UIFont, height: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.width)
    }
    
    /**
     * 获取字符串高度
     * @param font 字体
     * @param width 行宽
     */
    func textHeight(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: self).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(rect.height)
    }
    
}

@objc public extension NSString {
    
    @objc func regularPattern(_ keys: [String]) -> String? {
        if keys.count > 0 {
            return String(format: "%@", keys.joined(separator: "|"))
        }
        
        return nil
    }
    
    @objc func rangRegularPattern(_ keys: [String]) -> [NSValue]? {
        if keys.count > 0 && self.length > 0 {
            var _rangRegularPatterns: [NSValue] = []
            for value in keys {
                let _strRange = self.range(of: value)
                if _strRange.location != NSNotFound {
                    _rangRegularPatterns.append(NSValue(range: _strRange))
                }
            }
            
            return _rangRegularPatterns
        }
        
        return nil
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
