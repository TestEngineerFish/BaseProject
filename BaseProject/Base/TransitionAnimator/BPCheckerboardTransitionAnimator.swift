//
//  BPCheckerboardTransitionAnimator.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/26.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPCheckerboardTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 3.0
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        // 获得两边VC
        //
        // 1、用于获得内View视图
        // 2、用于获取框架Frame
        // 3、用于判断是前进还是后退
        guard let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController   = transitionContext.viewController(forKey: .to)
            else {
                return
        }

        // 过渡视图
        // 过渡容器视图,包含所有参与动画的子视图
        let containerView = transitionContext.containerView

//        let showView = UIView(frame: containerView.bounds)
//        showView.backgroundColor = UIColor.orange1
//        containerView.addSubview(showView)
//        UIView.animate(withDuration: 3, animations: {
//            showView.backgroundColor = UIColor.red1
//        }) { (finished) in
//            if finished {
//                showView.removeFromSuperview()
//            }
//        }
//        return

        // 获得两边View
        var _fromView: UIView?
        var _toView:   UIView?
        if transitionContext.responds(to: #selector(transitionContext.view(forKey:))) {
            _fromView = transitionContext.view(forKey: .from)
            _toView   = transitionContext.view(forKey: .to)
        } else {
            _fromView = fromViewController.view
            _toView   = toViewController.view
        }
        guard let fromView = _fromView, let toView = _toView else {
            return
        }

        // 判断是向前跳转还是向后返回
        let toVCStackIndex: Int   = toViewController.navigationController?.viewControllers.firstIndex(of: toViewController) ?? 0
        let fromVCStackIndex: Int = fromViewController.navigationController?.viewControllers.firstIndex(of: fromViewController) ?? 0
        let isPush = toVCStackIndex > fromVCStackIndex

        // 获取两边视图的位置和大小
        fromView.frame = transitionContext.initialFrame(for: fromViewController)
        toView.frame   = transitionContext.initialFrame(for: toViewController)

        // 添加目标视图到过度视图中
        containerView.addSubview(toView)

        // 获得两边屏幕快照
        let fromViewSnapshot: UIImage?
        var toViewSnpshot: UIImage?

        // Snapshot the fromView
        UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, true, kWindow.screen.scale)
        fromView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: false)
        fromViewSnapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Snapshot the toView
        DispatchQueue.main.async {
            UIGraphicsBeginImageContextWithOptions(containerView.bounds.size, true, kWindow.screen.scale)
            toView.drawHierarchy(in: containerView.bounds, afterScreenUpdates: false)
            toViewSnpshot = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }

        // 添加过渡容器视图,到过渡视图
        let transitionContainer = UIView(frame: containerView.bounds)
        transitionContainer.isOpaque = true
        transitionContainer.backgroundColor = UIColor.black
        containerView.addSubview(transitionContainer)

        // 过渡容器视图添加3D动画效果
        var transfrom3D = CATransform3DIdentity
        transfrom3D.m34 = 1.0 / -900.0
        transitionContainer.layer.sublayerTransform = transfrom3D
        // 设置切片的大小
        let sliceSize        = round(transitionContainer.frame.width / 10.0)
        // 设置水平显示方块数
        let horizontalSlices = ceil(transitionContainer.frame.width / sliceSize)
        // 设置垂直显示方块数
        let verticalSlices   = ceil(transitionContainer.frame.height / sliceSize)
        // 设置切片的动画时长
        let transitionSpacing  = CGFloat(160)
        let transitionDuration = self.transitionDuration(using: transitionContext)

        var transitionVector: CGVector!
        if isPush {
            // ?? 直接获取 transitionContrainer.bounds.width 不好吗?
            let dx = transitionContainer.bounds.maxX - transitionContainer.bounds.minX
            let dy = transitionContainer.bounds.maxY - transitionContainer.bounds.minY
            transitionVector = CGVector(dx: dx, dy: dy)
        } else {
            let dx = transitionContainer.bounds.minX - transitionContainer.bounds.maxX
            let dy = transitionContainer.bounds.minY - transitionContainer.bounds.maxY
            transitionVector = CGVector(dx: dx, dy: dy)
        }

//        let transitionVectorAmount = CGFloat(powf(Float(transitionVector!.dx), 2) + powf(Float(transitionVector!.dy), 2))
        let transitionVectorLength = sqrtf(Float(transitionVector.dx * transitionVector.dx + transitionVector.dy * transitionVector.dy))
        let transitionUnitVector   = CGVector(dx: transitionVector.dx / CGFloat(transitionVectorLength), dy: transitionVector.dy / CGFloat(transitionVectorLength))

        for y in 0..<Int(verticalSlices) {
            for x in 0..<Int(horizontalSlices) {

                let contentLayerFrame = CGRect(x: CGFloat(x) * sliceSize * -1.0, y: CGFloat(y) * sliceSize * -1.0, width: containerView.bounds.size.width, height: containerView.bounds.size.height)

                let fromContentLayer = CALayer()
                fromContentLayer.frame = contentLayerFrame
                fromContentLayer.rasterizationScale = fromViewSnapshot?.scale ?? 1.0
                fromContentLayer.contents           = fromViewSnapshot?.cgImage

                let toContentLayer = CALayer()
                toContentLayer.frame = contentLayerFrame
                DispatchQueue.main.async {
                    let wereActionDisabled = CATransaction.disableActions()
                    CATransaction.setDisableActions(true)
                    toContentLayer.rasterizationScale = toViewSnpshot?.scale ?? 1.0
                    toContentLayer.contents           = toViewSnpshot?.cgImage
                    CATransaction.setDisableActions(wereActionDisabled)
                }

                let toCheckboardSquareView = UIView()
                toCheckboardSquareView.frame               = CGRect(x: CGFloat(x) * sliceSize, y: CGFloat(y) * sliceSize, width: sliceSize, height: sliceSize)
                toCheckboardSquareView.isOpaque            = false
                toCheckboardSquareView.layer.masksToBounds = true
                toCheckboardSquareView.layer.isDoubleSided = false
                toCheckboardSquareView.layer.transform     = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
                toCheckboardSquareView.layer.addSublayer(toContentLayer)

                let fromCheckboardSquareView = UIView()
                fromCheckboardSquareView.frame               = CGRect(x: CGFloat(x) * sliceSize, y: CGFloat(y) * sliceSize, width: sliceSize, height: sliceSize)
                fromCheckboardSquareView.isOpaque            = false
                fromCheckboardSquareView.layer.masksToBounds = true
                fromCheckboardSquareView.layer.isDoubleSided = false
                fromCheckboardSquareView.layer.transform     = CATransform3DIdentity
                fromCheckboardSquareView.layer.addSublayer(fromContentLayer)

                transitionContainer.addSubview(toCheckboardSquareView)
                transitionContainer.addSubview(fromCheckboardSquareView)
            }
        }

        var sliceAnimationsPending = 0
        for y in 0..<Int(verticalSlices) {
            for x in 0..<Int(horizontalSlices) {

                let toIndex   = y * Int(horizontalSlices) * 2 + (x * 2)
                let fromIndex = y * Int(horizontalSlices) * 2 + (x * 2 + 1)
                let toCheckboardSquareView   = transitionContainer.subviews[toIndex]
                let fromCheckboardSquareView = transitionContainer.subviews[fromIndex]

                var sliceOriginVector: CGVector!
                if isPush {
                    let dx = fromCheckboardSquareView.frame.minX - transitionContainer.bounds.minX
                    let dy = fromCheckboardSquareView.frame.minY - transitionContainer.bounds.minY
                    sliceOriginVector = CGVector(dx: dx, dy: dy)
                } else {
                    let dx = fromCheckboardSquareView.frame.maxX - transitionContainer.bounds.maxX
                    let dy = fromCheckboardSquareView.frame.maxY - transitionContainer.bounds.maxY
                    sliceOriginVector = CGVector(dx: dx, dy: dy)
                }

                let dot = sliceOriginVector.dy * transitionVector.dx + sliceOriginVector.dy * transitionVector.dy
                let dx = transitionUnitVector.dx * dot / CGFloat(transitionVectorLength)
                let dy = transitionUnitVector.dy * dot / CGFloat(transitionVectorLength)
                let projection = CGVector(dx: dx, dy: dy)

//                let projectionAmount = powf(Float(projection.dx), 2) + powf(Float(projection.dy), 2)
                let projectionLength = sqrtf(Float(projection.dx * projection.dx) + Float(projection.dy * projection.dy))

                let startTime = projectionLength / (transitionVectorLength + Float(transitionSpacing)) * Float(transitionDuration)
                let duration  = ((projectionLength + Float(transitionSpacing)) / (transitionVectorLength + Float(transitionSpacing)) * Float(transitionDuration)) - startTime
                sliceAnimationsPending += 1

                // 开始显示动画
                UIView.animate(withDuration: Double(duration), delay: Double(startTime), options: UIView.AnimationOptions(rawValue: 0), animations: {
                    toCheckboardSquareView.layer.transform   = CATransform3DIdentity
                    fromCheckboardSquareView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
                }) { (finished) in
                    if sliceAnimationsPending == 1 {
                        let wasConcelled = transitionContext.transitionWasCancelled
                        transitionContainer.removeFromSuperview()
                        transitionContext.completeTransition(!wasConcelled)
                    }
                }
            }
        }

    }
}
