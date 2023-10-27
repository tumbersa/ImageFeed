//
//  UIColor + Extentions.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 27.10.2023.
//

import UIKit

#if swift(<5.9)
extension UIColor {
    static var ypBlack: UIColor { UIColor(named: "YP Black") ?? UIColor.black}
    static var ypWhite: UIColor { UIColor(named: "YP White") ?? UIColor.white}
    static var ypGray: UIColor { UIColor(named: "YP Gray") ?? UIColor.gray}
    static var ypRed: UIColor { UIColor(named: "YP Red") ?? UIColor.red}
}
#endif
