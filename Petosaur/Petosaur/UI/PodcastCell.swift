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
    
    private lazy var spinner = UIActivityIndicatorView()
    
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
        
        addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.centerX.equalTo(artImage)
            make.centerY.equalTo(artImage)
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
            setImage(nil)
            return
        }
        
        artImage.image = nil
        spinner.startAnimating()
        
        Task {
            let image = await loadResizedImage(from: url)
            setImage(image)
        }
    }
    
    private func setImage(_ image: UIImage?) {
        artImage.image = image ?? UIImage(named: "NoData")
        spinner.stopAnimating()
    }
    
    private func loadResizedImage(from url: URL) async -> UIImage? {
        let artImagePixelSize = artImageSize * UIScreen.main.scale
        
        return await withUnsafeContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil) else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let options: [CFString: Any] = [
                    kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                    kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceShouldCacheImmediately: true,
                    kCGImageSourceThumbnailMaxPixelSize: artImagePixelSize
                ]
                
                if let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) {
                    continuation.resume(returning: UIImage(cgImage: image))
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
