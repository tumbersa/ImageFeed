//
//  ImagesListDoubles.swift
//  ImageFeedTests
//
//  Created by Глеб Капустин on 27.12.2023.
//
@testable import ImageFeed
import Foundation

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    static var shared: ImageFeed.ImagesListServiceProtocol = ImagesListServiceSpy()
    
    var photos: [ImageFeed.Photo] = [Photo(
        id: "",
        size: CGSize(),
        createdAt: nil,
        welcomeDescription: nil,
        thumbImageURL: "",
        largeImageURL: "",
        isLiked: false)]
    
    var viewDidLoadCalled = false
    
    func fetchPhotosNextPage() {
        viewDidLoadCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        
    }
}
