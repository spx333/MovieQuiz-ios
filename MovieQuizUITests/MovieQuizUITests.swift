//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Сергей Петров on 09.01.2026.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
        
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
        
    }
    
    func testYesButton() {
        sleep(2)
        
        let firstPoster = app.images["Poster"]
        let firstPoaterData = firstPoster.screenshot().pngRepresentation
        XCTAssertTrue(firstPoster.exists)
        
        app.buttons["Yes"].tap()
        
        sleep(2)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        XCTAssertTrue(secondPoster.exists)
        
        XCTAssertFalse(firstPoster == secondPoster)
        XCTAssertNotEqual(firstPoaterData, secondPosterData)
        
    }

    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
