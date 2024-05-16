//
//  PushPostViewController.swift
//  Bootcamp
//
//  Created by Umut Yüksel on 4.05.2024.
//

import UIKit

class PushPostViewController: UIViewController {

    @IBOutlet weak var pushCV: UICollectionView!
    
    var viewModel = PushPostViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        pushCV.dataSource = self
        pushCV.delegate = self
    }

}

extension PushPostViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.selectedAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pushCollectionViewCell", for: indexPath) as! pushCollectionViewCell
        cell.pushımageView.setImageFromPHAsset(viewModel.selectedAssets[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 393, height: 402)
    }
    
    
}

class pushCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var pushTextField: UITextField!
    @IBOutlet weak var pushımageView: UIImageView!
}
