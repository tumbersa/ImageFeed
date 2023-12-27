//
//  WebViewDoubles.swift
//  ImageFeedTests
//
//  Created by Глеб Капустин on 27.12.2023.
//
@testable import ImageFeed
import Foundation

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
