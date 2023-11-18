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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //oauth2TokenStorage.token = nil
        if let token = oauth2TokenStorage.token {
            UIBlockingProgressHUD.show()
            fetchProfile(token: token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    
    private func switchToTabBarController(){
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let viewController = segue.destination as?  AuthViewController else {
                fatalError("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(didAuthenticateWithCode code: String) {
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
                print(error.localizedDescription)
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
            }
        }
    }
    
    func fetchProfileImageURL(username: String){
        ProfileImageService.shared.fetchProfileImageURL(username: username){ result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(_):
            break
            }
        }
    }
}
