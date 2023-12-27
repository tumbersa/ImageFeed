//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 23.12.2023.
//

import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
   
    static var standard: AuthConfiguration {
        return AuthConfiguration(
            accessKey: Constants.accessKeyStandard,
            secretKey: Constants.secretKeyStandard,
            redirectURI: Constants.redirectURIStandard,
            accessScope: Constants.accessScopeStandard,
            defaultBaseURL: Constants.defaultBaseURLStandard)
    }
}
