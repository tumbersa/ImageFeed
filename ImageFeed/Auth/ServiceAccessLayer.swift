//
//  ServiceAccessLayer.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 04.11.2023.
//
import Foundation

//TODO: убрать в другой файл
final class OAuth2TokenStorage {
    var token: String? {
        get {
            UserDefaults().string(forKey: "token")
        }
        set{
            UserDefaults().setValue(newValue, forKey: "token")
        }
    }
}
//
final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    
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
        let request = authTokenRequest(code: code)
        let task = object(for: request){ [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponceBody,Error>) -> Void
    ) -> URLSessionTask{
        let decoder = JSONDecoder()
        return urlSession.data(for: request) { (result: Result<Data,Error>) in
            let responce = result.flatMap{ data -> Result<OAuthTokenResponceBody,Error> in
                Result{ try decoder.decode(OAuthTokenResponceBody.self, from: data)}
            }
        }
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
            baseUrl: URL(string: "https://unsplash.com")!
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

//MARK: - HTTP Request

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String = "GET",
        baseUrl: URL = defaultBaseURL
    ) -> URLRequest {
        var request = URLRequest(url: URL(string: path, relativeTo: baseUrl)!)
        request.httpMethod = httpMethod
        return request
    }
}

//MARK: - Network Connection

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data,Error>) -> Void
    ) -> URLSessionTask{
        let fulfiilCompletion: (Result<Data,Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: {data, responce, error in
            if let data,
               let responce,
               let statusCode = (responce as? HTTPURLResponse)?.statusCode
            {
                if 200..<300 ~= statusCode {
                    fulfiilCompletion(.success(data))
                } else if !(200..<300).contains(statusCode) {
                    fulfiilCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                } else if let error {
                    fulfiilCompletion(.failure(NetworkError.urlRequestError(error)))
                } else {
                    fulfiilCompletion(.failure(NetworkError.urlSessionError))
                }
            }
        })
        task.resume()
        return task
    }
}
