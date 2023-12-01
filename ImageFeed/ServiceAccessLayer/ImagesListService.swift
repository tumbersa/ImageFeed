//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 30.11.2023.
//

import Foundation

class ImagesListService{
    static let shared = ImagesListService()
    
    private let urlSession = URLSession.shared
    private let token = OAuth2TokenStorage().token
    
    private var prevTask: URLSessionTask?
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    func fetchPhotosNextPage(_ completion: @escaping (Result<[Photo], Error>) -> Void){
        assert(Thread.isMainThread)
        if prevTask != nil {
            return
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        lastLoadedPage = nextPage
        
        var request = URLRequest.makeHTTPRequest(path: "/photos?page=\(nextPage)")
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result{
            case .success(let photoResults):
                for i in 0...(photoResults.count - 1) {
                    let photoResult = photoResults[i]
                    
                    var datePhoto: Date? = nil
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
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
                
                completion(.success(photos))
            case .failure(let error):
                self.prevTask = nil
                completion(.failure(error))
            }
        }
        
        self.prevTask = task
        task.resume()
    }
    
}


