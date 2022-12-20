//
//  CategoriesProtocols.swift
//  Petosaur
//
//  Created by h8wait on 20.12.2022.
//

import Foundation
import UIKit

protocol CategoriesModuleBuilderProtocol: AnyObject {
    
    func createCategoriesModule(currentCategoryName: String?,
                                output: CategoriesModuleOutputProtocol?) -> UIViewController
}

protocol CategoriesModuleOutputProtocol: AnyObject {
    
    func categoryDidChange(categoryName: String?)
}
