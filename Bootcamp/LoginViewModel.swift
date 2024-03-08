//
//  LoginViewModel.swift
//  Food.Com
//
//  Created by Umut Yüksel on 8.03.2024.
//

import Foundation
import UIKit

struct LoginViewModel {
    
    let wikiCellimages = [UIImage(named: "wikiImage1.jpeg"),UIImage(named: "wikiImage2.jpeg")]
    
    func prepareButtons(signIn : UIButton , signUp : UIButton) {
        signUp.layer.borderColor = UIColor(named: "tintColor")?.cgColor
        signUp.layer.borderWidth = 2.0
        signIn.tintColor = UIColor(named: "tintColor")
        signIn.backgroundColor = UIColor(named: "tintColor")
    }
    
    
    func prepareWikiCellImage(_ image: UIImage?) -> UIImage? {
        guard let image = image else { return nil }
        let size = image.size
        UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
        defer { UIGraphicsEndImageContext() }
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        image.draw(at: .zero)
        
        // Gradient rengi ve konumu
        let colors = [UIColor(white: 0.0, alpha: 0.0).cgColor, UIColor(white: 1.0, alpha: 1.0).cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0, 0.8]
        
        // Gradient oluştur
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations) else { return nil }
        
        // İşlem yapılacak alan
        let startPoint = CGPoint(x: size.width / 2, y: 0)
        let endPoint = CGPoint(x: size.width / 2, y: size.height)
        
        // Gradient çiz
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        // İşlenmiş görüntüyü al
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return gradientImage
    }
}
