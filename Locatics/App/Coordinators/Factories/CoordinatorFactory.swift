//
//  CoordinatorFactory.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

// swiftlint:disable line_length

protocol CoordinatorFactoryInterface: class {
    func createOnboardingFlow(root: UINavigationController) -> CoordinatorInterface & OnboardingCoordinatorOutput

    func createMainFlow(root: TabBarControllerInterface) -> CoordinatorInterface
    func createMapFlow(root: UINavigationController) -> CoordinatorInterface
    func createLocaticsFlow(root: UINavigationController) -> CoordinatorInterface
}

final class CoordinatorFactory: CoordinatorFactoryInterface {
    private let storageManager: StorageManagerInterface
    private lazy var locaticStorage = LocaticStorage(storageManager: storageManager)

    init(storageManager: StorageManagerInterface) {
        self.storageManager = storageManager
    }

    func createOnboardingFlow(root: UINavigationController) -> CoordinatorInterface & OnboardingCoordinatorOutput {
        let onboardingCoordinator = OnboardingCoordinator(root: root,
                                                          factory: OnboardingModuleFactory())
        return onboardingCoordinator
    }

    func createMainFlow(root: TabBarControllerInterface) -> CoordinatorInterface {
        let tabBarCoordinator = TabBarCoordinator(tabBarController: root,
                                                  coordinatorFactory: CoordinatorFactory(storageManager: storageManager))
        return tabBarCoordinator
    }

    func createMapFlow(root: UINavigationController) -> CoordinatorInterface {
        let mapCoordinator = LocaticsMapCoordinator(root: root,
                                                    coordinatorFactory: CoordinatorFactory(storageManager: storageManager),
                                                    moduleFactory: LocaticsMapModuleFactory(storageManager: storageManager,
                                                                                            locaticStorage: locaticStorage))
        return mapCoordinator
    }

    func createLocaticsFlow(root: UINavigationController) -> CoordinatorInterface {
        let locaticsCoordinator = LocaticsCoordinator(root: root,
                                                      coordinatorFactory: CoordinatorFactory(storageManager: storageManager),
                                                      moduleFactory: LocaticsModuleFactory())
        return locaticsCoordinator
    }
}
