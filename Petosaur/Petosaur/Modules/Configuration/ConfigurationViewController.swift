//
//  ConfigurationViewController.swift
//  Petosaur
//
//  Created by h8wait on 20.12.2022.
//

import UIKit
import SnapKit

final class ConfigurationViewController: UIViewController, ConfigurationViewProtocol {
    
    private lazy var topStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            categoriesButton,
            titleTextField
        ])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private lazy var titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Filter by title"
        field.borderStyle = .roundedRect
        return field
    }()
    
    private lazy var categoriesButton: UIButton = {
        let button = UIButton()
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(categoriesButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            saveButton,
            resetButton
        ])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    private lazy var resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(resetButtonClicked), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        button.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        return button
    }()
    
    var presenter: ConfigurationPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Search configuration"
        
        configureTopStack()
        configureBottomStack()
        
        presenter?.viewDidLoad()
    }
    
    func setTitleText(title: String?) {
        titleTextField.text = title
    }
    
    func setCategoryText(category: String?) {
        if category?.isEmpty ?? true {
            categoriesButton.setTitle("Select category...", for: .normal)
            categoriesButton.setTitleColor(.lightGray, for: .normal)
        } else {
            categoriesButton.setTitle(category, for: .normal)
            categoriesButton.setTitleColor(.black, for: .normal)
        }
    }
    
    private func configureTopStack() {
        view.addSubview(topStack)
        topStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
        }
    }
    
    private func configureBottomStack() {
        view.addSubview(bottomStack)
        bottomStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
    }
    
    @objc private func categoriesButtonClicked() {
        presenter?.categoryButtonDidTap()
    }
    
    @objc private func saveButtonClicked() {
        presenter?.titleDidUpdate(title: titleTextField.text)
        presenter?.saveButtonDidTap()
    }
    
    @objc private func resetButtonClicked() {
        presenter?.resetButtonDidTap()
    }
}
