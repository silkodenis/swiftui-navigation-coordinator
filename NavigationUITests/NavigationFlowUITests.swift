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
    func testPushingWithValue() throws {
        navigateToNextScreen()  // To Red
        navigateToNextScreen()  // To Green
        navigateToNextScreen()  // To Blue
        verifyTitle(expectedTitle: "🖼️")
    }
    
    // .unwind(to: .orangeBookSegue)
    func testUnwindToOrangeBook() throws {
        navigateToNextScreen()  // To Red
        verifyNavigationBarTitle(expectedTitle: "📕")
        unwindToScreenWith(expectedTitle: "📙")
    }
    
    // .unwind(to: .redBookSegue, with: "🔭")
    func testUnwindToRedBookWithValue() throws {
        navigateToNextScreen()  // To Red
        navigateToNextScreen()  // To Green
        navigateToNextScreen()  // To Blue
        verifyNavigationBarTitle(expectedTitle: "📘")
        unwindToScreenWith(expectedTitle: "📕")
        verifyTitle(expectedTitle: "🔭")
    }
    
    func testPresentingModalScreen() throws {
        navigateToNextScreen()  // To Red
        presentModalScreen()
        verifyNavigationBarTitle(expectedTitle: "📙")
        verifyNavigationBarTitle(expectedTitle: "📕")
    }
    
    func testDismissingModalScreen() throws {
        navigateToNextScreen()  // To Red
        presentModalScreen()
        verifyNavigationBarTitle(expectedTitle: "📕")
        verifyNavigationBarTitle(expectedTitle: "📙")
        dismissModalScreen()
        verifyNavigationBarTitle(expectedTitle: "📕")
        verifyNavigationBarTitleDoesNotExist(expectedTitle: "📙")
    }
    
    func testDismissingModalScreenWithValue() throws {
        navigateToNextScreen()  // To Red
        navigateToNextScreen()  // To Green
        navigateToNextScreen()  // To Blue
        verifyTitle(expectedTitle: "🖼️")
        presentModalScreen()
        verifyNavigationBarTitle(expectedTitle: "📘")
        verifyNavigationBarTitle(expectedTitle: "📙")
        navigateToNextScreen()  // To Red
        navigateToNextScreen()  // To Green
        navigateToNextScreen()  // To Blue
        dismissModalScreen() // .dismiss(to: .blueDismiss, with: "🧸")
        verifyNavigationBarTitle(expectedTitle: "📘")
        verifyNavigationBarTitleDoesNotExist(expectedTitle: "📙")
        verifyTitle(expectedTitle: "🖼️🧸")
    }
    
    // MARK: - Navigation Helpers
    
    private func presentModalScreen() {
        let presentButton = app.buttons[AccessibilityID.presentButton.rawValue]
        XCTAssertTrue(presentButton.waitForExistence(timeout: 10),
                      "Present button should exist on the screen before tapping")
        presentButton.tap()
    }
    
    private func dismissModalScreen() {
        let dismissButtons = app.buttons.matching(identifier: AccessibilityID.dismissButton.rawValue)
        guard let visibleDismissButton = (dismissButtons.allElementsBoundByIndex.filter { $0.isHittable }).first else {
            XCTFail("No visible dismiss button found")
            return
        }
        XCTAssertTrue(visibleDismissButton.waitForExistence(timeout: 10),
                      "Visible dismiss button should exist on the screen before tapping")
        visibleDismissButton.tap()
    }
    
    private func navigateToNextScreen() {
        let pushButtons = app.buttons.matching(identifier: AccessibilityID.pushButton.rawValue)
        guard let visiblePushButton = (pushButtons.allElementsBoundByIndex.filter { $0.isHittable }).first else {
            XCTFail("No visible push button found")
            return
        }
        XCTAssertTrue(visiblePushButton.waitForExistence(timeout: 10),
                      "Visible push button should exist on the screen before tapping")
        visiblePushButton.tap()
    }
    
    private func navigateToPreviousScreen() {
        let popButtons = app.buttons.matching(identifier: AccessibilityID.popButton.rawValue)
        guard let visiblePopButton = (popButtons.allElementsBoundByIndex.filter { $0.isHittable }).first else {
            XCTFail("No visible pop button found")
            return
        }
        XCTAssertTrue(visiblePopButton.waitForExistence(timeout: 10),
                      "Visible pop button should exist on the screen before tapping")
        visiblePopButton.tap()
    }
    
    private func navigateToRootScreen() {
        let popToRootButtons = app.buttons.matching(identifier: AccessibilityID.popToRootButton.rawValue)
        guard let visiblePopToRootButton = (popToRootButtons.allElementsBoundByIndex.filter { $0.isHittable }).first else {
            XCTFail("No visible PopToRoot button found")
            return
        }
        XCTAssertTrue(visiblePopToRootButton.waitForExistence(timeout: 10),
                      "Visible PopToRoot button should exist on the screen before tapping")
        visiblePopToRootButton.tap()
    }
    
    private func unwindToScreenWith(expectedTitle: String) {
        let unwindButtons = app.buttons.matching(identifier: AccessibilityID.unwindButton.rawValue)
        guard let visibleUnwindButton = (unwindButtons.allElementsBoundByIndex.filter { $0.isHittable }).first else {
            XCTFail("No visible unwind button found")
            return
        }
        XCTAssertTrue(visibleUnwindButton.waitForExistence(timeout: 10),
                      "Visible unwind button should exist on the screen before tapping")
        visibleUnwindButton.tap()
        verifyNavigationBarTitle(expectedTitle: expectedTitle)
    }

    private func verifyNavigationBarTitle(expectedTitle: String) {
        let navigationBar = app.navigationBars[expectedTitle]
        let exists = navigationBar.waitForExistence(timeout: 10)
        XCTAssertTrue(exists, "Navigation bar should be \"\(expectedTitle)\"")
    }
    
    private func verifyNavigationBarTitleDoesNotExist(expectedTitle: String) {
        let navigationBar = app.navigationBars[expectedTitle]
        let exists = navigationBar.waitForExistence(timeout: 10)
        XCTAssertFalse(exists, "Navigation bar should not be \"\(expectedTitle)\"")
    }

    
    private func verifyTitle(expectedTitle: String) {
        let titleText = app.staticTexts[AccessibilityID.titleText.rawValue]
        let exists = titleText.waitForExistence(timeout: 10)
        XCTAssertTrue(exists, "Title should be visible before checking text")
        XCTAssertEqual(titleText.label, expectedTitle, "Title should be \"\(expectedTitle)\"")
    }
}
