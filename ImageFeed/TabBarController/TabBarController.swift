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
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imagesListViewController = ImagesListViewController()
        imagesListViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_editorial_active"),
            selectedImage: nil)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
                                    
        self.viewControllers = [imagesListViewController,profileViewController]
    }

}
