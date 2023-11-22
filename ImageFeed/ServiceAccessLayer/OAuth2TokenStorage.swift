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
    
    static let shared = OAuth2TokenStorage()
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Keys.authToken.rawValue)
        }
        set{
            guard let newValue else { 
                KeychainWrapper.standard.remove(forKey: KeychainWrapper.Key(rawValue: Keys.authToken.rawValue))
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: Keys.authToken.rawValue)
            
        }
    }
}

