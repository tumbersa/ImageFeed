//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 03.11.2023.
//

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController,didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
