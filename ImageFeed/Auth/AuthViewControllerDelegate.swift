//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 05.11.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(didAuthenticateWithCode code: String)
}
