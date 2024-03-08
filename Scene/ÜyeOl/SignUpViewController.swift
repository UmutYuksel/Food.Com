//
//  UyeOlViewController.swift
//  Food.Com
//
//  Created by İrem Eriçek on 26.02.2024.
//

import UIKit
import Firebase
import JGProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var sifreTextField: UITextField!
    @IBOutlet weak var epostaTextField: UITextField!
    
    var viewModel = SignUpViewModel()
    
    @IBAction func kayitOlButtonPressed(_ sender: Any) {
        
        viewModel.firebaseUserSave(kullaniciAdi: usernameTextField.text!, sifre: sifreTextField.text!, eposta: epostaTextField.text!, view: self.view)
 
    }
    
    
    @IBAction func girisYapButtonPressed(_ sender: Any) {

        dismiss(animated: true) {
            self.viewModel.signInViewController()
        }
    }
    
    func prepareViews() {
        usernameTextField.delegate = self
        sifreTextField.delegate = self
        epostaTextField.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        viewModel.signInAttributedString(button: signInButton)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareViews()
        prepareSheetVC()
    }
}

extension SignUpViewController : UITextFieldDelegate {
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        epostaTextField.resignFirstResponder()
        sifreTextField.resignFirstResponder()
        return true
    }
}

extension SignUpViewController : UISheetPresentationControllerDelegate {
    
    override var sheetPresentationController: UISheetPresentationController? {
        presentationController as? UISheetPresentationController
    }
    
    private func prepareSheetVC() {
        sheetPresentationController?.delegate = self
        sheetPresentationController?.selectedDetentIdentifier = .large
        sheetPresentationController?.prefersGrabberVisible = true
        sheetPresentationController?.detents = [
            .large()]
    }
}
