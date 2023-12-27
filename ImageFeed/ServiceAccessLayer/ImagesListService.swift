//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 30.11.2023.
//

import Foundation

protocol ImagesListServiceProtocol {
    static var shared: ImagesListServiceProtocol { get }
    var photos: [Photo] {get }
    
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

class ImagesListService: ImagesListServiceProtocol {
    static let shared: ImagesListServiceProtocol = ImagesListService()
    
    private init (){
        dateFormatter.formatOptions = [.withInternetDateTime]
    }
    private let dateFormatter = ISO8601DateFormatter()
    private let urlSession = URLSession.shared
    private let token = OAuth2TokenStorage().token
    
    private var prevTask: URLSessionTask?
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if prevTask != nil {
            return
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        lastLoadedPage = nextPage
        
        var request = URLRequest.makeHTTPRequest(path: "/photos?page=\(nextPage)")
        
        setToken(request: &request)
        
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result{
            case .success(let photoResults):
                for i in 0...(photoResults.count - 1) {
                    let photoResult = photoResults[i]
                    
                    var datePhoto: Date? = nil
                    
                    if let dateString = photoResult.createdAt,
                       let date = dateFormatter.date(from: dateString) {
                        datePhoto = date
                    }
                    
                    let photo = Photo(
                        id: photoResult.id,
                        size: CGSize(width: photoResult.width, height: photoResult.height),
                        createdAt: datePhoto,
                        welcomeDescription: photoResult.description,
                        thumbImageURL: photoResult.urls.thumb,
                        largeImageURL: photoResult.urls.full,
                        isLiked: photoResult.isLiked)
                    self.photos.append(photo)
                }
                self.prevTask = nil
                
                NotificationCenter.default.post(
                    name: Notification.Name.didChangeNotificationImages,
                    object: self,
                    userInfo: ["Photo": photos as Any])
                
            case .failure(let error):
                self.prevTask = nil
                print(error)
            }
        }
        
        self.prevTask = task
        task.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(photoId)/like",
            httpMethod: isLike ? "POST" : "DELETE")
        
        setToken(request: &request)
        
        let task = urlSession.objectTask(for: request) { (result:Result<ChangeLikeResult, Error>) in
            switch result{
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    
    private func setToken( request: inout URLRequest){
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    }
}


