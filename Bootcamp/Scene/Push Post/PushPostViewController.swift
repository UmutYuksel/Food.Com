//
//  PushPostViewController.swift
//  Bootcamp
//
//  Created by Umut Yüksel on 4.05.2024.
//

import UIKit

class PushPostViewController: UIViewController {

    @IBOutlet weak var pushImageCV: UICollectionView!
    
    var viewModel = PushPostViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
        
        pushImageCV.dataSource = self
        pushImageCV.delegate = self
        print(viewModel.selectedAssets.count)
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            
            // selectedAssets dizisini boşaltın
            viewModel.selectedAssets.removeAll()
        }
}

extension PushPostViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.selectedAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PushCollectionViewCell", for: indexPath) as! PushPostCollectionViewCell
        cell.pushImageView.image = viewModel.selectedAssets[indexPath.row]
        cell.pushImageView.contentMode = .scaleAspectFit
        cell.pushImageView.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width , height: pushImageCV.bounds.height)
    }
    
    
}
