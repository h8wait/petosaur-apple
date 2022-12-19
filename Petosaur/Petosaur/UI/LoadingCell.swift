//
//  LoadingCell.swift
//  Petosaur
//
//  Created by h8wait on 19.12.2022.
//

import UIKit
import SnapKit

final class LoadingCell: UITableViewCell {
    
    private lazy var spinner = UIActivityIndicatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func startAnimating() {
        spinner.startAnimating()
    }
}
