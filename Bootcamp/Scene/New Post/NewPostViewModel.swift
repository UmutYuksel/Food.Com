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
    var selectedAssets = [PHAsset]()
    var imageManager = PHCachingImageManager()
    var croppedImages = [UIImage]()
    
    
}
