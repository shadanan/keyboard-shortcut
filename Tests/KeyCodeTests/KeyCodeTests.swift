import XCTest
@testable import KeyCode

class KeyCodeTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(KeyCode().text, "Hello, World!")
    }


    static var allTests : [(String, (KeyCodeTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
