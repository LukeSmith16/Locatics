//
//  CoordinatorFactoryTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class CoordinatorFactoryTests: XCTestCase {

    var sut: CoordinatorFactoryInterface!

    override func setUp() {
        sut = CoordinatorFactory()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_createOnboardingCoordinatorFlowReturnsOnboardingCoordinator() {
        let navController = UINavigationController()
        let coordinator = sut.createOnboardingCoordinatorFlow(root: navController)

        XCTAssertTrue(coordinator.self is OnboardingCoordinator)
        XCTAssertTrue(navController.viewControllers.isEmpty)
    }
}
