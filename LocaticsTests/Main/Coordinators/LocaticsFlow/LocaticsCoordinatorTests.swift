//
//  LocaticsCoordinatorTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsCoordinatorTests: XCTestCase {

    private var mockFactory: MockLocaticsModuleFactory!
    private var mockNavController: UINavigationController!
    var sut: LocaticsCoordinator!

    override func setUp() {
        mockFactory = MockLocaticsModuleFactory()
        mockNavController = UINavigationController()

        sut = LocaticsCoordinator(root: mockNavController,
                                  coordinatorFactory: CoordinatorFactory(storageManager: MockStorageManager()),
                                     moduleFactory: mockFactory)
    }

    override func tearDown() {
        mockFactory = nil
        mockNavController = nil
        sut = nil
        super.tearDown()
    }

    func test_start_callsCreateLocaticsListModule() {
        sut.start()

        XCTAssertTrue(mockFactory.calledCreateLocaticsListModule)
    }

    func test_start_addsLocaticsListModuleToRoot() {
        sut.start()

        XCTAssertEqual(mockNavController.viewControllers.count, 1)
        XCTAssertTrue(mockNavController.viewControllers.first is LocaticsListViewController)
    }
}

private extension LocaticsCoordinatorTests {
    class MockLocaticsModuleFactory: LocaticsModuleFactoryInterface {
        var calledCreateLocaticsListModule = false

        func createLocaticsListModule() -> LocaticsListViewController {
            calledCreateLocaticsListModule = true
            return LocaticsListViewController()
        }
    }
}
