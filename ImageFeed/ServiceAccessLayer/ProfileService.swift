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
    
    private var prevTask: URLSessionTask?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void){
        assert(Thread.isMainThread)
        if let prevTask {
            return
        }
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
                self.prevTask = nil
                completion(.success(profile))
            case .failure(let error):
                self.prevTask = nil
                completion(.failure(error))
            }
        }
        self.prevTask = task
        task.resume()
    }
}

