//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 17.11.2023.
//

import Foundation

struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio: String?
}

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
                completion(.success(profile))
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

struct ProfileResult: Decodable {
    let firstName: String
    let lastName: String
    let bio: String?
    let userName: String
    
    enum CodingKeys:String, CodingKey {
        case bio
        case userName = "username"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
