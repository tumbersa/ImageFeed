//
//  OAuthTokenResponceBody.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 22.11.2023.
//

import Foundation

struct OAuthTokenResponceBody:Decodable {
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
