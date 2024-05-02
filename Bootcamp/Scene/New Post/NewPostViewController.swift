import UIKit
import Photos

class NewPostViewController: UIViewController {

    @IBOutlet weak var selectablePhotosCollectionView: UICollectionView!
    @IBOutlet weak var contentModeButton: UIButton!
    @IBOutlet weak var selectedPhotosCollectionView: UICollectionView!

    var selectableImages = [PHAsset]()
    var isAspectFit = true

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPhotosCollectionView.dataSource = self
        selectedPhotosCollectionView.delegate = self
        selectablePhotosCollectionView.dataSource = self
        selectablePhotosCollectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        selectablePhotosCollectionView.collectionViewLayout = layout
        
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                let assest = PHAsset.fetchAssets(with: PHAssetMediaType.image , options: nil)
                assest.enumerateObjects { object, _,_ in
                    self?.selectableImages.append(object)
                }
                self?.selectableImages.reverse()
                DispatchQueue.main.async{
                    self?.selectablePhotosCollectionView.reloadData()
                    // selectedPhotosCollectionView'daki image view'a son resmi yükle
                    if let lastAsset = self?.selectableImages.first {
                        self?.loadImage(for: lastAsset)
                    }
                }
            }
        }
    }

    func loadImage(for asset: PHAsset) {
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.resizeMode = .exact
        manager.requestImage(for: asset, targetSize: CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale, height: UIScreen.main.bounds.height * UIScreen.main.scale), contentMode: .aspectFit, options: options) { [weak self] image,_ in
            DispatchQueue.main.async {
                if let image = image {
                    if let cell = self?.selectedPhotosCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? SelectedPhotosCollectionViewCell {
                        cell.selectedImageView.image = image
                    }
                }
            }
        }
    }


    

    @IBAction func contentModeButtonPressed(_ sender: UIButton) {
        isAspectFit = !isAspectFit
        updateContentMode()
    }

    private func updateContentMode() {
        // Koleksiyon görünümündeki tüm hücreleri döngüye alarak
        // içerisindeki resmin content mode'ını güncelle
        for case let cell as SelectedPhotosCollectionViewCell in selectedPhotosCollectionView.visibleCells {
            cell.selectedImageView.contentMode = isAspectFit ? .scaleAspectFit : .scaleAspectFill
        }
    }
    
}

extension NewPostViewController: UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.selectedPhotosCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedPhotoCell", for: indexPath) as! SelectedPhotosCollectionViewCell
 
            return cell
        }
        else if collectionView.restorationIdentifier == "selectablePhotosCollectionView" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectablePhotoCell", for: indexPath) as! SelectablePhotosCollectionViewCell
            // Örnek olarak, selectablPhotosCollectionView hücresine farklı bir görüntü atıyoruz.
            let asset = self.selectableImages[indexPath.row]
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.resizeMode = .exact
            manager.requestImage(for: asset, targetSize: CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale, height: UIScreen.main.bounds.height * UIScreen.main.scale), contentMode: .aspectFit, options: options) { image,_ in
                DispatchQueue.main.async {
                    cell.selectableImageView.image = image
                }}
            return cell
        }
        
        // Tanımlanan identifier'lar dışında bir collection view varsa, boş bir hücre döndürüyoruz.
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == selectedPhotosCollectionView) {
            return 1
        }
        return self.selectableImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Sadece selectablePhotosCollectionView için boyut ayarla
        if collectionView == selectablePhotosCollectionView {
            // Hücre boyutunu belirle
            let screenWidth = UIScreen.main.bounds.width
            let width = screenWidth / 4.0
            let height: CGFloat = 100
            return CGSize(width: width, height: height)
        } else {
            // selectedPhotosCollectionView için sabit bir hücre boyutu belirle
            let height: CGFloat = 400
            return CGSize(width: UIScreen.main.bounds.width, height: height) // Genişlik, yükseklik ile aynı
        }
    }
    
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if collectionView == selectablePhotosCollectionView {
                // Kullanıcı bir fotoğraf seçti, bu fotoğrafı selectedPhotosCollectionView'daki ilk hücreye yerleştir.
                let selectedAsset = selectableImages[indexPath.row]
                let manager = PHImageManager.default()
                let options = PHImageRequestOptions()
                options.isNetworkAccessAllowed = true
                options.resizeMode = .exact
                manager.requestImage(for: selectedAsset, targetSize: CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale, height: UIScreen.main.bounds.height * UIScreen.main.scale), contentMode: .aspectFit, options: options) { image,_ in
                    DispatchQueue.main.async {
                        if let image = image {
                            if let cell = self.selectedPhotosCollectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? SelectedPhotosCollectionViewCell {
                                cell.selectedImageView.image = image
                        }
                    }
                }
            }
        }
    }
}

    


