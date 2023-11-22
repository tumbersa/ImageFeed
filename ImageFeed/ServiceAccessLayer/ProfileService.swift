//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 17.11.2023.
//

import Foundation


final class ProfileService {
    static let shared = ProfileService()
    
    private (set) var profile: Profile?
    let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        var request = URLRequest.makeHTTPRequest(path: "/me")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let task = urlSession.objectTask(for: request){[weak self] (result: Result<ProfileResult,Error>) in
            guard let self else { return }
            switch result {
            case .success(let body):
                let profile = Profile(
                    userName: body.userName,
                    name: "\(body.firstName) \(body.lastName)",
                    loginName:"@\(body.userName)",
                    bio: body.bio)
                self.profile = profile
                self.task = nil
                completion(.success(profile))
            case .failure(let error):
                self.lastToken = nil
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
}

