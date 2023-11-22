//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 17.11.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    
    private let urlSession = URLSession.shared
    private let token = OAuth2TokenStorage().token
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        var request = URLRequest.makeHTTPRequest(path:
            "/users/\(username)")
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = urlSession.objectTask(for: request){ [weak self] (result: Result<UserResults,Error>) in
            guard let self else { return }
            switch result {
            case .success(let userResults):
                let smallProfileImage = userResults.profileImage.small
                self.avatarURL = smallProfileImage
                self.task = nil
                completion(.success(smallProfileImage ?? String()))
            case .failure(let error):
                self.lastToken = nil
                completion(.failure(error))
            }
            
        }
        self.task = task
        task.resume()
    }
    
}

