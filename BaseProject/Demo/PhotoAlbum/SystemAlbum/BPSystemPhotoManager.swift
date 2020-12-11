//
//  BPSystemPhotoManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/8.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import AVFoundation
import Photos.PHPhotoLibrary

class BPSystemPhotoManager: BPView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    static let share = BPSystemPhotoManager()
    var completeBlock: DefaultImageBlock?

    func showCamera(complete block:DefaultImageBlock?) {
        BPAuthorizationManager.share.camera { [weak self] (result) in
            guard let self = self, result else { return }
            self.completeBlock = block
            let vc = UIImagePickerController()
            vc.delegate      = self
            vc.allowsEditing = true
            vc.sourceType    = .camera
            UIViewController.currentViewController?.present(vc, animated: true, completion: nil)
        }
    }

    func showPhoto(complete block:DefaultImageBlock?) {
        BPAuthorizationManager.share.photo { [weak self] (result) in
            guard let self = self, result else { return }
            self.completeBlock = block
            let vc = UIImagePickerController()
            vc.delegate      = self
            vc.allowsEditing = true
            vc.sourceType    = .photoLibrary
            UIViewController.currentViewController?.present(vc, animated: true, completion: nil)
        }
    }

    // MARK: ==== UIImagePickerControllerDelegate, UINavigationControllerDelegate ====
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        BPLog("取消选择照片")
        self.completeBlock?(nil)
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.completeBlock?(image)
        BPLog("选择了照片")
        picker.dismiss(animated: true, completion: nil)
    }
}
