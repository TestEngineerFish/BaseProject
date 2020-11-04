//
//  BPPhotoAlbumToolsView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/4.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

protocol BPPhotoAlbumToolsDelegate: NSObjectProtocol {
    func clickShareAction()
    func clickSaveAction()
    func clickDeleteAction()
}

class BPPhotoAlbumToolsView: BPView {

    weak var delegate: BPPhotoAlbumToolsDelegate?

    func show() {
        
    }

    func hide() {
        
    }
}
