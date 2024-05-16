import UIKit

class SelectedPhotosCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    private var initialCenter: CGPoint!
    private var initialTransform: CGAffineTransform!
    private var panSensitivity: CGFloat = 0.2 // %20'lik sınırlama
       
       override func awakeFromNib() {
           super.awakeFromNib()
           
           selectedImageView.isUserInteractionEnabled = true
           // Gesture Recognizers
           let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
           selectedImageView.addGestureRecognizer(panGesture)

           let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
           selectedImageView.addGestureRecognizer(pinchGesture)

           // Initial Transform
           initialTransform = selectedImageView.transform
       }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)

        switch gesture.state {
        case .began:
            initialCenter = selectedImageView.center
        case .changed:
            let newX = initialCenter.x + translation.x * panSensitivity
            let newY = initialCenter.y + translation.y * panSensitivity
            selectedImageView.center = CGPoint(x: newX, y: newY)
            
            // Eğer resim ekran dışına çıkarsa, panSensitivity'yi iptal et
            if !bounds.contains(selectedImageView.frame) {
                panSensitivity = 0.5 // %50 etkin kıl
            } else {
                panSensitivity = 0 // %20 etkin kıl
            }
        case .ended, .cancelled:
            centerImageIfNeeded()
        default:
            break
        }
    }


    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .changed, .ended:
            let currentScale = selectedImageView.frame.size.width / selectedImageView.bounds.size.width
            var newScale = currentScale * gesture.scale

            if newScale < 1 {
                newScale = 1
            }
            if newScale > 3 {
                newScale = 3
            }

            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            selectedImageView.transform = transform
            gesture.scale = 1
        default:
            break
        }
    }

    
    func centerImageIfNeeded() {
        // Eğer resim view içinde değilse, ortalama yap
        if !selectedImageView.frame.contains(bounds) {
            UIView.animate(withDuration: 0.4) {
                self.selectedImageView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
    
//
//    var panGesture = UIPanGestureRecognizer()
//    var pinchGesture = UIPinchGestureRecognizer()
//
//    var initialCenter: CGPoint!
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        // UIPanGestureRecognizer ekleyin
//        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        panGesture.delegate = self
//        selectedImageView.addGestureRecognizer(panGesture)
//        selectedImageView.isUserInteractionEnabled = true
//
//        // UIPinchGestureRecognizer ekleyin
//        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
//        pinchGesture.delegate = self
//        selectedImageView.addGestureRecognizer(pinchGesture)
//    }
//
//    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: selectedImageView.superview)
//
//        if gesture.state == .began {
//            initialCenter = selectedImageView.center
//        }
//
//        if gesture.state == .changed {
//            selectedImageView.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
//        }
//
//        if gesture.state == .ended {
//            centerImageIfNeededWithAnimation()
//        }
//    }
//
//    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
//        if gesture.state == .changed {
//            let currentScale = selectedImageView.frame.size.width / selectedImageView.bounds.size.width
//            var newScale = currentScale * gesture.scale
//
//            if newScale < 1 {
//                newScale = 1
//            }
//            if newScale > 3 {
//                newScale = 3
//            }
//
//            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
//            selectedImageView.transform = transform
//            gesture.scale = 1
//        }
//    }
//
//    func centerImageIfNeededWithAnimation() {
//        let boundsSize = selectedImageView.bounds.size
//        var frameToCenter = selectedImageView.frame
//
//        // Hareket sonrasında, resim sınırlarının içinde merkeze ortalama yap
//        if frameToCenter.size.width < boundsSize.width {
//            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
//        } else {
//            frameToCenter.origin.x = 0
//        }
//
//        if frameToCenter.size.height < boundsSize.height {
//            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
//        } else {
//            frameToCenter.origin.y = 0
//        }
//
//        // Resmi ekrandan çıkmadan önce kontrol et
//        let maxX = max(frameToCenter.origin.x, boundsSize.width - frameToCenter.size.width)
//        let maxY = max(frameToCenter.origin.y, boundsSize.height - frameToCenter.size.height)
//        
//        frameToCenter.origin.x = min(frameToCenter.origin.x, maxX)
//        frameToCenter.origin.y = min(frameToCenter.origin.y, maxY)
//
//        UIView.animate(withDuration: 0.5) {
//            self.selectedImageView.frame = frameToCenter
//        }
//    }
//
//
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}
