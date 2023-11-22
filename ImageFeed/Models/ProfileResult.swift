//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 22.11.2023.
//

import Foundation

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

struct Profile {
    let userName: String
    let name: String
    let loginName: String
    let bio: String?
}
