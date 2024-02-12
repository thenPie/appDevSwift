import XCTest
@testable import Homework7
final class FriendsViewControllerTests: XCTestCase {
    private var friendsViewController: FriendsViewController!
    private var networkService: NetworkServiceSpy!
    private var coreDataService: CoreDataServiceSpy!
    override func setUp() {
        super.setUp()
        friendsViewController = FriendsViewController()
        networkService = NetworkServiceSpy()
        coreDataService = CoreDataServiceSpy()
    }
    override func tearDown() {
        friendsViewController = nil
        networkService = nil
        coreDataService = nil
        super.tearDown()
    }
    func testGetFriends() {
        friendsViewController.getFriends()
        XCTAssertTrue(networkService.isGetFriendsWasCalled, "Метод networkService.getFriends() не вызван")
        XCTAssertTrue(coreDataService.isSaveFriendsWasCalled, "Метод coreDataService.saveFriends() не вызван")
        XCTAssertTrue(coreDataService.isGetFriendsWasCalled, "Метод coreDataService.getFriends() не вызван")
    }
}