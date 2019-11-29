//
//  BPViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPViewController: UIViewController {

    deinit {
        print("控制器释放: " + String(describing: self.classForCoder))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 当使用自定义导航条的时候，左滑返回会消失，在扩展中进行了实现
//        self.navigationController?.delegate = self

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

        useCustomNavigationBar()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        return BPCheckerboardTransitionAnimator()
//    }

    /** 当使用自定义导航条的时候，左滑返回会消失，因此需要实现该方法*/
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.setNavigationBarHidden(true, animated: true)
        } else {

            //系统相册继承自 UINavigationController 这个不能隐藏
            if navigationController.isKind(of: UIImagePickerController.self) {
                return
            }

            //当不显示本页时，要么就push到下一页，要么就被pop了，那么就将delegate设置为nil，防止出现BAD ACCESS
            let name: AnyClass? = (navigationController.delegate as? UIViewController)?.classForCoder
            if name == self.classForCoder {
                //如果delegate是自己才设置为nil，因为viewWillAppear调用的比此方法较早，其他controller如果设置了delegate就可能会被误伤
                navigationController.delegate = nil
            }
        }
    }
}

