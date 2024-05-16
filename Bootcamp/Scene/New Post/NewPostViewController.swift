import UIKit
import Photos

class NewPostViewController: UIViewController {
    
    @IBOutlet weak var multipleSelectionButton: UIButton!
    @IBOutlet weak var selectablePhotosCollectionView: UICollectionView!
    @IBOutlet weak var contentModeButton: UIButton!
    @IBOutlet weak var selectedPhotosCollectionView: UICollectionView!
    
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
        selectedPhotosCollectionView.dataSource = self
        selectedPhotosCollectionView.delegate = self
        selectablePhotosCollectionView.dataSource = self
        selectablePhotosCollectionView.delegate = self
        multipleSelectionButton.backgroundColor = .separator
        selectablePhotosCollectionView.allowsMultipleSelection = false
    }
    
   
    @IBAction func photoAlbumePressed(_ sender: Any) {}
    
    @IBAction func multipleSelectionPressed(_ sender: Any) {
        selectablePhotosCollectionView.allowsMultipleSelection = !selectablePhotosCollectionView.allowsMultipleSelection
        if multipleSelectionButton.backgroundColor == UIColor.separator {
            multipleSelectionButton.backgroundColor = UIColor(named: "tintColor")
        } else {
            multipleSelectionButton.backgroundColor = .separator
        }
    }
    
    func loadSelectedImage(for asset: PHAsset, into imageView: UIImageView) {
           let options = PHImageRequestOptions()
           options.isNetworkAccessAllowed = true
           options.deliveryMode = .highQualityFormat
           options.resizeMode = .fast
           
           let targetSize = CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale, height: UIScreen.main.bounds.height * UIScreen.main.scale)
           
        viewModel.imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options) { image, _ in
               DispatchQueue.main.async {
                   imageView.image = image
                   imageView.contentMode = .scaleAspectFill
               }
           }
       }
    
    func addLastSelectedImage() {
        if let lastAsset = viewModel.selectableImages.first {
            if let firstCell = selectedPhotosCollectionView.visibleCells.first as? SelectedPhotosCollectionViewCell {
                loadSelectedImage(for: lastAsset, into: firstCell.selectedImageView)
            }
        }
    }

        
        @IBAction func contentModeButtonPressed(_ sender: UIButton) {
            viewModel.isAspectFit = !viewModel.isAspectFit
            updateContentMode()
        }
        
        private func updateContentMode() {
            // Koleksiyon görünümündeki tüm hücreleri döngüye alarak
            // içerisindeki resmin content mode'ını güncelle
            for case let cell as SelectedPhotosCollectionViewCell in selectedPhotosCollectionView.visibleCells {
                cell.selectedImageView.contentMode = viewModel.isAspectFit ? .scaleAspectFit : .scaleAspectFill
            }
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "forwardSegueToPushPost" {
            // Hedef view controller'ı alın
            if let destinationVC = segue.destination as? PushPostViewController {
                destinationVC.viewModel.selectedAssets = viewModel.selectedAssets
            }
        }
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setLayout()
        fetchImagesFromDevices()
    }
}
    
    extension NewPostViewController: UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == selectedPhotosCollectionView {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedPhotoCell", for: indexPath) as! SelectedPhotosCollectionViewCell
                
                // Eğer seçilen fotoğraf yoksa, boş bir hücre döndür
                if viewModel.selectedAssets.isEmpty {
                    return cell
                }
                
                // Seçilen fotoğrafın varlığını kontrol et
                if indexPath.row < viewModel.selectedAssets.count {
                    let selectedAsset = viewModel.selectedAssets[indexPath.row]
                    loadSelectedImage(for: selectedAsset, into: cell.selectedImageView)
                    cell.selectedImageView.contentMode = .scaleAspectFill
                }
                
                return cell
            } else if collectionView.restorationIdentifier == "selectablePhotosCollectionView" {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectablePhotoCell", for: indexPath) as! SelectablePhotosCollectionViewCell
                cell.chechImageView.isHidden = true
                cell.highlightView.isHidden = true
                let asset = self.viewModel.selectableImages[indexPath.row]
                loadSelectedImage(for: asset, into: cell.selectableImageView)
                cell.selectableImageView.contentMode = .scaleAspectFill
                return cell
            }
            return UICollectionViewCell()
        }

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if (collectionView == selectedPhotosCollectionView) {
                return 1
            }
            return self.viewModel.selectableImages.count
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            guard collectionView == selectablePhotosCollectionView else { return }
            
            let selectedAsset = viewModel.selectableImages[indexPath.row]
            
            if !viewModel.selectedAssets.contains(selectedAsset) {
                viewModel.selectedAssets.append(selectedAsset)
                if let cell = collectionView.cellForItem(at: indexPath) as? SelectablePhotosCollectionViewCell {
                    cell.isSelectedCell = true
                }
                if let lastSelectedIndexPath = selectedPhotosCollectionView.indexPathsForVisibleItems.first {
                    if let selectedCell = selectedPhotosCollectionView.cellForItem(at: lastSelectedIndexPath) as? SelectedPhotosCollectionViewCell {
                        loadSelectedImage(for: selectedAsset, into: selectedCell.selectedImageView)
                    }
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
            
            if let previousSelectedAsset = viewModel.selectedAssets.last, let lastSelectedIndexPath = selectedPhotosCollectionView.indexPathsForVisibleItems.first {
                if let selectedCell = selectedPhotosCollectionView.cellForItem(at: lastSelectedIndexPath) as? SelectedPhotosCollectionViewCell {
                    loadSelectedImage(for: previousSelectedAsset, into: selectedCell.selectedImageView)
                }
            }
        }
      
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            // Sadece selectablePhotosCollectionView için boyut ayarla
            if collectionView == selectablePhotosCollectionView {
                // Hücre boyutunu belirle
                let screenWidth = UIScreen.main.bounds.width
                let width = (screenWidth / 4.0) - 2
                let height: CGFloat = 100
                return CGSize(width: width, height: height)
            } else {
                // selectedPhotosCollectionView için sabit bir hücre boyutu belirle
                let height: CGFloat = 400
                return CGSize(width: UIScreen.main.bounds.width, height: height) // Genişlik, yükseklik ile aynı
            }
        }

}
