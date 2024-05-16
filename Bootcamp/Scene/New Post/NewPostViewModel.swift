//
//  NewPostViewModel.swift
//  Bootcamp
//
//  Created by Umut Yüksel on 3.05.2024.
//

import Foundation
import UIKit
import Photos


struct NewPostViewModel{
    
    var selectableImages = [PHAsset]()
    var selectablePhotos = [SelectablePhoto]()
    var selectedAssets = [PHAsset]()
    var isAspectFit = true
    var imageManager = PHCachingImageManager()
}
