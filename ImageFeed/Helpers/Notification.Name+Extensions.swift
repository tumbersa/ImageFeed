//
//  Notification.Name+Extensions.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 22.11.2023.
//

import Foundation

extension Notification.Name {
    static let didChangeNotificationProfile =
    Notification.Name("ProfileImageProviderDidChange")
    
    static let didChangeNotificationImages =
    Notification.Name("ImagesListServiceDidChange")
}
