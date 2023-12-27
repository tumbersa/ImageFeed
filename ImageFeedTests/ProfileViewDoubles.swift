//
//  ProfileViewDoubles.swift
//  ImageFeedTests
//
//  Created by Глеб Капустин on 27.12.2023.
//
@testable import ImageFeed
import UIKit

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    weak var service: ImageFeed.ProfileImageServiceProtocol?
    
    weak var view: ImageFeed.ProfileViewControllerProtocol?
    var cleanCalled = false
    func makeLogoutAlert() -> UIAlertController {
        return UIAlertController()
    }
    
    func clean() {
        cleanCalled = true
    }
    
    func makeProfileImageURL() -> URL? {
        return nil
    }
    
    
}

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    var avatarURL: String?
}
