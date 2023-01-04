//
//  CategoriesViewAdapter.swift
//  Petosaur
//
//  Created by h8wait on 04.01.2023.
//

import Foundation

final class CategoriesViewAdapter: ObservableObject {
    
    var presenter: CategoriesPresenterProtocol?
    
    @Published var categories = [String]()
}

extension CategoriesViewAdapter: CategoriesViewProtocol {
    
    func showCategories(items: [String]) {
        categories = items
    }
}
