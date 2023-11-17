//
//  UIBlockingProgressHUD.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 17.11.2023.
//

import UIKit
import ProgressHUD

final class UIBlockingProgressHUD {
    private static var window: UIWindow? {
        return UIApplication.shared.windows.first
    }
    
    static func show(){
        window?.isUserInteractionEnabled = false
        ProgressHUD.animate("Please wait...", .barSweepToggle)
    }
    
    static func dismiss(){
        window?.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}