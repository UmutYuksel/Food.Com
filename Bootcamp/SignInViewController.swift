//
//  GirisYapViewController.swift
//  Food.Com
//
//  Created by Umut Yüksel on 8.03.2024.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var usernameTextField: UITextField!
        @IBOutlet weak var forgotPasswordButton: UIButton!
        @IBOutlet weak var signInButton: UIButton!
        
        var viewModel = SignInViewModel()
        
        
        func prepareViewWithViewModel() {
            
            viewModel.signUpAttributedString(button: signUpButton)
        }
        
        @IBAction func signInButtonPressed(_ sender: Any) {
            viewModel.onError = { error in
                        // ViewModel'daki fonksiyon hata verdiğinde yapılacak işlemler
                        // Örneğin, hata mesajını kullanıcıya gösterme
                        print("Hata Oluştu: \(error.localizedDescription)")
                    }

                    viewModel.onSuccess = {
                        // ViewModel'daki fonksiyon başarıyla tamamlandığında yapılacak işlemler
                        self.performSegue(withIdentifier: "girisToTabBarSegue", sender: nil)
                    }

                    viewModel.signInWithFirebase(view: self.view, emailText: usernameTextField.text!, passwordText: passwordTextField.text!)
        }
        
        
        @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        }
        
        @IBAction func signUpButtonPressed(_ sender: Any) {
            
            dismiss(animated: true) {
                self.viewModel.toSignUpViewController()
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
