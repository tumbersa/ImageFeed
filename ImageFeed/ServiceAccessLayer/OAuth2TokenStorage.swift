//
//  Storage.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 05.11.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private enum Keys: String {
        case authToken 
    }
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.authToken.rawValue)
        }
        set{
            guard let newValue else { 
                KeychainWrapper.standard.remove(forKey: KeychainWrapper.Key(rawValue: Keys.authToken.rawValue))
                return
            }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Keys.authToken.rawValue)
            guard isSuccess else {
                print("The token was not saved")
                return
            }
        }
    }
}

