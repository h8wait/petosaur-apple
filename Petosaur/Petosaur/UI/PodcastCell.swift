//
//  PodcastCell.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import UIKit
import SnapKit

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
        return label
    }()
    
    private lazy var publisherLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
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
        artImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.height.equalTo(artImageSize).priority(.high)
            make.width.equalTo(artImageSize)
            make.leading.equalToSuperview().offset(16)
        }
    }
    
    private func configureLabels() {
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(artImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(artImage.snp.top).offset(8)
        }
        
        addSubview(publisherLabel)
        publisherLabel.snp.makeConstraints { make in
            make.leading.equalTo(artImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(titleLabel.snp.bottom)
        }
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
