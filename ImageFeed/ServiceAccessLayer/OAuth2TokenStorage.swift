//
//  Storage.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 05.11.2023.
//

import Foundation
 

final class OAuth2TokenStorage {
    private enum Keys: String {
        case authToken 
    }
    
    var token: String? {
        get {
            return UserDefaults().string(forKey: Keys.authToken.rawValue)
        }
        set{
            UserDefaults().setValue(newValue, forKey: Keys.authToken.rawValue)
        }
    }
}

