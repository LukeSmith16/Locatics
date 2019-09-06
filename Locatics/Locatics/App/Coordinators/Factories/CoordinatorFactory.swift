//
//  CoordinatorFactory.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol CoordinatorFactoryInterface: class {
    func createOnboardingFlow(root: UINavigationController) -> CoordinatorInterface & OnboardingCoordinatorOutput

    func createMainFlow(root: TabBarControllerInterface) -> CoordinatorInterface
    func createMapFlow(root: UINavigationController) -> CoordinatorInterface
    func createLocaticsFlow(root: UINavigationController) -> CoordinatorInterface
}

final class CoordinatorFactory: CoordinatorFactoryInterface {
    func createOnboardingFlow(root: UINavigationController) -> CoordinatorInterface & OnboardingCoordinatorOutput {
        let onboardingCoordinator = OnboardingCoordinator(root: root,
                                                          factory: OnboardingModuleFactory())
        return onboardingCoordinator
    }

    func createMainFlow(root: TabBarControllerInterface) -> CoordinatorInterface {
        let tabBarCoordinator = TabBarCoordinator(tabBarController: root, coordinatorFactory: CoordinatorFactory())
        return tabBarCoordinator
    }

    func createMapFlow(root: UINavigationController) -> CoordinatorInterface {
        let mapCoordinator = LocaticsMapCoordinator()
        return mapCoordinator
    }

    func createLocaticsFlow(root: UINavigationController) -> CoordinatorInterface {
        let locaticsCoordinator = LocaticsCoordinator()
        return locaticsCoordinator
    }
}
