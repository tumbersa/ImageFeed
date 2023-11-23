//
//  UserResults.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 22.11.2023.
//

import Foundation

struct UserResults: Decodable {
    let profileImage: UserResult
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct UserResult: Decodable {
    let small: String?
}
