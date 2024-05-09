//
//  NavigationCoordinatorTests.swift
//  NavigationUnitTests
//
//  Created by Denis Silko on 25.04.2024.
//

import XCTest
@testable import Navigation

final class NavigationCoordinatorTests: XCTestCase {
    var sut: NavigationCoordinator<Screen>!

    override func setUpWithError() throws {
        sut = NavigationCoordinator<Screen>()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testPushScreen() throws {
        sut.push(.orangeBook)
        XCTAssertEqual(sut.path.count, 1, "Path count should be 1 after one push")
    }
    
    func testPopScreen() throws {
        sut.push(.orangeBook)
        sut.push(.redBook)
        sut.pop()
        XCTAssertEqual(sut.path.count, 1, "Path count should be 1 after popping one screen")
    }
    
    func testPopToRoot() throws {
        sut.push(.orangeBook)
        sut.push(.redBook)
        sut.push(.greenBook)
        sut.popToRoot()
        XCTAssertTrue(sut.path.isEmpty, "Path should be empty after popping to root")
    }
    
    func testPopOnEmptyPath() throws {
        sut.pop()
        XCTAssertTrue(sut.path.isEmpty, "Path should remain empty after pop on empty path")
    }
    
    func testPopToRootOnEmptyPath() throws {
        sut.popToRoot()
        XCTAssertTrue(sut.path.isEmpty, "Path should remain empty after popToRoot on empty path")
    }
    
    func testPopToRootRemovesAllSegues() throws {
        sut.push(.orangeBook)
        sut.registerSegue(.unwind, with: "toFirst", action: nil)
        sut.push(.redBook)
        sut.registerSegue(.unwind, with: "toSecond", action: nil)
        sut.popToRoot()

        XCTAssertTrue(sut.segues.isEmpty, "All segues should be removed after popping to root")
    }

    func testUnwind() throws {
        let expectation = self.expectation(description: "Unwind action executed")
        sut.push(.orangeBook)
        sut.registerSegue(.unwind, with: "toFirst", action: { value in
            XCTAssertEqual(value as? Int, 123, "Unwind value should be passed correctly")
            expectation.fulfill()
        })

        sut.push(.redBook)
        sut.registerSegue(.unwind, with: "toSecond")
        sut.push(.greenBook)
        sut.unwind(to: "toFirst", with: 123)

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(sut.path.count, 1, "Should unwind to the first screen")
    }

    func testRemoveInvalidSegues() throws {
        sut.registerSegue(.unwind, with: "toFirst")
        sut.push(.orangeBook)
        sut.registerSegue(.unwind, with: "toSecond")
        sut.push(.redBook)
        sut.pop()

        XCTAssertNil(sut.segues["toSecond"], "Segue toSecond should be removed after popping")
    }

    func testRegisterSegueWithAction() throws {
        let actionToPerform: (Any?) -> Void = { value in
            XCTAssertEqual(value as? String, "Test", "The action should capture and compare the correct value.")
        }
        
        sut.registerSegue(.unwind, with: "initialSegue", action: actionToPerform)
        XCTAssertEqual(sut.segues["initialSegue"]?.index, 0, "Segue index should be 0 when path is empty.")
        
        sut.segues["initialSegue"]?.action?("Test")
    }

    func testRegisterSegueWithoutAction() throws {
        sut.push(.orangeBook)
        sut.registerSegue(.unwind, with: "nextSegue", action: nil)
        XCTAssertEqual(sut.segues["nextSegue"]?.index, 1, "Segue index should be 1 after one push.")
        XCTAssertNil(sut.segues["nextSegue"]?.action, "Action should be nil when no action is provided.")
    }

    func testRegisterMultipleSegues() throws {
        sut.push(.orangeBook)
        sut.registerSegue(.unwind, with: "firstSegue", action: nil)
        XCTAssertEqual(sut.segues["firstSegue"]?.index, 1, "Segue index should be 1 after one push.")
        
        sut.push(.redBook)
        sut.registerSegue(.unwind, with: "secondSegue", action: nil)
        XCTAssertEqual(sut.segues["secondSegue"]?.index, 2, "Segue index should be 2 after two pushes.")
    }
    
    func testPresentModal() throws {
        sut.present(.greenBook)
        XCTAssertEqual(sut.modal, .greenBook, "Modal should be .greenBook after presentation")
    }
    
    func testDismissWithAction() throws {
        let childCoordinator = NavigationCoordinator<Screen>()
        childCoordinator.parent = sut
        
        var receivedValue: Any?
        sut.registerSegue(.dismiss, with: "modalDismiss", action: { value in
            receivedValue = value
        })
        
        sut.present(.orangeBook)

        childCoordinator.dismiss(to: "modalDismiss", with: "TestValue")
        XCTAssertNil(sut.modal)
        XCTAssertEqual(receivedValue as? String, "TestValue")
    }
    
    func testDismissWithParentInteraction() throws {
        let parent = NavigationCoordinator<Screen>()
        sut.parent = parent
        parent.present(.orangeBook)
        
        sut.dismiss()
        XCTAssertNil(parent.modal, "Parent modal should be nil after child dismissal")
    }
}
