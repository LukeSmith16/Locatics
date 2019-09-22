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
    func createTabBarController() -> TabBarControllerInterface
}

class RootModuleFactory: RootModuleFactoryInterface {
    func createRootNavigationController() -> UINavigationController {
        let rootNavigationController = UINavigationController()
        rootNavigationController.setNavigationBarHidden(true, animated: true)

        return rootNavigationController
    }

    func createTabBarController() -> TabBarControllerInterface {
        let mainStoryboard = UIStoryboard.Storyboard.main
        guard let tabBarController = mainStoryboard.instantiateInitialViewController() as? TabBarController else {
            fatalError("Could not get TabBarController from storyboard file")
        }

        return tabBarController
    }
}
