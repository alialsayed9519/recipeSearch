//
//  searchViewModel.swift
//  recipeSearch
//
//  Created by Ali on 09/08/2022.
//

import Foundation

class SearchViewModel {
    var networkService: NetworkService!
    var recipes : [Hit]! {
        didSet {
            self.bindRecipesToView()
        }
    }
    var showError : String! {
        didSet{
            self.bindRecipesErrorToView()
        }
    }
    
    var bindRecipesToView : (()->()) = {}
    var bindRecipesErrorToView : (()->()) = {}

    init() {
        networkService = NetworkService()
    }
       
    func fetchAllRecipes(q: String?, healthFilter: String, from: Int = 0, to: Int = 10) {
        networkService.getAllRecipes(q: q!, healthFilter: healthFilter, from: from, to: to) { data, error in
            if let errorMessage = error {
                self.showError = errorMessage
            } else {
                self.recipes = data?.hits
            }
        }
    }
    
    func getNextRecipePage(q: String?, healthFilter: String, to: Int) {
        networkService.getAllRecipes(q: q!, healthFilter: healthFilter, from: to, to: to + 10) { data, error in
            if let errorMessage = error {
                self.showError = errorMessage
            } else {
                for recipe in data!.hits {
                    self.recipes.append(recipe)
                }
            }
        }
    }
    
    
}
