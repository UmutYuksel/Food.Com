//
//  GirisYapViewController.swift
//  Food.Com
//
//  Created by Umut Yüksel on 8.03.2024.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var uyeOlButton: UIButton!
        @IBOutlet weak var sifreTextField: UITextField!
        @IBOutlet weak var kullaniciAdiTextField: UITextField!
        @IBOutlet weak var sifremiUnuttumButton: UIButton!
        @IBOutlet weak var girisYapButton: UIButton!
        
        var viewModel = SignInViewModel()
        
        
        func prepareViewWithViewModel() {
            
            viewModel.uyeOlAttributedString(button: uyeOlButton)
        }
        
        @IBAction func girisYapPressed(_ sender: Any) {
            viewModel.onError = { error in
                        // ViewModel'daki fonksiyon hata verdiğinde yapılacak işlemler
                        // Örneğin, hata mesajını kullanıcıya gösterme
                        print("Hata Oluştu: \(error.localizedDescription)")
                    }

                    viewModel.onSuccess = {
                        // ViewModel'daki fonksiyon başarıyla tamamlandığında yapılacak işlemler
                        self.performSegue(withIdentifier: "girisToTabBarSegue", sender: nil)
                    }

                    viewModel.girisYapWithFirebase(view: self.view, epostaText: kullaniciAdiTextField.text!, sifreText: sifreTextField.text!)
        }
        
        
        @IBAction func sifremiUnuttumPressed(_ sender: Any) {
        }
        
        @IBAction func uyeOlPressed(_ sender: Any) {
            
            dismiss(animated: true) {
                self.viewModel.uyeOlViewController()
            }
        }


        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            prepareViewWithViewModel()
            prepareSheetVC()
        }
        
        
    }

    extension SignInViewController : UISheetPresentationControllerDelegate {
        
        override var sheetPresentationController: UISheetPresentationController? {
            presentationController as? UISheetPresentationController
        }
        
        private func prepareSheetVC() {
            sheetPresentationController?.delegate = self
            sheetPresentationController?.selectedDetentIdentifier = .medium
            sheetPresentationController?.prefersGrabberVisible = true
            sheetPresentationController?.detents = [
                .medium()]
        }
}
