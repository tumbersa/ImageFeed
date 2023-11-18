//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 17.11.2023.
//

import Foundation

final class ProfileImageService {
    static let DidChangeNotification = Notification.Name("ProfileImageProviderDidChange")
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
                completion(.success(smallProfileImage ?? String()))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastToken = nil
            }
            
        }
        self.task = task
        task.resume()
    }
    
}

struct UserResults: Decodable {
    let profileImage: UserResult
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct UserResult: Decodable {
    let small: String?
    
}
