//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 19.10.2023.
//

import UIKit
import Kingfisher


protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set}
    
    func logout()
}


final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    var presenter: ProfileViewPresenterProtocol?
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward") ?? UIImage(),
            target: self,
            action: #selector(didTapLogoutButton))
        button.tintColor = .ypRed
        button.accessibilityIdentifier = "LogoutButton"
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return nameLabel
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .ypGray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return loginNameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
         let descriptionLabel = UILabel()
         descriptionLabel.text = "Hello, world!"
         descriptionLabel.textColor = .ypWhite
         descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return descriptionLabel
    }()
    
   
    override func loadView() {
        super.loadView()
        configScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypBlack
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name.didChangeNotificationProfile,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            })
        updateAvatar()
    }
    
    
    private func updateAvatar(){
        let url = presenter?.makeProfileImageURL()
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder_avatar_image"),
            options: [.processor(processor)]
        )
    }
    
    @objc private func didTapLogoutButton(){
        if let alert = presenter?.makeLogoutAlert() {
            present(alert, animated: true)
        }
    }
    
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func configScreen(){
        [
            avatarImageView,
            logoutButton,
            nameLabel,
            descriptionLabel,
            loginNameLabel
        ].forEach { subView in
            view.addSubview(subView)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        ])
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            view.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor, constant: 16),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
    }
    
    func configure(_ presenter: ProfileViewPresenterProtocol) {
        presenter.service = ProfileImageService.shared
        self.presenter = presenter
        presenter.view = self
    }
    
    func logout(){
        presenter?.clean()
        
        let window = UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }.first
        guard let window else {
            assertionFailure("Invalid Configuration")
            return
        }
        let splashViewController = SplashViewController()
        window.rootViewController = splashViewController
    }
}
