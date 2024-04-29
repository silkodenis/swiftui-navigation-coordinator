//
//  NavigationFlowUITests.swift
//  NavigationUITests
//
//  Created by Denis Silko on 26.04.2024.
//

import XCTest

final class NavigationFlowUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    // push
    func testNavigationForward() throws {
        verifyNavigationBarTitle(expectedTitle: "📙")
        
        navigateToNextScreen()
        verifyNavigationBarTitle(expectedTitle: "📕")
        
        navigateToNextScreen()
        verifyNavigationBarTitle(expectedTitle: "📗")
        
        navigateToNextScreen()
        verifyNavigationBarTitle(expectedTitle: "📘")
    }
    
    // pop
    func testNavigationBack() throws {
        navigateToNextScreen()  // To Red
        navigateToNextScreen()  // To Green
        navigateToNextScreen()  // To Blue
        
        navigateToPreviousScreen()
        verifyNavigationBarTitle(expectedTitle: "📗")
        
        navigateToPreviousScreen()
        verifyNavigationBarTitle(expectedTitle: "📕")
        
        navigateToPreviousScreen()
        verifyNavigationBarTitle(expectedTitle: "📙")
    }
    
    // popToRoot
    func testNavigationToRoot() throws {
        navigateToNextScreen()  // To Red
        navigateToNextScreen()  // To Green
        navigateToNextScreen()  // To Blue
        
        navigateToRootScreen() // To Orange
        verifyNavigationBarTitle(expectedTitle: "📙")
    }
    
    // .push(.blueBook(text: "🖼️"))
    func testBlueBookTitle() throws {
        navigateToNextScreen()  // To Red
        navigateToNextScreen()  // To Green
        navigateToNextScreen()  // To Blue
        verifyTitle(expectedTitle: "🖼️")
    }
    
    // .unwind(to: Screen.orangeBookSegue)
    func testUnwindToOrangeBook() throws {
        navigateToNextScreen()  // To Red
        verifyNavigationBarTitle(expectedTitle: "📕")
        unwindToScreenWith(expectedTitle: "📙")
    }
    
    // .unwind(to: Screen.redBookSegue, with: "🔭")
    func testUnwindToRedBook() throws {
        navigateToNextScreen()  // To Red
        navigateToNextScreen()  // To Green
        navigateToNextScreen()  // To Blue
        verifyNavigationBarTitle(expectedTitle: "📘")
        unwindToScreenWith(expectedTitle: "📕")
        verifyTitle(expectedTitle: "🔭")
    }
    
    // MARK: - Navigation Helpers
    
    private func navigateToNextScreen() {
        let pushButton = app.buttons[AccessibilityID.pushButton.rawValue]
        XCTAssertTrue(pushButton.waitForExistence(timeout: 5), 
                      "Push button should exist on the screen before tapping")
        pushButton.tap()
    }
    
    private func navigateToPreviousScreen() {
        let popButton = app.buttons[AccessibilityID.popButton.rawValue]
        XCTAssertTrue(popButton.waitForExistence(timeout: 5), 
                      "Pop button should exist on the screen before tapping")
        popButton.tap()
    }
    
    private func navigateToRootScreen() {
        let popToRootButton = app.buttons[AccessibilityID.popToRootButton.rawValue]
        XCTAssertTrue(popToRootButton.waitForExistence(timeout: 5), 
                      "PopToRoot button should exist on the screen before tapping")
        popToRootButton.tap()
    }
    
    private func unwindToScreenWith(expectedTitle: String) {
        let unwindButton = app.buttons[AccessibilityID.unwindButton.rawValue]
        XCTAssertTrue(unwindButton.waitForExistence(timeout: 5),
                      "Unwind button should exist on the screen before tapping")
        unwindButton.tap()
        verifyNavigationBarTitle(expectedTitle: expectedTitle)
    }

    private func verifyNavigationBarTitle(expectedTitle: String) {
        let navigationBar = app.navigationBars[expectedTitle]
        let exists = navigationBar.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Navigation bar should be \"\(expectedTitle)\"")
    }
    
    private func verifyTitle(expectedTitle: String) {
        let titleText = app.staticTexts[AccessibilityID.titleText.rawValue]
        let exists = titleText.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Title should be visible before checking text")
        XCTAssertEqual(titleText.label, expectedTitle, "Title should be \"\(expectedTitle)\"")
    }
}
