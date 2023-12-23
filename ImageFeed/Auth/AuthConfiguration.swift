//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 23.12.2023.
//

import Foundation


let accessKeyStandard = Constants.accessKey
let secretKeyStandard = Constants.secretKey
let redirectURIStandard = Constants.redirectURI
let accessScopeStandard = Constants.accessScope

let defaultBaseURLStandard = Constants.defaultBaseURL
let unsplashAuthorizeURLStringStandard = Constants.unsplashAuthorizeURLString

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
   
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: accessKeyStandard,
            secretKey: secretKeyStandard,
            redirectURI: redirectURIStandard,
            accessScope: accessScopeStandard,
            defaultBaseURL: defaultBaseURLStandard)
    }
}
