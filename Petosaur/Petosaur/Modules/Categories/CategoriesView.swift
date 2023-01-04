//
//  CategoriesView.swift
//  Petosaur
//
//  Created by h8wait on 04.01.2023.
//

import SwiftUI

struct CategoriesView: View {
    
    @ObservedObject var adapter: CategoriesViewAdapter
    
    var body: some View {
        List(adapter.categories, id: \.self) { category in
            Text(category).onTapGesture {
                adapter.presenter?.categoryDidTap(name: category)
            }
        }.onAppear {
            adapter.presenter?.viewDidLoad()
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(adapter: CategoriesViewAdapter())
    }
}
