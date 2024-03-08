//
//  AyarlarViewController.swift
//  Food.Com
//
//  Created by Umut Yüksel on 7.03.2024.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    
    @IBOutlet weak var signInButton: UIButton!
    let viewModel = SettingsViewModel()
    
    @IBAction func signOutButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Oturum Kapatılsın Mı ?", message: nil, preferredStyle: .alert)
        
        let actionSignOut = UIAlertAction(title: "Evet", style: .destructive) { [self] (_) in
        
            do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "settingsToLoginSegue", sender: signOutButton)
            } catch let signOutError {
                print("Hata!  Oturum kapatılmadı: \(signOutError)")
            }
        }
        
        let actionCancel = UIAlertAction(title: "İptal Et", style: .cancel)
        
        alertController.addAction(actionSignOut)
        alertController.addAction(actionCancel)
        present(alertController,animated: true)
        
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "settingsToLoginSegue", sender: signInButton)
        
    }
    func prepareButtons() {
        viewModel.prepareSignButtons(signOut: signOutButton, signIn: signInButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareButtons()
    }
}
