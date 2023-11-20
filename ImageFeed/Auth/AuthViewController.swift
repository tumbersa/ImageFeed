//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 03.11.2023.
//

import UIKit


final class AuthViewController: UIViewController {
    weak var delegate: AuthViewControllerDelegate?
    
    private let showWebViewindentifier = "ShowWebView"
    
    private lazy var logoImageView: UIImageView = {
        let logoImage = UIImage(named: "logo_of_unsplash")
        var logoImageView = UIImageView(image: logoImage)
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        return logoImageView
    }()
    private lazy var loginButton: UIButton = {
        var loginButton = UIButton()
        loginButton.backgroundColor = .ypWhite
        
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(.ypBlack, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 16
        
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
       
        return loginButton
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewindentifier {
            guard let viewController = segue.destination  as? WebViewViewController
            else { fatalError("Failed to prepare for \(showWebViewindentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        congigScreen()
    }
    
    @objc private func didTapLoginButton(){
        performSegue(withIdentifier: showWebViewindentifier, sender: nil)
    }
    private func congigScreen(){
        view.backgroundColor = .ypBlack
        _ = loginButton
        _ = logoImageView
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(didAuthenticateWithCode code: String,_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
        delegate?.authViewController(didAuthenticateWithCode: code, self)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true, completion: nil)
    }
}


