//
//  ProfileAlertConfiguration.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 25.12.2023.
//

import Foundation

struct ProfileAlertConfiguration {
    let titleAlert: String
    let messageAlert: String
    let titleYesButton: String
    let titleNoButton: String
    
    static var standard:ProfileAlertConfiguration {
        return ProfileAlertConfiguration(
            titleAlert: Constants.titleLogoutAlertStandard,
            messageAlert: Constants.messageLogoutAlertStandard,
            titleYesButton: Constants.titleLogoutYesButtonStandard,
            titleNoButton: Constants.titleLogoutNoButtonStandard)
    }
}
