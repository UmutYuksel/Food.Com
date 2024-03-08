//
//  GirisYapViewModel.swift
//  Food.Com
//
//  Created by Umut Yüksel on 5.03.2024.
//

import Foundation
import UIKit
import Firebase
import JGProgressHUD

struct SignInViewModel {
    
    func signUpAttributedString (button : UIButton) {
        let attributedString1 = NSAttributedString(string: "Hesabın yok mu?", attributes:
                                                    [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        let attributedString2 = NSAttributedString(string: "Üye Ol", attributes:
                                                    [NSAttributedString.Key.foregroundColor: UIColor(named: "tintColor")!,
                                                     NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        let combination = NSMutableAttributedString()
                combination.append(attributedString1)
                combination.append(NSAttributedString(string: " "))
                combination.append(attributedString2)
        
        button.setAttributedTitle(combination, for: .normal)
    }
    
    func toSignUpViewController() {
        
        let stroyboard = UIStoryboard(name: "Main", bundle: nil)
        let sheetPresenationController = stroyboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(sheetPresenationController, animated: true, completion: nil)
        }
    }
    
    var onSuccess: (() -> Void)?
    var onError: ((Error) -> Void)?

        func signInWithFirebase(view: UIView, emailText: String, passwordText: String) {
            let loginHud = JGProgressHUD(style: .light)
            loginHud.textLabel.text = "Oturum Açılıyor"
            loginHud.detailTextLabel.text = "Lütfen Bekleyiniz"
            loginHud.show(in: view)

            Auth.auth().signIn(withEmail: emailText, password: passwordText) { (response, error) in
                loginHud.dismiss(afterDelay: 0.5) // Hata olsa da başarılı olsa da dismiss yapılmalı

                if let error = error {
                    print("Oturum Açılırken Hata Oluştu \(error.localizedDescription)")

                    let errorHud = JGProgressHUD(style: .light)
                    errorHud.indicatorView = JGProgressHUDErrorIndicatorView()
                    errorHud.textLabel.text = "Oturum Açılamadı"
                    errorHud.detailTextLabel.text = "\(error.localizedDescription)"
                    errorHud.show(in: view, animated: true, afterDelay: 1)
                    errorHud.dismiss(afterDelay: 2)

                    // Hata durumunda onError closure'ını çağır
                    self.onError?(error)
                    return
                }

                guard Auth.auth().currentUser != nil else { return }
                let successHud = JGProgressHUD(style: .light)
                successHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                successHud.textLabel.text = "Oturum Açma Başarılı"
                successHud.detailTextLabel.text = "Lütfen Bekleyiniz."
                successHud.show(in: view, animated: true, afterDelay: 1)
                successHud.dismiss(afterDelay: 2)

                // Başarılı giriş durumunda onSuccess closure'ını çağır
                self.onSuccess?()
            }
        }
}
