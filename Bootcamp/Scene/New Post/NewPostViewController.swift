import UIKit
import Photos

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var multipleSelectionButton: UIButton!
    @IBOutlet weak var selectablePhotosCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    
    var viewModel = NewPostViewModel()
       
        func fetchImagesFromDevices() {
            viewModel.imageManager = PHCachingImageManager()
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                if status == .authorized {
                    let assets = PHAsset.fetchAssets(with: .image, options: nil)
                    assets.enumerateObjects { object, _, _ in
                        self?.viewModel.selectableImages.append(object)
                    }
                    self?.viewModel.selectableImages.reverse()
                    DispatchQueue.main.async {
                        self?.selectablePhotosCollectionView.reloadData()
                        self?.addLastSelectedImage()
                    }
                }
            }
        }
        
        fileprivate func setLayout() {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 2
            layout.minimumInteritemSpacing = 2
            layout.scrollDirection = .vertical
            selectablePhotosCollectionView.collectionViewLayout = layout
        }
        
        fileprivate func setViews() {
            selectablePhotosCollectionView.dataSource = self
            selectablePhotosCollectionView.delegate = self
            multipleSelectionButton.backgroundColor = .separator
            selectablePhotosCollectionView.allowsMultipleSelection = false
        }
    
    @IBAction func multipleSelectionPressed(_ sender: Any) {
        selectablePhotosCollectionView.allowsMultipleSelection = !selectablePhotosCollectionView.allowsMultipleSelection
        if multipleSelectionButton.backgroundColor == UIColor.separator {
            multipleSelectionButton.backgroundColor = UIColor(named: "tintColor")
        } else {
            multipleSelectionButton.backgroundColor = .separator
        }
    }
    
    func loadSelectedImage(for asset: PHAsset, into imageView: UIImageView,contentMode: UIView.ContentMode) {
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .fast
            
            let targetSize = CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale, height: UIScreen.main.bounds.height * UIScreen.main.scale)
            
        viewModel.imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
                DispatchQueue.main.async {
                    imageView.image = image
//                    self.setZoomParametersForSize(self.scrollView.bounds.size)
                    self.centerImage()
                }
            }
        }
        
        func addLastSelectedImage() {
            if let lastAsset = viewModel.selectableImages.first {
                loadSelectedImage(for: lastAsset, into: selectedImageView,contentMode: .scaleAspectFit)
            }
        }

        @IBAction func cameraButtonPressed(_ sender: UIButton) {
            
        }
       
        override func viewDidLoad() {
            super.viewDidLoad()
            setViews()
            setLayout()
            fetchImagesFromDevices()
            
            scrollView.delegate = self
            scrollView.maximumZoomScale = 5.0
        }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushPostViewControllerSegue" {
            if let destinationVC = segue.destination as? PushPostViewController {
                // Kesilmiş görüntüleri gönder
                destinationVC.viewModel.selectedAssets = viewModel.croppedImages
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)

            viewModel.croppedImages.removeAll()
        }
}

    
extension NewPostViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == selectablePhotosCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectablePhotoCell", for: indexPath) as! SelectablePhotosCollectionViewCell
            cell.chechImageView.isHidden = true
            let asset = viewModel.selectableImages[indexPath.row]
            loadSelectedImage(for: asset, into: cell.selectableImageView, contentMode: .scaleAspectFill)
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.selectableImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView == selectablePhotosCollectionView else { return }
        
        let selectedAsset = viewModel.selectableImages[indexPath.row]
        
        if !viewModel.selectedAssets.contains(selectedAsset) {
            viewModel.selectedAssets.append(selectedAsset)
            if let cell = collectionView.cellForItem(at: indexPath) as? SelectablePhotosCollectionViewCell {
                cell.isSelectedCell = true
            }
            loadSelectedImage(for: selectedAsset, into: selectedImageView, contentMode: .scaleAspectFit)
            
            // Görüntüyü crop et ve croppedImages dizisine ekle
            if let croppedImage = selectedImageView.croppedImage(using: scrollView) {
                viewModel.croppedImages.append(croppedImage)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard collectionView == selectablePhotosCollectionView else { return }
        
        let deselectedAsset = viewModel.selectableImages[indexPath.row]
        
        if let index = viewModel.selectedAssets.firstIndex(of: deselectedAsset) {
            viewModel.selectedAssets.remove(at: index)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SelectablePhotosCollectionViewCell {
            cell.isSelectedCell = false
        }
        
        // Crop edilmiş görüntüyü kaldır
        if let indexToRemove = viewModel.croppedImages.firstIndex(where: { $0 == deselectedAsset }) {
            viewModel.croppedImages.remove(at: indexToRemove)
        }
        
        if let previousSelectedAsset = viewModel.selectedAssets.last {
            loadSelectedImage(for: previousSelectedAsset, into: selectedImageView, contentMode: .scaleAspectFit)
        } else {
            selectedImageView.image = nil // Son seçili görüntü yoksa imageView'ı temizle
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == selectablePhotosCollectionView {
            let screenWidth = UIScreen.main.bounds.width
            let width = (screenWidth / 4.0) - 2
            let height: CGFloat = 100
            return CGSize(width: width, height: height)
        }
        return CGSize.zero
    }
}


extension NewPostViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return selectedImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        // Zoom işlemi tamamlandığında görüntüyü kes
        if let croppedImage = selectedImageView.croppedImage(using: scrollView) {
            viewModel.croppedImages.append(croppedImage)
        }
    }
    
    private func centerImage() {
        guard let image = selectedImageView.image else { return }
        
        let scrollViewSize = scrollView.bounds.size
        let imageViewSize = image.size
        
        var horizontalInset: CGFloat = 0
        var verticalInset: CGFloat = 0
        
        if imageViewSize.width < scrollViewSize.width {
            horizontalInset = (scrollViewSize.width - imageViewSize.width) / 2.0
        }
        
        if imageViewSize.height < scrollViewSize.height {
            verticalInset = (scrollViewSize.height - imageViewSize.height) / 2.0
        }
        
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}
