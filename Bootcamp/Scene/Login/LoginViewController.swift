//
//  LoginViewController.swift
//  Food.Com
//
//  Created by İrem Eriçek on 26.02.2024.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var wikiCollectionView: UICollectionView!
    @IBOutlet weak var signUpButton: UIButton!
   
    let viewModel = LoginViewModel()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareButton()
        prepareViews()
        
    }
    
    func prepareViews() {
        wikiCollectionView.delegate = self
        wikiCollectionView.dataSource = self
    }
    
    func prepareButton() {
        viewModel.prepareButtons(signIn: signInButton, signUp: signUpButton)
    }
}

extension LoginViewController : UICollectionViewDelegateFlowLayout , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.wikiCellimages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loginWikiCell", for: indexPath) as! WikiCollectionViewCell
        
        // Görüntüyü işle ve hücredeki imageView'e ata
        cell.wikiImageView.image = viewModel.prepareWikiCellImage(viewModel.wikiCellimages[indexPath.item])
        
        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = wikiCollectionView.frame.width
            let height = wikiCollectionView.frame.height
            return CGSize(width: width, height: height)
        }
    
    
}
