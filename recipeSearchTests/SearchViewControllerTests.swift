//
//  SearchViewControllerTests.swift
//  recipeSearchTests
//
//  Created by Ali on 22/01/2023.
//

import XCTest
@testable import recipeSearch
import ViewControllerPresentationSpy

class SearchViewControllerTests: XCTestCase {
    private var sut: SearchViewController!
    private var alertVerfier: AlertVerifier!
    
    override func setUp() {
        super.setUp()
        alertVerfier = AlertVerifier()
        let storybord = UIStoryboard(name: "Main", bundle: nil)
        sut = storybord.instantiateViewController(identifier: "SearchViewController")
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        alertVerfier = nil
        super.tearDown()
    }
    
    func test_outlets_shouldBeConnected() {
        XCTAssertNotNil(sut.all, "all")
    }
    
    func test_allBtn_shouldReturnTheSameSelectedButton() {
        tab(sut.all)
        
        XCTAssertEqual(sut.currentSelectedHealthFilterBtn, sut.all)
    }
    
    func test_onFailUpdateView_shouldShowAlert() {
        sut.onFailUpdateView()
        alertVerfier.verify(title: "error", message: "can't load data check internet connection", animated: true, actions: [.default("Ok")], presentingViewController: sut)
        
        XCTAssertEqual(alertVerfier.title, "error")
    }
        
}
