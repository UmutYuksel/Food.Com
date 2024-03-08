//
//  SettingsViewModel.swift
//  Food.Com
//
//  Created by Umut Yüksel on 8.03.2024.
//

import Foundation
import UIKit
import Firebase

struct SettingsViewModel {
    
    func prepareSignButtons(signOut : UIButton,signIn : UIButton) {
        
        if Auth.auth().currentUser?.uid == nil {
            signOut.isHidden = true
            signIn.isHidden = false
            signIn.layer.borderColor = UIColor(named: "tintColor")?.cgColor
            signIn.layer.borderWidth = 2.0
        } else {
            signOut.isHidden = false
            signOut.layer.borderColor = UIColor(named: "tintColor")?.cgColor
            signOut.layer.borderWidth = 2.0
            signIn.isHidden = true
        }
        
    }

}
