//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 03.11.2023.
//

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(didAuthenticateWithCode code: String,_ vc: WebViewViewController)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
