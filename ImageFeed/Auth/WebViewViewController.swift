//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 03.11.2023.
//

import UIKit
import WebKit


fileprivate let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

final class WebViewViewController:UIViewController{
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: {[weak self] _, _ in
                 guard let self else { return }
                 self.updateProgress()
             })
        
        loadWebView()
       
        updateProgress()
    }
    
    private func updateProgress(){
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(didAuthenticateWithCode: code,self)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url,
           let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == pathToGetCode,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: {$0.name == "code"})
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
}

private extension WebViewViewController {
    private func loadWebView(){
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
        URLQueryItem(name: "client_id", value: accessKey),
        URLQueryItem(name: "redirect_uri", value: redirectURI),
        URLQueryItem(name: "response_type", value: "code"),
        URLQueryItem(name: "scope", value: accessScope)
        ]
        guard let url = urlComponents.url else {
            fatalError("There is no url in url components")
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
