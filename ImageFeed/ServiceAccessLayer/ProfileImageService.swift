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
    
    private var prevTask: URLSessionTask?
    
    private (set) var avatarURL: String?
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if prevTask != nil {
            return
        }
        
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
                self.prevTask = nil
                completion(.success(smallProfileImage ?? String()))
            case .failure(let error):
                self.prevTask = nil
                completion(.failure(error))
            }
            
        }
        self.prevTask = task
        task.resume()
    }
    
}

