//
//  SelectedImages.swift
//  Bootcamp
//
//  Created by Umut Yüksel on 3.05.2024.
//

import Foundation
import Photos

class SelectablePhoto {
    
    var asset : PHAsset
    var isSelected : Bool = false
    var isHighlighted : Bool = false
    
    init(asset: PHAsset) {
        self.asset = asset
    }
}
