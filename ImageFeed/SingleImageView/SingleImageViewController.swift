//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 20.10.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    var fullImageUrl: String = ""
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "Backward"), for: .normal)
        backButton.accessibilityIdentifier = "BackButton"
        return backButton
    }()
    
    private lazy var sharingButton: UIButton = {
        let sharingButton = UIButton()
        
        sharingButton.backgroundColor = .ypBlack
        sharingButton.layer.cornerRadius = 28
        sharingButton.setImage(UIImage(named: "Sharing"), for: .normal)
        return sharingButton
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setImage()
        
        scrollView.delegate = self
        configScreen()
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
    }
    
    private func setImage(){
        UIBlockingProgressHUD.show()
        let url = URL(string:fullImageUrl)
        guard let url else { return }
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showError()
            }
        }
    }
    
    func showError(){
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Попробовать ещё раз?",
            preferredStyle: .alert)
        let actionExit = UIAlertAction(
            title: "Не надо",
            style: .cancel) { [weak self] _ in
                guard let self else { return }
                self.didTapBackButton()
            }
        let actionReload = UIAlertAction(
            title: "Повторить",
            style: .default) { [weak self] _ in
                guard let self else { return }
                self.setImage()
            }
        alert.addAction(actionExit)
        alert.addAction(actionReload)
        
        alert.preferredAction = actionReload
        present(alert, animated: true)
    }

    
    private func configScreen(){
        view.backgroundColor = .ypBlack
        [
            scrollView,
            sharingButton,
            backButton
        ].forEach { subview in
            view.addSubview(subview)
        }
        scrollView.addSubview(imageView)
        
        backButton.addTarget(
            self,
            action: #selector(didTapBackButton),
            for: .touchUpInside)
        
        sharingButton.addTarget(
            self,
            action: #selector(didTapShareButton),
            for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints(){
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8)
        ])
        
        sharingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sharingButton.heightAnchor.constraint(equalToConstant: 55),
            sharingButton.widthAnchor.constraint(equalToConstant: 55),
            sharingButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            sharingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17)
        ])
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
     @objc private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapShareButton(){
        let vc = UIActivityViewController(activityItems: [self.imageView.image as Any], applicationActivities: nil)
        vc.popoverPresentationController?.sourceView = self.view
                
        self.present(vc, animated: true, completion: nil)
    }
   
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.maximumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale,max(minZoomScale,max(hScale,vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let leftMargin = (scrollView.bounds.width - scrollView.contentSize.width) * 0.5
        let topMargin = (scrollView.bounds.height - scrollView.contentSize.height) * 0.5
        scrollView.contentInset = UIEdgeInsets(top: topMargin, left: leftMargin, bottom: 0, right: 0)
    }
}
