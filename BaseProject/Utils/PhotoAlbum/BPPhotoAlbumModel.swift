//
//  BPPhotoAlbumModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/10.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper
import Photos

struct BPPhotoAlbumModel: Mappable, Equatable {
    var assets = PHFetchResult<PHAsset>()
    var assetCollection: PHAssetCollection?
    init(collection: PHAssetCollection) {
        self.assetCollection = collection
        self.assets = PHAsset.fetchAssets(in: collection, options: nil)
    }

    init?(map: Map) {}
    mutating func mapping(map: Map) {}
}
