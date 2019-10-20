//
//  LocaticsMapCoordinatorTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsMapCoordinatorTests: XCTestCase {

    private var mockFactory: MockLocaticsMapModuleFactory!
    private var mockNavController: UINavigationController!
    var sut: LocaticsMapCoordinator!

    override func setUp() {
        mockFactory = MockLocaticsMapModuleFactory()
        mockNavController = UINavigationController()

        sut = LocaticsMapCoordinator(root: mockNavController,
                                     coordinatorFactory: CoordinatorFactory(storageManager: MockStorageManager()),
                                     moduleFactory: mockFactory)
    }

    override func tearDown() {
        mockFactory = nil
        mockNavController = nil
        sut = nil
        super.tearDown()
    }

    func test_start_callsCreateMapModule() {
        sut.start()

        XCTAssertTrue(mockFactory.calledCreateMapModule)
    }

    func test_start_addsMapModuleToRoot() {
        sut.start()

        XCTAssertEqual(mockNavController.viewControllers.count, 1)
        XCTAssertTrue(mockNavController.viewControllers.first is LocaticsMapViewController)
    }
}
