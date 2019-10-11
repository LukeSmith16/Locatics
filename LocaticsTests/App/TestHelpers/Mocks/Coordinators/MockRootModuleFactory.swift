//
//  MockRootModuleFactory.swift
//  LocaticsTests
//
//  Created by Luke Smith on 12/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

@testable import Locatics
class MockRootModuleFactory: RootModuleFactoryInterface {
    var calledCreateRootNavigationController = false
    var calledCreateTabBarController = false

    func createRootNavigationController() -> UINavigationController {
        calledCreateRootNavigationController = true
        return UINavigationController()
    }

    var passedCreateTabBarRootControllers: [UINavigationController]?
    func createTabBarController(with rootControllers: [UINavigationController]) -> TabBarControllerInterface {
        calledCreateTabBarController = true
        passedCreateTabBarRootControllers = rootControllers

        return TabBarController(viewControllers: rootControllers, selectedIndex: 0)
    }
}
