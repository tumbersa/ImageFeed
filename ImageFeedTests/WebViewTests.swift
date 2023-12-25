//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Глеб Капустин on 23.12.2023.
//

@testable import ImageFeed
import XCTest

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    weak var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}

final class WebViewControllerSpy: WebViewViewControllerProtocol {
    var loadCalled = false
    var presenter: ImageFeed.WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}

final class WebViewTests: XCTestCase {

    func testViewControllerCallsViewDidLoad(){
        //Given
        let viewController = WebViewViewController()
        let presenter = WebViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCalledLoadRequest(){
        //Given
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let viewController = WebViewControllerSpy()
        presenter.view = viewController
        
        //When
        presenter.viewDidLoad()
        
        //Then
        XCTAssertTrue(viewController.loadCalled)
    }
    
    func testProgressVisibleWhenLessThenOne(){
        //Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //Then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne(){
        //Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1.0
        
        //When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //Then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL(){
        //Given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //When
        let url = authHelper.authUrl()
        let urlString = url.absoluteString
        
        //Then
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
    }
    
    func testCodeFromUrl(){
        //Given
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        urlComponents?.queryItems = [URLQueryItem(name: "code", value: "someCode")]
        guard let url = urlComponents?.url else {
            XCTFail()
            return
        }
        let authHelper = AuthHelper()
        
        //When
        let code = authHelper.code(from: url)
        
        //Then
        XCTAssertEqual(code, "someCode")
    }
}



