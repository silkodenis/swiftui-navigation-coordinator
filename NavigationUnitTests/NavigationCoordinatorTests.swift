//
//  NavigationCoordinatorTests.swift
//  NavigationUnitTests
//
//  Created by Denis Silko on 25.04.2024.
//

import XCTest
@testable import Navigation

final class NavigationCoordinatorTests: XCTestCase {
    var sut: NavigationCoordinator<Int>!

    override func setUpWithError() throws {
        sut = NavigationCoordinator<Int>()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testPushScreen() throws {
        sut.push(1)
        XCTAssertEqual(sut.path.count, 1, "Path count should be 1 after one push")
    }
    
    func testPopScreen() throws {
        sut.push(1)
        sut.push(2)
        sut.pop()
        XCTAssertEqual(sut.path.count, 1, "Path count should be 1 after popping one screen")
    }
    
    func testPopToRoot() throws {
        sut.push(1)
        sut.push(2)
        sut.push(3)
        sut.popToRoot()
        XCTAssertTrue(sut.path.isEmpty, "Path should be empty after popping to root")
    }

    func testUnwind() throws {
        let expectation = self.expectation(description: "Unwind action executed")
        sut.push(1)
        sut.registerSegue(with: "toFirst", action: { value in
            XCTAssertEqual(value as? Int, 123, "Unwind value should be passed correctly")
            expectation.fulfill()
        })

        sut.push(2)
        sut.registerSegue(with: "toSecond")
        sut.push(3)
        sut.unwind(to: "toFirst", with: 123)

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(sut.path.count, 1, "Should unwind to the first screen")
    }

    func testRemoveInvalidSegues() throws {
        sut.registerSegue(with: "toFirst")
        sut.push(1)
        sut.registerSegue(with: "toSecond")
        sut.push(2)
        sut.pop()

        XCTAssertNil(sut.segues["toSecond"], "Segue toSecond should be removed after popping")
    }

    func testRegisterSegueWithAction() throws {
        let actionToPerform: (Any?) -> Void = { value in
            XCTAssertEqual(value as? String, "Test", "The action should capture and compare the correct value.")
        }
        
        sut.registerSegue(with: "initialSegue", action: actionToPerform)
        XCTAssertEqual(sut.segues["initialSegue"]?.index, 0, "Segue index should be 0 when path is empty.")
        
        sut.segues["initialSegue"]?.action?("Test")
    }

    func testRegisterSegueWithoutAction() throws {
        sut.push(1)
        sut.registerSegue(with: "nextSegue", action: nil)
        XCTAssertEqual(sut.segues["nextSegue"]?.index, 1, "Segue index should be 1 after one push.")
        XCTAssertNil(sut.segues["nextSegue"]?.action, "Action should be nil when no action is provided.")
    }

    func testRegisterMultipleSegues() throws {
        sut.push(1)
        sut.registerSegue(with: "firstSegue", action: nil)
        XCTAssertEqual(sut.segues["firstSegue"]?.index, 1, "Segue index should be 1 after one push.")
        
        sut.push(2)
        sut.registerSegue(with: "secondSegue", action: nil)
        XCTAssertEqual(sut.segues["secondSegue"]?.index, 2, "Segue index should be 2 after two pushes.")
    }
}
