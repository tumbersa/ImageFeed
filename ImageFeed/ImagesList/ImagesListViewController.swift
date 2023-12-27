//
//  ViewController.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 06.10.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListViewPresenterProtocol? { get set}
    
    func showAlert()
}
class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .ypBlack
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        return tableView
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlack
        _ = tableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        NotificationCenter.default.addObserver(
            forName: Notification.Name.didChangeNotificationImages,
            object: nil,
            queue: .main) {[weak self] _ in
                guard let self else { return }
                self.updateTableViewAnimated()
            }
        
        presenter?.viewDidLoad()
    }
    
    
    func updateTableViewAnimated(){
        guard let indexPaths = presenter?.newIndexPaths() else {
            return
        }
            
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        }
    }
    
    func configure(_ presenter: ImagesListViewPresenterProtocol){
        self.presenter = presenter
        presenter.view = self
        presenter.helper = ImagesListViewHelper()
    }
}

//MARK: - configCell
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.backgroundColor = .ypBlack
        cell.selectionStyle = .none
        cell.delegate = self
        guard let presenter else { return }
        
        let url = URL(string:  presenter.getPhoto(indexPath).thumbImageURL)
        let imageLoading = UIImage(named: "stub")
        if let data = imageLoading?.pngData() {
            cell.cellImage.kf.indicatorType = .image(imageData: data)
        }
        
        cell.cellImage.kf.setImage(with: url){[weak self] _ in
            guard let self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        if let dateToString = presenter.getPhoto(indexPath).createdAt {
            cell.dateLabel.text = dateFormatter.string(from: dateToString)
        } else {
            cell.dateLabel.text = ""
        }
        
        if presenter.getPhoto(indexPath).isLiked {
            cell.likeButton.setImage(UIImage(named: "Active Like"), for: .normal)
            cell.likeButton.accessibilityIdentifier = "LikeButtonOn"
        } else {
            cell.likeButton.setImage(UIImage(named: "No Active Like"), for: .normal)
            cell.likeButton.accessibilityIdentifier = "LikeButtonOff"
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = cell.cellGradient.bounds
        gradient.colors = [
            UIColor(red: 26.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.01).cgColor,
            UIColor(red: 26.0 / 255.0, green: 27.0 / 255.0, blue: 34.0 / 255.0, alpha: 0.05).cgColor]
        cell.cellGradient.layer.insertSublayer(gradient, at: 0)
    }
    
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.photosCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.willDisplayCell(indexPath: indexPath)
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SingleImageViewController()
        
        guard let presenter else { return }
        viewController.fullImageUrl = presenter.getPhoto(indexPath).largeImageURL
        
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter else { return 0}
        let imageSize = presenter.getPhoto(indexPath).size
        
        return imageSize.height * ( tableView.frame.width / imageSize.width)
    }
}

//MARK: - ImagesListCellDelegate
extension ImagesListViewController:ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
       presenter?.tappedLike(cell, indexPath)
    }
    
    func showAlert(){
        if let alert = presenter?.makeAlert() {
            self.present(alert, animated: true)
        }
    }
    
}
