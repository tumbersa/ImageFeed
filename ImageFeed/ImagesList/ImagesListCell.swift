//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 09.10.2023.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    
    static let reuseIdentifier = "ImagesListCell"
    
    lazy var cellImage: UIImageView = {
        let cellImage = UIImageView()
        cellImage.contentMode = .scaleAspectFill
        cellImage.layer.masksToBounds = true
        cellImage.layer.cornerRadius = 16
        return cellImage
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = .ypWhite
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return dateLabel
    }()
    
    lazy var likeButton: UIButton = {
        let likeButton = UIButton()
       
        return likeButton
    }()
    
    lazy var cellGradient: UIView = {
        let cellGradient = UIView()
        
        cellGradient.layer.masksToBounds = true
        cellGradient.layer.cornerRadius = 16
        cellGradient.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
       
        return cellGradient
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: ImagesListCell.reuseIdentifier)
        configCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configCell()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    private func configCell(){
        [
        cellImage,
        dateLabel,
        likeButton,
        cellGradient
        ].forEach { subview in
            contentView.addSubview(subview)
        }
    
        likeButton.addTarget(
            self,
            action: #selector(likeButtonClicked),
            for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints(){
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4)
            
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellImage.trailingAnchor, constant: -8)
        ])
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor)
        ])
        
        cellGradient.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellGradient.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            cellGradient.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            cellGradient.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            cellGradient.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc private func likeButtonClicked(){
        UIView.animateKeyframes(withDuration: 1, delay: 0,options: [.repeat]) {[weak self] in
            guard let self else { return }
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
                self.likeButton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.1) {
                self.likeButton.transform = .identity
            }
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.4) {
                self.likeButton.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) {
                self.likeButton.transform = .identity
            }
        }
        
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool){
        removeAnimations()
        if isLiked {
            likeButton.setImage(UIImage(named: "Active Like"), for: .normal)
            likeButton.accessibilityIdentifier = "LikeButtonOn"
        } else {
            likeButton.setImage(UIImage(named: "No Active Like"), for: .normal)
            likeButton.accessibilityIdentifier = "LikeButtonOff"
        }
            
    }
    
    func removeAnimations(){
        likeButton.layer.removeAllAnimations()
    }
}
