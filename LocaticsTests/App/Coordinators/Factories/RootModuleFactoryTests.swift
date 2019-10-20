//
//  RootModuleFactoryTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 03/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class RootModuleFactoryTests: XCTestCase {

    var sut: RootModuleFactoryInterface!

    override func setUp() {
        sut = RootModuleFactory()
    }

    override func tearDown() {
        sut = nil
    }

    func test_createRootNavigationController_returnsEmptyNavigationController() {
        let navController = sut.createRootNavigationController()

        XCTAssertTrue(navController.viewControllers.isEmpty)
    }

    func test_rootNavigationController_navBarisHidden() {
        let navController = sut.createRootNavigationController()

        XCTAssertTrue(navController.isNavigationBarHidden)
    }

    func test_createTabBarController_returnsTabBarControllerType() {
        let tabBarController = sut.createTabBarController(with: [NavigationViewController(),
                                                                 NavigationViewController()])

        XCTAssertTrue(tabBarController is TabBarController)

    }
}
