//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 20.11.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .ypBlack
        tabBar.tintColor = .ypWhite
        
        let presenterImagesList = ImagesListViewPresenter()
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.configure(presenterImagesList)
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        let presenterProfile = ProfileViewPresenter()
        profileViewController.configure(presenterProfile)
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
                                    
        self.viewControllers = [imagesListViewController,profileViewController]
    }

}
