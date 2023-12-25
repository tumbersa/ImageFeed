//
//  ImageListViewHelper.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 25.12.2023.
//

import UIKit

protocol ImagesListViewHelperProtocol: AnyObject{
    func makeAlert() -> UIAlertController
    func newIndexPaths(oldCount: Int,newCount: Int) -> [IndexPath]?
}

final class ImagesListViewHelper: ImagesListViewHelperProtocol {
    func makeAlert() -> UIAlertController{
        let alert = UIAlertController(
            title: "Что-то пошло не так 🙂",
            message: nil,
            preferredStyle: .alert)
        let action = UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: { _ in
            })
        alert.addAction(action)
        
        return alert
    }
    
    
    func newIndexPaths(oldCount: Int,newCount: Int) -> [IndexPath]? {
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: 0)
            }
            return indexPaths
        }
        return nil
    }
}
