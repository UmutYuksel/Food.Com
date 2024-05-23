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
    
    func croppedImage(using scrollView: UIScrollView) -> UIImage? {
            guard let image = self.image else { return nil }
            
            // ScrollView'ın scale'ini al
            let scale = image.size.width / self.bounds.width
            
            // ScrollView'ın content offset'ini al ve scale'e göre ayarla
            let visibleRect = CGRect(
                x: scrollView.contentOffset.x * scale,
                y: scrollView.contentOffset.y * scale,
                width: scrollView.bounds.width * scale,
                height: scrollView.bounds.height * scale
            )
            
            // UIImage'ı crop et
            guard let cgImage = image.cgImage?.cropping(to: visibleRect) else { return nil }
            let croppedImage = UIImage(cgImage: cgImage)
            
            return croppedImage
        }
}
