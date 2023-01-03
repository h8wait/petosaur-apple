//
//  CategoriesRouter.swift
//  Petosaur
//
//  Created by h8wait on 03.01.2023.
//

import UIKit

final class CategoriesRouter: CategoriesRouterProtocol {
    
    weak var viewController: UIViewController?
    
    func closeModule() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
