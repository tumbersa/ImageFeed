//
//  Photo.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 30.11.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct ChangeLikeResult: Decodable {
    let photo: PhotoResult
}

struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: UrlsResult
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey{
        case id, width, height
        case createdAt = "created_at"
        case description, urls
        case isLiked = "liked_by_user"
    }
}

struct UrlsResult: Decodable {
    let full: String
    let thumb: String
}
