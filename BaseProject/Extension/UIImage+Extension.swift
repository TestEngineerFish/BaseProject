//
//  UIImage+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import ImageIO

public extension UIImage {
    
    private class YYIconFont: NSObject {
        var code:String       //标准解析格式 比如："\u{a62b}"
        var name:String       //图标的名字.一般为中文，比如：设置
        var descr:String!     //图标作用和备注
        var labelText:String! //可以直接赋值给UILabel,以系统字体大小为基准
        var iconImage:UIImage!//生成一个一般的iconImge  如果需要其他大小的可以自己调整， 使用第二个初始化中代码段。
        
        ///初始化图标
        /// - important : fontsize可通过外部font的size调整,而且必须设置UILabel的font,否则无法正常显示。比如：
        /// - label.font = UIFont.init(name: "IconFont", size: UIFont.systemFontSize)
        /// - parameter code: 标准解析格式，比如："\u{a62b}"
        /// - parameter name:图标的中文名
        init(code:String, name:String) {
            self.code = code
            self.name = name
            //为UILabel使用的做准备
            let label = UILabel()
            
            label.text = code
            self.labelText = label.text
        }
        
        ///初始化图标 ,图片可用
        /// - important :图片大小由iconFont的fontSize自动计算决定。建议UIImageView大小参考打印值,这样的图片显示效果是最好的。
        /// - parameter code: 标准解析格式，比如："\u{a62b}"
        /// - parameter name:图标的中文名
        /// - parameter fontSize:图标（字体大小）
        /// - parameter color:图标的颜色
        convenience init(code:String, name:String, fontSize:CGFloat, color:UIColor){
            self.init(code: code, name: name)
            //计算文本rect
            let nscode = code as NSString
            let rect = nscode.boundingRect(with:CGSize(width: 0.0, height: 0.0) , options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.iconfont(ofSize: fontSize)!], context: nil)
            let size = rect.size
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            label.font =  UIFont.iconfont(ofSize: fontSize)
            label.textAlignment = .center
            label.textColor = color
            label.text = code
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            label.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            self.iconImage = image
        }
        
        ///直接生成该图标的UIImage 对象
        /// - important :图片大小由iconFont的fontSize自动计算决定。建议UIImageView大小参考打印值,这样的图片显示效果是最好的。
        /// - parameter fontSize:图标（字体大小）
        /// - parameter color:图标的颜色
        func iconFontImage(fontSize:CGFloat, color:UIColor) -> UIImage {
            let nscode = code as NSString
            let rect = nscode.boundingRect(with:CGSize(width: 0.0, height: 0.0) , options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : UIFont.iconfont(ofSize: fontSize)!], context: nil)
            let size = rect.size
            
            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            label.font = UIFont.iconfont(ofSize: fontSize)!
            label.textAlignment = .center
            label.text = code
            label.textColor = color
            label.layer.render(in: UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image!
        }
    }
    
    
    public convenience init(iconfont code:String,fontSize:CGFloat, color:UIColor){
        let iconImage = YYIconFont(code: code, name: "", fontSize: fontSize, color: color).iconImage
        let iconData:Data = iconImage!.pngData() ?? (iconImage!.jpegData(compressionQuality: 1.0))!
        self.init(data: iconData)!
    }
    
    private convenience init?(text: Iconfont, fontSize: CGFloat, imageSize: CGSize = CGSize.zero, imageColor: UIColor = UIColor.black) {
        guard let iconfont = UIFont.newIconFont(size: fontSize) else {
            self.init()
            return nil
        }
        var imageRect = CGRect(origin: CGPoint.zero, size: imageSize)
        if __CGSizeEqualToSize(imageSize, CGSize.zero) {
            imageRect = CGRect(origin: CGPoint.zero, size: text.rawValue.size(withAttributes: [NSAttributedString.Key.font: iconfont]))
        }
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, 1.0)
        defer {
            UIGraphicsEndImageContext()
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        text.rawValue.draw(in: imageRect, withAttributes: [NSAttributedString.Key.font : iconfont, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: imageColor])
        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return nil
        }
        self.init(cgImage: cgImage)
    }
}


public extension UIImage {
    
    @objc class func imageWithColor(_ color: UIColor, height: CGFloat = 1.0) -> UIImage {
        return self.imageWithColor(color, width: 1.0, height: height)
    }
    
    @objc class func imageWithColor(_ color: UIColor, width: CGFloat = 1.0, height: CGFloat = 1.0) -> UIImage {
        return self.imageWithColor(color, width: width, height: height, cornerRadius: 0.0)
    }
    
    @objc class func imageWithColor(_ color: UIColor, width: CGFloat = 1.0, height: CGFloat = 1.0, cornerRadius: CGFloat = 0) -> UIImage {
        
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
}


public extension UIImage {
    
    /** 裁剪出的图片尺寸按照size的尺寸，但图片不拉伸，但多余部分会被裁减掉 */
    func thumbnail(with originalImage: UIImage?, define defineSize: CGSize) -> UIImage? {
        
        let originalSize: CGSize? = originalImage?.size
        
        // 原图长宽均小于标准长宽的，不作处理返回原图
        if (originalSize?.width ?? 0.0) < defineSize.width && (originalSize?.height ?? 0.0) < defineSize.height {
            return originalImage
            // 原图长宽均大于标准长宽的，按比例缩小至最大适应值
        } else if (originalSize?.width ?? 0.0) > defineSize.width && (originalSize?.height ?? 0.0) > defineSize.height {
            
            var rate: CGFloat = 1.0
            let widthRate: CGFloat = (originalSize?.width ?? 0.0) / defineSize.width
            let heightRate: CGFloat = (originalSize?.height ?? 0.0) / defineSize.height
            rate = widthRate > heightRate ? heightRate : widthRate
            
            var imageRef: CGImage? = nil
            if heightRate > widthRate {
                // 获取图片整体部分
                imageRef = originalImage?.cgImage?.cropping(to: CGRect(x: 0, y: (originalSize?.height ?? 0.0) / 2 - defineSize.height * rate / 2, width: originalSize?.width ?? 0.0, height: defineSize.height * rate))
            } else {
                imageRef = originalImage?.cgImage?.cropping(to: CGRect(x: (originalSize?.width ?? 0.0) / 2 - defineSize.width * rate / 2, y: 0, width: defineSize.width * rate, height: originalSize?.height ?? 0.0))
            }
            
            return image(withDefine: defineSize, imageRef: imageRef)
            
            // 原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
        } else if (originalSize?.height ?? 0.0) > defineSize.height || (originalSize?.width ?? 0.0) > defineSize.width {
            
            var imageRef: CGImage? = nil
            if (originalSize?.height ?? 0.0) > defineSize.height {
                imageRef = originalImage?.cgImage?.cropping(to: CGRect(x: 0, y: (originalSize?.height ?? 0.0) / 2 - defineSize.height / 2, width: originalSize?.width ?? 0.0, height: defineSize.height))
            } else if (originalSize?.width ?? 0.0) > defineSize.width {
                imageRef = originalImage?.cgImage?.cropping(to: CGRect(x: (originalSize?.width ?? 0.0) / 2 - defineSize.width / 2, y: 0, width: defineSize.width, height: originalSize?.height ?? 0.0))
            }
            return image(withDefine: defineSize, imageRef: imageRef)
        } else {
            // 原图为标准长宽，不做处理
            return originalImage
        }
        
    }
    
    /** 根据给定的size来裁剪图片 */
    func image(withDefine defineSize: CGSize, imageRef: CGImage?) -> UIImage? {
        /** 指定要绘画图片的大小
         *  【注意】：这里不要使用` UIGraphicsBeginImageContext(viewsize);`方法
         *  开始上下文(NO == 透明, 0.0 == 默认做法)，不设置是否透明的时候，默认为不透明
         *  会导致切割的图片很模糊！
         */
        UIGraphicsBeginImageContextWithOptions(defineSize, _: false, _: 0.0)
        let con = UIGraphicsGetCurrentContext()
        con?.translateBy(x: 0.0, y: defineSize.height)
        con?.scaleBy(x: 1.0, y: -1.0)
        con?.draw(imageRef!, in: CGRect(x: 0, y: 0, width: defineSize.width, height: defineSize.height))
        
        let standardImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        print("####改变后图片的宽度为%f,图片的高度为%f\n", standardImage?.size.width, standardImage?.size.height)
        
        return standardImage
    }
    
    // 将图片缩放成指定尺寸（多余部分自动删除）
    func scaled(to newSize: CGSize) -> UIImage {
        //计算比例
        let aspectWidth  = newSize.width/size.width
        let aspectHeight = newSize.height/size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        //图片绘制区域
        var scaledImageRect = CGRect.zero
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        // 绘制并获取最终图片，去除透明通道，增强图片的清晰度
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    // 将图片裁剪成指定比例（多余部分自动删除）
    func crop(ratio: CGFloat) -> UIImage {
        //计算最终尺寸
        var newSize:CGSize!
        if size.width/size.height > ratio {
            newSize = CGSize(width: size.height * ratio, height: size.height)
        }else{
            newSize = CGSize(width: size.width, height: size.width / ratio)
        }
        
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
        
        // 绘制并获取最终图片
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage? {
        let _: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(Double.pi))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(Double.pi)
        }
        
        let rotatedViewBox = UIView(frame: CGRect(origin: .zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        let _bitmap = UIGraphicsGetCurrentContext()
        guard let bitmap = _bitmap else {
            return self
        }
        
        bitmap.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
        bitmap.rotate(by: degrees)
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap.scaleBy(x: yFlip, y: -1.0)
        bitmap.draw(self.cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
