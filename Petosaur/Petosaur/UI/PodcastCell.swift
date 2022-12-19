//
//  PodcastCell.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import UIKit

final class PodcastCell: UITableViewCell {
    
    private let artImageSize: CGFloat = 80.0
    private var artImagePixelSize: CGFloat {
        artImageSize * UIScreen.main.scale
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var publisherLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var artImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureImageView()
        configureLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String, publisher: String, imageURL: URL?) {
        titleLabel.text = title
        publisherLabel.text = publisher
        setImage(from: imageURL)
    }
    
    private func configureImageView() {
        addSubview(artImage)
        
        let imageHeightConstraint = artImage.heightAnchor.constraint(equalToConstant: artImageSize)
        imageHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            artImage.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            artImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            imageHeightConstraint,
            artImage.widthAnchor.constraint(equalToConstant: artImageSize),
            artImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func configureLabels() {
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: artImage.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            titleLabel.topAnchor.constraint(equalTo: artImage.topAnchor, constant: 8)
        ])
        
        addSubview(publisherLabel)
        NSLayoutConstraint.activate([
            publisherLabel.leadingAnchor.constraint(equalTo: artImage.trailingAnchor, constant: 8),
            publisherLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            publisherLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor)
        ])
    }
    
    private func setImage(from url: URL?) {
        guard let url = url else {
            setFallbackImage()
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let image = self?.loadResizedImage(from: url) else {
                self?.setFallbackImage()
                return
            }
            DispatchQueue.main.async {
                self?.artImage.image = image
            }
        }
    }
    
    private func loadResizedImage(from url: URL) -> UIImage? {
        guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil) else {
            return nil
        }
        
        let options: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceThumbnailMaxPixelSize: artImagePixelSize
        ]
        
        if let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) {
            return UIImage(cgImage: image)
        } else {
            return nil
        }
    }
    
    private func setFallbackImage() {
        DispatchQueue.main.async {
            self.artImage.image = UIImage(named: "NoData")
        }
    }
}
