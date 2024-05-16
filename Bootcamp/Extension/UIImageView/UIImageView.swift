//
//  UIImage.swift
//  Bootcamp
//
//  Created by Umut Yüksel on 10.05.2024.
//

import Foundation
import UIKit
import Photos

extension UIImageView {
    
    func setImageFromPHAsset(_ asset: PHAsset) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true // Senkron bir istek yapar
        options.deliveryMode = .highQualityFormat // Yüksek kalitede resim ister

        // Fotoğrafın orijinal boyutunu almak için options'ları ayarla
        let targetSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)

        manager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { (image, _) in
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}
