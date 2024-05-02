import UIKit

class NewPostViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var selectablePhotosCollectionView: UICollectionView!
    @IBOutlet weak var contentModeButton: UIButton!
    @IBOutlet weak var selectedPhotosCollectionView: UICollectionView!

    var isAspectFit = true

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPhotosCollectionView.dataSource = self
        selectedPhotosCollectionView.delegate = self
        selectablePhotosCollectionView.dataSource = self
        selectablePhotosCollectionView.delegate = self
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

extension NewPostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var section1 = 0
        var section2 = 0
        if collectionView.restorationIdentifier == "selectedPhotosCollectionView" {
             section1 = 1
        } else if collectionView.restorationIdentifier == "selectablePhotosCollectionView" {
             section2 = 10
        }
        return section1 ; section2 BU KISMI DÜZELT
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.restorationIdentifier == "selectedPhotosCollectionView" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedPhotoCell", for: indexPath) as! SelectedPhotosCollectionViewCell
            cell.selectedImageView.image = UIImage(named: "wikiImage2.jpeg")
            return cell
        }
        else if collectionView.restorationIdentifier == "selectablePhotosCollectionView" {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectablePhotoCell", for: indexPath) as! SelectablePhotosCollectionViewCell
            // Örnek olarak, selectablPhotosCollectionView hücresine farklı bir görüntü atıyoruz.
            cell.selectableImageView.image = UIImage(named: "wikiImage2.jpeg")
            return cell
        }
        
        // Tanımlanan identifier'lar dışında bir collection view varsa, boş bir hücre döndürüyoruz.
        return UICollectionViewCell()
    }

}
