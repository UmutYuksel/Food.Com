import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var contentModeButton: UIButton!
    @IBOutlet weak var selectPhotosCollectionView: UICollectionView!

    var isAspectFit = true

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func contentModeButtonPressed(_ sender: UIButton) {
        isAspectFit = !isAspectFit
        updateContentMode()
    }

    private func updateContentMode() {
        // Koleksiyon görünümündeki tüm hücreleri döngüye alarak
        // içerisindeki resmin content mode'ını güncelle
        for case let cell as PhotosCollectionViewCell in selectPhotosCollectionView.visibleCells {
            cell.selectedImageView.contentMode = isAspectFit ? .scaleAspectFit : .scaleAspectFill
        }
    }
}

extension NewPostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = selectPhotosCollectionView.dequeueReusableCell(withReuseIdentifier: "selectedPhotoCell", for: indexPath) as! PhotosCollectionViewCell
        cell.selectedImageView.image = UIImage(named: "wikiImage2.jpeg")
        return cell
    }
}
