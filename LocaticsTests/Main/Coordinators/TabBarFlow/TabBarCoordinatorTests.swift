//
//  TabBarCoordinatorTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class TabBarCoordinatorTests: XCTestCase {

    private var mockTabBarController: MockTabBarController!
    private var mockCoordinatorFactory: MockCoordinatorFactory!

    var sut: TabBarCoordinator!

    override func setUp() {
        mockTabBarController = MockTabBarController()
        mockCoordinatorFactory = MockCoordinatorFactory()

        sut = TabBarCoordinator(tabBarController: mockTabBarController,
                                coordinatorFactory: mockCoordinatorFactory)
    }

    override func tearDown() {
        mockTabBarController = nil
        mockCoordinatorFactory = nil

        sut = nil
        super.tearDown()
    }

    func test_startMapFlowClosure_startsRunMapFlow() {
        sut.start()

        mockTabBarController.triggerRunMapFlow()

        XCTAssertTrue(mockCoordinatorFactory.calledCreateMapFlow)

    }

    func test_startLocaticsFlowClosure_startsRunLocaticsFlow() {
        sut.start()

        mockTabBarController.triggerRunLocaticsFlow()

        XCTAssertTrue(mockCoordinatorFactory.calledCreateLocaticsFlow)
    }
}
