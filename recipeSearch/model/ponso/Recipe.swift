//
//  Recipe.swift
//  recipeSearch
//
//  Created by Ali on 09/08/2022.
//

import Foundation

struct AllRecipes: Codable {
    let from: Int
    let to: Int
    let more: Bool
    let count: Int
    let hits: [Hit]
}

struct Hit: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    let image: String
    var title: String
    let source: String
    let url: String
    let healthLabels: [String]
    var ingredientLines: [String]
    
    enum CodingKeys: String, CodingKey {
        case image
        case title = "label"
        case source
        case url
        case healthLabels
        case ingredientLines
    }
}
