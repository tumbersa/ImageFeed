//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Глеб Капустин on 09.10.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    lazy var cellImage: UIImageView = {
        let cellImage = UIImageView()
        cellImage.contentMode = .scaleAspectFill
        cellImage.layer.masksToBounds = true
        cellImage.layer.cornerRadius = 16
        contentView.addSubview(cellImage)
        cellImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4)
            
        ])
        return cellImage
    }()
    
    lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.textColor = .ypWhite
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellImage.trailingAnchor, constant: -8)
        ])
        return dateLabel
    }()
    
    lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        //likeButton.contentMode = .scaleToFill
        contentView.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor)
        ])
        return likeButton
    }()
    
    lazy var cellGradient: UIView = {
        let cellGradient = UIView()
       // cellGradient.contentMode = .scaleToFill
        
        cellGradient.layer.masksToBounds = true
        cellGradient.layer.cornerRadius = 16
        cellGradient.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
     
        contentView.addSubview(cellGradient)
        cellGradient.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellGradient.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor),
            cellGradient.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor),
            cellGradient.topAnchor.constraint(equalTo: dateLabel.topAnchor),
            cellGradient.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
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
    private func configCell(){
        contentView.backgroundColor = .ypBlack
        _ = cellImage
        _ = dateLabel
        _ = likeButton
        _ = cellGradient
    }
}
