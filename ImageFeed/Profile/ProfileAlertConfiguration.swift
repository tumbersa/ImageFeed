//
//  ProfileAlertConfiguration.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 25.12.2023.
//

import Foundation

let titleAlertStandard = "Пока, пока!"
let messageAlertStandard = "Вы уверены, что хотите выйти?"
let titleYesButtonStandard = "Да"
let titleNoButtonStandard = "Нет"


struct ProfileAlertConfiguration {
    let titleAlert: String
    let messageAlert: String
    let titleYesButton: String
    let titleNoButton: String
    
    static var standard:ProfileAlertConfiguration {
        return ProfileAlertConfiguration(
            titleAlert: titleAlertStandard,
            messageAlert: messageAlertStandard,
            titleYesButton: titleYesButtonStandard,
            titleNoButton: titleNoButtonStandard)
    }
}
