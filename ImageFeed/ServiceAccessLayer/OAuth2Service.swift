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
        let task = object(for: request){ [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastCode = nil
            }
            
        }
        self.task = task
        task.resume()
    }
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponceBody,Error>) -> Void
    ) -> URLSessionTask{
        let decoder = JSONDecoder()
        return urlSession.data(for: request, completion:  { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(OAuthTokenResponceBody.self,
                        from: data
                    )
                    completion(.success(object))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    private func authTokenRequest(code: String) -> URLRequest{
        URLRequest.makeHTTPRequest(
            path:"/oauth/token" +
            "?client_id=\(accessKey)" +
            "&&client_secret=\(secretKey)" +
            "&&redirect_uri=\(redirectURI)" +
            "&&code=\(code)" +
            "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseUrl: unspashUrl
        )
    }
    
    private struct OAuthTokenResponceBody:Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
}

