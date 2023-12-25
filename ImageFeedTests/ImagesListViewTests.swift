//
//  ImagesListViewTests.swift
//  ImageFeedTests
//
//  Created by Глеб Капустин on 25.12.2023.
//

@testable import ImageFeed
import XCTest

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


final class ImagesListViewTests: XCTestCase {
    
    func testNewIndexPaths(){
        //Given
        let presenter = ImagesListViewPresenter(imagesListService: ImagesListServiceSpy())
        presenter.helper = ImagesListViewHelper()
        //When
        let indexPaths = presenter.newIndexPaths()
        
        //Then
        XCTAssertEqual(indexPaths, [IndexPath(row: 0, section: 0)])
    }
    
    func testPhotosCount(){
        //Given
        let presenter = ImagesListViewPresenter(imagesListService: ImagesListServiceSpy())
        //When
        _ = presenter.newIndexPaths()
        let count = presenter.photosCount()
        //Then
        XCTAssertEqual(count, 1)
    }
    
    func testGetPhoto(){
        //Given
        let presenter = ImagesListViewPresenter(imagesListService: ImagesListServiceSpy())
        //When
        _ = presenter.newIndexPaths()
        let photo = presenter.getPhoto(IndexPath(row: 0, section: 0))
        //Then
        XCTAssertEqual(photo, Photo(
            id: "",
            size: CGSize(),
            createdAt: nil,
            welcomeDescription: nil,
            thumbImageURL: "",
            largeImageURL: "",
            isLiked: false))
    }
    
    func testViewDidLoadCalledService(){
        //Given
        let service = ImagesListServiceSpy()
        let presenter = ImagesListViewPresenter(imagesListService: service)
        //When
        presenter.viewDidLoad()
        //Then
        XCTAssertTrue(service.viewDidLoadCalled)
    }
    
    func testViewDidLoadCalledPresenter(){
        //Given
        let service = ImagesListServiceSpy()
        let presenter = ImagesListViewPresenter(imagesListService: service)
        let controller = ImagesListViewController()
        controller.presenter = presenter
        //When
        _ = controller.view
        //Then
        XCTAssertTrue(service.viewDidLoadCalled)
    }
    
    func testWillDisplayCell(){
        //Given
        let service = ImagesListServiceSpy()
        let presenter = ImagesListViewPresenter(imagesListService: service)
        //When
        presenter.willDisplayCell(indexPath: IndexPath(row: 0, section: 0))
        //Then
        XCTAssertTrue(service.viewDidLoadCalled)
    }
    
    func testMakeAlert(){
        //Given
        let presenter = ImagesListViewPresenter(imagesListService: ImagesListServiceSpy())
        presenter.helper = ImagesListViewHelper()
        //When
        guard let alert = presenter.makeAlert() else { return }
        
        //Then
        XCTAssertTrue(alert.title == "Что-то пошло не так 🙂")
        XCTAssertTrue((alert.actions.first(where: {$0.title == "OK"}) != nil))
    }
}
