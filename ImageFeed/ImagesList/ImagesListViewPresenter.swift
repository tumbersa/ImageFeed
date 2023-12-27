//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 25.12.2023.
//

import UIKit

protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol?{ get set}
    var helper: ImagesListViewHelperProtocol?{ get set}
    var imagesListService: ImagesListServiceProtocol { get }
    
    func viewDidLoad()
    func willDisplayCell(indexPath: IndexPath)
    func newIndexPaths() -> [IndexPath]?
    func getPhoto(_ indexPath: IndexPath) -> Photo
    func photosCount() -> Int
    func makeAlert() -> UIAlertController?
    func tappedLike(_ cell: ImagesListCell,_ indexPath: IndexPath)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    var helper: ImagesListViewHelperProtocol?
    weak var view: ImagesListViewControllerProtocol?
    private var photos: [Photo] = []
    let imagesListService: ImagesListServiceProtocol
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared){
        self.imagesListService = imagesListService
    }
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func willDisplayCell(indexPath: IndexPath) {
        if imagesListService.photos.count == indexPath.row + 1 {
            viewDidLoad()
        }
    }
    
    func newIndexPaths() -> [IndexPath]? {
        let oldCount = photos.count
        photos = imagesListService.photos
        return helper?.newIndexPaths(
            oldCount: oldCount,
            newCount: imagesListService.photos.count)
    }
    
    func getPhoto(_ indexPath: IndexPath) -> Photo{
        photos[indexPath.row]
    }
    
    func photosCount() -> Int {
        photos.count
    }
    
    func tappedLike(_ cell: ImagesListCell,_ indexPath: IndexPath)  {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(
            photoId: photo.id,
            isLike: !photo.isLiked) {[weak self] (result:Result<Void, Error>) in
                guard let self else {return}
                switch result{
                case .success():
                    cell.setIsLiked(!photo.isLiked)
                    self.updatePhotos(index: indexPath.row)
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    print(error)
                    cell.removeAnimations()
                    UIBlockingProgressHUD.dismiss()
                    view?.showAlert()
                }
            }
    }
    
    private func updatePhotos(index: Int){
        let photo = self.photos[index]
        
        let newPhoto = Photo(
            id: photo.id,
            size: photo.size,
            createdAt: photo.createdAt,
            welcomeDescription: photo.welcomeDescription,
            thumbImageURL: photo.thumbImageURL,
            largeImageURL: photo.largeImageURL,
            isLiked: !photo.isLiked
        )
        
        photos[index] = newPhoto
    }
    
    func makeAlert() -> UIAlertController? {
        helper?.makeAlert()
    }
}
