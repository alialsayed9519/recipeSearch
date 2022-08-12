//
//  Constants.swift
//  recipeSearch
//
//  Created by Ali on 12/08/2022.
//

import Foundation

struct APIConfig {
    static let BASE_URL = "https://api.edamam.com/search"
    static let APP_ID = "801d35fe"
    static let APP_KEY = "fe57b827dfcb985a43e8819a6aa46898"
    static let FIELD_PARAM = ["label", "image", "source", "url", "healthLabels", "ingredientLines"]
}

struct ErrorMessages {
    static let NO_DATA_FOUND =  "no data found!"
    static let SEARCH_FAILED = "search failed, please try again!"
    static let TOO_MANY_REQUESTS = "too many requests, please try again!"
}

struct HealthFilters {
    static let LOW_SUGER = "low-sugar"
    static let KETO = "keto-friendly"
    static let VEGAN = "vegan"
}


