//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 23.12.2023.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest {
        let url = authUrl()
        return URLRequest(url: url)
    }
    
    func authUrl() -> URL {
        let urlComponents = URLComponents(string: Constants.unsplashAuthorizeURLString)
        guard var urlComponents else {
            assertionFailure("There is no url components")
            return URL(fileURLWithPath: "")
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
        URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        guard let url = urlComponents.url else {
            assertionFailure("There is no url in url components")
            return URL(fileURLWithPath: "")
        }
        
        return url
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == Constants.pathToGetCode,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    
}
