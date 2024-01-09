//
//  Constants.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 02.11.2023.
//

import Foundation

enum Constants{
    static let accessKeyStandard            = "7VZIm6NAeenBBKzFt41nMS7XTMxCw_6Y9AN53YZdr-M"
    static let secretKeyStandard            = "6xV-FgQ45x2bI-TTTtwJ3J0LpuNz4gY36CK0jsqGlIA"
    static let redirectURIStandard          = "urn:ietf:wg:oauth:2.0:oob"
    static let defaultBaseURLStandard       = URL(string: "https://api.unsplash.com")!
    static let unspashUrl                   = URL(string: "https://unsplash.com")!
    
    static let accessScopeStandard          = "public+read_user+write_likes"
    static let pathToGetCode                = "/oauth/authorize/native"
    static let authToken                    = "auth_token"
    static let unsplashAuthorizeURLString   = "https://unsplash.com/oauth/authorize"
    
    
    static let titleLogoutAlertStandard     = "Пока, пока!"
    static let messageLogoutAlertStandard   = "Вы уверены, что хотите выйти?"
    static let titleLogoutYesButtonStandard = "Да"
    static let titleLogoutNoButtonStandard  = "Нет"
}
