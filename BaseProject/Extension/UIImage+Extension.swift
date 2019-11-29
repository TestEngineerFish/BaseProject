//
//  UIImage+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

public extension UIImage {

    class func imageWithColor(_ color: UIColor, width: CGFloat = 1.0, height: CGFloat = 1.0, cornerRadius: CGFloat = 0) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let roundedRect: UIBezierPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        roundedRect.lineWidth = 0
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        roundedRect.fill()
        roundedRect.stroke()
        roundedRect.addClip()
        var image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        image = image?.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))
        return image!
    }


    /// 节约内存的ImageIO缩放
    /// - Parameters:
    ///   - size: 图片尺寸
    ///   - scale: 缩放比例
    ///   - orientation: 图片方向
    func scaledImage(with size: CGSize, scale: CGFloat, orientation: UIImage.Orientation = .up) -> UIImage {
        let maxpixelSize = max(size.width, size.height)
        let options = [kCGImageSourceCreateThumbnailFromImageAlways : kCFBooleanTrue!, kCGImageSourceThumbnailMaxPixelSize : maxpixelSize] as CFDictionary
        let dataOption: Data? = {
            if let data = self.pngData() {
                return data
            } else {
                return self.jpegData(compressionQuality: 1.0)
            }
        }()
        guard let data: CFData = dataOption as CFData?, let sourceRef = CGImageSourceCreateWithData(data, nil), let imageRef = CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, options) else {
            return self
        }
        let resultImage = UIImage(cgImage: imageRef, scale: scale, orientation: orientation)
        return resultImage
    }


    /// 普通的缩放方式
    /// - Parameter newSize: 新图大小
    func scaledImageOld(_ newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
