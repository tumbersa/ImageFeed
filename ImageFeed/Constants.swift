//
//  Constants.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 02.11.2023.
//

import Foundation

enum Constants{
    static let accessKey = "7VZIm6NAeenBBKzFt41nMS7XTMxCw_6Y9AN53YZdr-M"
    static let secretKey = "6xV-FgQ45x2bI-TTTtwJ3J0LpuNz4gY36CK0jsqGlIA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let unspashUrl = URL(string: "https://unsplash.com")!
    
    static let accessScope = "public+read_user+write_likes"
    static let pathToGetCode = "/oauth/authorize/native"
    static let authToken = "auth_token"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}
