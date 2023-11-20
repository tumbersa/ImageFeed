//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 05.11.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let profileService = ProfileService.shared
    
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()

    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let tabBarViewControllerIdentifier = "TabBarViewController"
    
    private lazy var imageFeedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .black
        imageView.image = UIImage(named: "image_feed_vector")
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 78).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 75).isActive = true
       
        return imageView
    }()
    
    override func loadView() {
        super.loadView()
        
        //oauth2TokenStorage.token = nil
        _ = imageFeedImageView
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .black
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            fetchProfile(token: token)
        } else {
            segueToFlowAuth()
        }
    }

    private func switchToTabBarController(){
       // self.dismiss(animated: true)
        
        let window = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }.first
        guard let window else {
            fatalError("Invalid Configuration")
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: tabBarViewControllerIdentifier)
        window.rootViewController = tabBarController
    }
}

extension SplashViewController {
    private func segueToFlowAuth(){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {
            fatalError("Failed to segue to AuthViewController")
        }
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(didAuthenticateWithCode code: String,_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        dismiss(animated: true) {[weak self] in
            guard let self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
}

extension SplashViewController {
    func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code, completion: {result in
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
                self.showAlert()
            }
        })
    }
    func fetchProfile(token: String) {
        ProfileService.shared.fetchProfile(token){[weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                if let username = self.profileService.profile?.userName {
                    self.fetchProfileImageURL(username: username)
                }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
                self.showAlert()
            }
        }
    }
    
    func fetchProfileImageURL(username: String){
        var profileImageURL: String? = nil
        ProfileImageService.shared.fetchProfileImageURL(username: username){ result in
            switch result {
            case .success(let imageUrl):
              profileImageURL = imageUrl
            case .failure(let error):
                print(error)
                self.showAlert()
            }
        }
        NotificationCenter.default.post(
            name: ProfileImageService.DidChangeNotification,
            object: self,
            userInfo: ["URL": profileImageURL as Any])
    }
}

extension SplashViewController {
    func showAlert(){
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: {[weak self] _ in
                guard let self else { return }
                self.performSegue(
                    withIdentifier: self.showAuthenticationScreenSegueIdentifier,
                    sender: nil)
            })
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
