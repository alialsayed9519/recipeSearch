//
//  DetailsViewControllerTests.swift
//  recipeSearchTests
//
//  Created by Ali on 22/01/2023.
//

import XCTest
@testable import recipeSearch

class DetailsViewControllerTests: XCTestCase {
    
    func test_outlets_shouldBeConnected() {
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        let sut: DetailsViewController = storybord.instantiateViewController(identifier: "DetailsViewController")
        
        sut.recipe = Recipe(image: "", title: "Fish", source: "", url: "", healthLabels: [], ingredientLines: [])
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.ingredientLinesTableView, "ingredientLinesTableView")
        XCTAssertNotNil(sut.recipeImage, "recipeImage")
        XCTAssertNotNil(sut.recipeTitle, "recipeTitle")
    }

}
