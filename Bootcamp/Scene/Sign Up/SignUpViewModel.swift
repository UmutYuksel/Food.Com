//
//  UyeOlViewModel.swift
//  Food.Com
//
//  Created by İrem Eriçek on 28.02.2024.
//

import Foundation
import UIKit
import JGProgressHUD
import Firebase

struct SignUpViewModel {
    
    func firebaseUserSave(username:String,password:String,email:String,view:UIView) {
        
        let signUpHud = JGProgressHUD(style: .light)
        signUpHud.textLabel.text = "Kaydınız Gerçekleştiriliyor"
        signUpHud.detailTextLabel.text = "Lütfen Bekleyiniz"
        signUpHud.show(in: view)
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let user = authResult?.user, error == nil else {
                
                signUpHud.dismiss(afterDelay: 0.5)
                let errorHud = JGProgressHUD(style: .light)
                errorHud.indicatorView = JGProgressHUDErrorIndicatorView()
                errorHud.textLabel.text = "Üye Olunamadı."
                errorHud.detailTextLabel.text = "\(error!.localizedDescription)"
                errorHud.show(in: view, animated: true, afterDelay: 1)
                errorHud.dismiss(afterDelay: 2)
                return
            }
            
            guard let userId = authResult?.user.uid else { return }
            
            let db = Firestore.firestore()
            
            let userDetails = ["KullaniciAdi " : username,
                               "KullaniciID" : username,
                               "E-Mail" : email,
                               "Parola" : password]
            
            db.collection("Kullanicilar").document(userId).setData(userDetails) { (error) in
                if error != nil {
                    return
                }
                
                signUpHud.dismiss(afterDelay: 0.5)
                let successHud = JGProgressHUD(style: .light)
                successHud.indicatorView = JGProgressHUDSuccessIndicatorView()
                successHud.textLabel.text = "Üye Olma İşlemi Başarılı."
                successHud.detailTextLabel.text = "Keyifli Kullanımlar Dileriz."
                successHud.show(in: view, animated: true, afterDelay: 1)
                successHud.dismiss(afterDelay: 2)
            }
        }
    }
    
    func signInAttributedString (button : UIButton) {
        let attributedString1 = NSAttributedString(string: "Hesabın var mı?", attributes:
                                                    [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        let attributedString2 = NSAttributedString(string: "Giriş Yap", attributes: 
                                                    [NSAttributedString.Key.foregroundColor: UIColor(named: "tintColor")!,
                                                     NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        
        let combination = NSMutableAttributedString()
                combination.append(attributedString1)
                combination.append(NSAttributedString(string: " "))
                combination.append(attributedString2)
        
        button.setAttributedTitle(combination, for: .normal)
    }
    
    func signInViewController() {
        
            // Hedef sayfayı modally (pageSheet) aç
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sheetPresenationController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        print(sheetPresenationController)
            // Geçiş yapılan view controller'ı belirleyip, onun üzerinde modally aç
            if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
                rootViewController.present(sheetPresenationController, animated: true, completion: nil)
                print(rootViewController)
            }
        }
}
