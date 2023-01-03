//
//  CategoriesInteractor.swift
//  Petosaur
//
//  Created by h8wait on 03.01.2023.
//

import PetosaurKit

final class CategoriesInteractor: CategoriesInteractorProtocol {
    
    private let categoriesProvider: CategoriesProviderProtocol
    weak var presenter: CategoriesPresenterProtocol?
    
    init(categoriesProvider: CategoriesProviderProtocol) {
        self.categoriesProvider = categoriesProvider
    }
    
    func fetchCategories() {
        categoriesProvider.getAll { [weak self] result in
            switch result {
            case .success(let models):
                self?.presenter?.categoriesDidLoad(items: models.map { $0.name })
            case .failure:
                self?.presenter?.categoriesDidFail()
            }
        }
    }
}
