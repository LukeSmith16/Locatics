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
        sut = CoordinatorFactory(storageManager: MockStorageManager())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_createOnboardingCoordinatorFlow_returnsOnboardingCoordinator() {
        let navController = UINavigationController()
        let coordinator = sut.createOnboardingFlow(root: navController)

        XCTAssertTrue(coordinator is OnboardingCoordinator)
        XCTAssertTrue(navController.viewControllers.isEmpty)
    }

    func test_createMainCoordinatorFlow_returnsTabBarCoordinator() {
        let tabBarController = TabBarController(viewControllers: [NavigationViewController(),
                                                                  NavigationViewController()],
                                                selectedIndex: 0)

        let mainFlow = sut.createMainFlow(root: tabBarController)

        XCTAssertTrue(mainFlow is TabBarCoordinator)
    }

    func test_createMapCoordinatorFlow_returnsLocaticsMapCoordinator() {
        let navController = UINavigationController()

        let locaticsMapFlow = sut.createMapFlow(root: navController)

        XCTAssertTrue(locaticsMapFlow is LocaticsMapCoordinator)
    }

    func test_createLocaticsCoordinatorFlow_returnsLocaticsCoordinator() {
        let navController = UINavigationController()

        let locaticsMapFlow = sut.createLocaticsFlow(root: navController)

        XCTAssertTrue(locaticsMapFlow is LocaticsCoordinator)
    }
}
