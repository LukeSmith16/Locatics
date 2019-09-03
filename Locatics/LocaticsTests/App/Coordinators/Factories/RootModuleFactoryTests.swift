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

    func test_createRootNavigationControllerReturnsEmptyNavigationController() {
        let navController = sut.createRootNavigationController()

        XCTAssertTrue(navController.viewControllers.isEmpty)
    }
}
