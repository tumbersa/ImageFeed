//
//  ImagesListCellDelegate.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 02.12.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
