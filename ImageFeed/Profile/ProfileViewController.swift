//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 19.10.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Avatar")
        view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward") ?? UIImage(),
            target: self,
            action: #selector(didTapLogoutButton))
        button.tintColor = .ypRed
        view.addSubview(button)
        return button
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        view.addSubview(nameLabel)
        return nameLabel
    }()
    
    private lazy var loginNameLabel: UILabel = {
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .ypGray
        loginNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        view.addSubview(loginNameLabel)
        return loginNameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
         let descriptionLabel = UILabel()
         descriptionLabel.text = "Hello, world!"
         descriptionLabel.textColor = .ypWhite
         descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
         view.addSubview(descriptionLabel)
        return descriptionLabel
    }()
    
    //Перегружаем конструктор
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        addObserver()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addObserver()
    }
    
    deinit {
        removeObserver()
    }
    
    
    private func addObserver(){
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateAvatar(notification:)),
            name: ProfileImageService.DidChangeNotification,
            object: nil)
    }
    
    private func removeObserver(){
        NotificationCenter.default.removeObserver(
            self,
            name: ProfileImageService.DidChangeNotification,
            object: nil)
    }
    
    @objc 
    private func updateAvatar(notification: Notification){
        guard 
            isViewLoaded,
            let userInfo = notification.userInfo,
            let profileImageURL = userInfo["URL"] as? String,
            let url = URL(string: profileImageURL)
        else { return }
        //TODO:  [Sprint 11] Обновить аватар, используя Kingfisher
    }
    
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
        
        if let avatarURL = ProfileImageService.shared.avatarURL,
           let url = URL(string: avatarURL) {
            //TODO: - [Sprint 11]  Обновить аватар, если нотификация
            // была опубликована до того, как мы подписались.
        }
        
    }
    
    @objc private func didTapLogoutButton(){
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func configScreen(){
        _ = avatarImageView
        _ = logoutButton
        _ = nameLabel
        _ = descriptionLabel
        _ = loginNameLabel
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
}
