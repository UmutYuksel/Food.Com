//
//  SelectablePhotosCollectionViewCell.swift
//  Bootcamp
//
//  Created by İrem Eriçek on 30.04.2024.
//

import UIKit

class SelectablePhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectableImageView : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            
            // Ekran genişliğinin 1/4'ü kadar genişlik
            let screenWidth = UIScreen.main.bounds.width
            let width = screenWidth / 4.0
            
            // 30px yükseklik
            let height: CGFloat = 30.0
            
            // Hücrenin genişliğini ve yüksekliğini ayarla
            self.frame.size = CGSize(width: width, height: height)
        }
}
