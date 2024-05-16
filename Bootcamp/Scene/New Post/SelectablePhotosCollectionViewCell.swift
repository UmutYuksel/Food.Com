//
//  SelectablePhotosCollectionViewCell.swift
//  Bootcamp
//
//  Created by İrem Eriçek on 30.04.2024.
//

import UIKit

class SelectablePhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var chechImageView: UIImageView!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak var selectableImageView : UIImageView!
    
    override var isHighlighted: Bool {
        didSet {
            highlightView.isHidden = !isHighlighted
        }
    }
    
    override var isSelected: Bool {
        didSet {
            highlightView.isHidden = !isSelected
            chechImageView.isHidden = !isSelected
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        selectableImageView.image = nil
    }
    
    var isSelectedCell: Bool = false {
            didSet {
                highlightView.isHidden = !isSelectedCell
                chechImageView.isHidden = !isSelectedCell
            }
        }
}
