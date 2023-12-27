//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 24.12.2023.
//

import UIKit
import WebKit

protocol ProfileViewPresenterProtocol: AnyObject {
    var view: ProfileViewControllerProtocol? { get set}
    var service: ProfileImageServiceProtocol? { get set}
    
    func makeLogoutAlert()-> UIAlertController
    func clean()
    func makeProfileImageURL() -> URL?
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var configuration: ProfileAlertConfiguration
    weak var view: ProfileViewControllerProtocol?
    weak var service: ProfileImageServiceProtocol?
    
    init(configuration: ProfileAlertConfiguration = .standard) {
        self.configuration = configuration
    }
    func makeLogoutAlert() -> UIAlertController{
        let alert = UIAlertController(
            title: configuration.titleAlert,
            message: configuration.messageAlert,
            preferredStyle: .alert)
        
        
        let actionStay = UIAlertAction(
            title: configuration.titleNoButton,
            style: .cancel)
        
        let actionLogout = UIAlertAction(
            title: configuration.titleYesButton,
            style: .default) {[weak view] _ in
                view?.logout()
            }
        
        actionLogout.accessibilityIdentifier = "AlertLogoutButton"
        alert.addAction(actionLogout)
        alert.addAction(actionStay)
        
        alert.preferredAction = actionStay
        
        
        return alert
    }
    
    func clean() {
        OAuth2TokenStorage.shared.token = nil
        // Очищаем все куки из хранилища.
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища.
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    
    func makeProfileImageURL() -> URL?{
        guard let profileImageURL = service?.avatarURL,
              let url = URL(string: profileImageURL)
        else { return nil}
        return url
    }
    
}
