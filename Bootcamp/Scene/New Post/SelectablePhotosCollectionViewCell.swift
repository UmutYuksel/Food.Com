//
//  SelectablePhotosCollectionViewCell.swift
//  Bootcamp
//
//  Created by İrem Eriçek on 30.04.2024.
//

import UIKit

class SelectablePhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var chechImageView: UIImageView!
    @IBOutlet weak var selectableImageView : UIImageView!
    
    override var isSelected: Bool {
        didSet {
            chechImageView.isHidden = !isSelected
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectableImageView.image = nil
    }
    
    var isSelectedCell: Bool = false {
            didSet {
                chechImageView.isHidden = !isSelectedCell
            }
        }
}
