//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 20.10.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
    }
}

