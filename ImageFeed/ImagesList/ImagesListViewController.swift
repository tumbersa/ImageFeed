//
//  ViewController.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 06.10.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

class ImagesListViewController: UIViewController {
    private let imagesListService = ImagesListService.shared
    private var photos: [Photo] = []
    
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
        imagesListService.fetchPhotosNextPage()
        
    }
    
    
    func updateTableViewAnimated(){
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.backgroundColor = .ypBlack
        cell.selectionStyle = .none
        
        let url = URL(string:  photos[indexPath.row].thumbImageURL)
        guard let url else { return }
        
        let imageLoading = UIImage(named: "stub")
        if let data = imageLoading?.pngData() {
            cell.cellImage.kf.indicatorType = .image(imageData: data)
        }
        
        cell.cellImage.kf.setImage(with: url){[weak self] _ in
            guard let self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        cell.dateLabel.text = dateFormatter.string(from: Date())
        if indexPath.row % 2 == 0 {
            cell.likeButton.setImage(UIImage(named: "Active Like"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "No Active Like"), for: .normal)
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
        return photos.count
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
        if imagesListService.photos.count == indexPath.row + 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
   
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = SingleImageViewController()
        
        var image: UIImage = UIImage(named: "stub") ?? UIImage()
        let url = URL(string:  self.photos[indexPath.row].largeImageURL)
        guard let url else { return }
        ProgressHUD.animate("Please wait...", .barSweepToggle)
        KingfisherManager.shared.retrieveImage(with: url){result in
            switch result{
            case .success(let successResult):
                DispatchQueue.main.async {
                    image = successResult.image
                    viewController.image = image
                    ProgressHUD.dismiss()
                }
            case .failure(let error):
                print(error)
            }
        }
        
        
        viewController.image = image
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        
        return imageSize.height * ( tableView.frame.width / imageSize.width)
    }
}
