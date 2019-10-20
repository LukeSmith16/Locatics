//
//  RootViewFactory.swift
//  Locatics
//
//  Created by Luke Smith on 03/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol RootModuleFactoryInterface {
    func createRootNavigationController() -> UINavigationController
    func createTabBarController(with rootControllers: [UINavigationController]) -> TabBarControllerInterface
}

class RootModuleFactory: RootModuleFactoryInterface {
    func createRootNavigationController() -> UINavigationController {
        let rootNavigationController = UINavigationController()
        rootNavigationController.setNavigationBarHidden(true, animated: true)

        return rootNavigationController
    }

    func createTabBarController(with rootControllers: [UINavigationController]) -> TabBarControllerInterface {
        return TabBarController(viewControllers: rootControllers, selectedIndex: 0)
    }
}
