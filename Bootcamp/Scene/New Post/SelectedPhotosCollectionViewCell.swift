import UIKit

class SelectedPhotosCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    @IBOutlet weak var selectedImageView: UIImageView!

    var panGesture = UIPanGestureRecognizer()
    var pinchGesture = UIPinchGestureRecognizer()

    var initialCenter: CGPoint!

    override func awakeFromNib() {
        super.awakeFromNib()

        // UIPanGestureRecognizer ekleyin
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.delegate = self
        selectedImageView.addGestureRecognizer(panGesture)
        selectedImageView.isUserInteractionEnabled = true

        // UIPinchGestureRecognizer ekleyin
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinchGesture.delegate = self
        selectedImageView.addGestureRecognizer(pinchGesture)
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: selectedImageView.superview)

        if gesture.state == .began {
            initialCenter = selectedImageView.center
        }

        if gesture.state == .changed {
            selectedImageView.center = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
        }

        if gesture.state == .ended {
            centerImageIfNeededWithAnimation()
        }
    }

    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        if gesture.state == .changed {
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
        }
    }

    func centerImageIfNeededWithAnimation() {
        let boundsSize = selectedImageView.bounds.size
        var frameToCenter = selectedImageView.frame

        // Hareket sonrasında, resim sınırlarının içinde merkeze ortalama yap
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < boundsSize.height {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        // Resmi ekrandan çıkmadan önce kontrol et
        let maxX = max(frameToCenter.origin.x, boundsSize.width - frameToCenter.size.width)
        let maxY = max(frameToCenter.origin.y, boundsSize.height - frameToCenter.size.height)
        
        frameToCenter.origin.x = min(frameToCenter.origin.x, maxX)
        frameToCenter.origin.y = min(frameToCenter.origin.y, maxY)

        UIView.animate(withDuration: 0.5) {
            self.selectedImageView.frame = frameToCenter
        }
    }


    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
