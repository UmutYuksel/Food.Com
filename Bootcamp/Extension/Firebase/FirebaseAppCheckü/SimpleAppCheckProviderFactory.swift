//
//  YourSimpleAppCheckProviderFactory.swift
//  Food.Com
//
//  Created by Umut Yüksel on 5.03.2024.
//

import Foundation
import FirebaseAppCheck
import FirebaseCore

class SimpleAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
}
