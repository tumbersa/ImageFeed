//
//  ServiceAccessLayer.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 04.11.2023.
//
import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get{
            return OAuth2TokenStorage().token
        }
        set{
            OAuth2TokenStorage().token = newValue
        }
    }
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String,Error>) -> Void
    ) {
        assert(Thread.isMainThread)
        if lastCode == code { return }                     
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = urlSession.objectTask(for: request){[weak self] (result: Result<OAuthTokenResponceBody,Error>) in
            guard let self else {return}
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                self.task = nil
                completion(.success(authToken))
            case .failure(let error):
                self.lastCode = nil
                completion(.failure(error))
            }
            
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest{
        URLRequest.makeHTTPRequest(
            path:"/oauth/token" +
            "?client_id=\(Constants.accessKey)" +
            "&&client_secret=\(Constants.secretKey)" +
            "&&redirect_uri=\(Constants.redirectURI)" +
            "&&code=\(code)" +
            "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseUrl: Constants.unspashUrl
        )
    }
}

