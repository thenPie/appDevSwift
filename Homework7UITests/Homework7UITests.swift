import XCTest
final class Homework7UITests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    func testTabClick() {
    }
}