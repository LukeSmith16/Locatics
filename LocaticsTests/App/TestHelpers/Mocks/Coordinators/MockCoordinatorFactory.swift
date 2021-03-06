//
//  MockCoordinatorFactory.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

@testable import Locatics
class MockCoordinatorFactory: CoordinatorFactoryInterface {

    var calledCreateMapFlow = false
    var calledCreateLocaticsFlow = false

    let onboardingCoordinator: MockOnboardingCoordinator
    let mainCoordinator: MockMainCoordinator

    init(onboardingCoordinator: MockOnboardingCoordinator = MockOnboardingCoordinator(),
         mainCoordinator: MockMainCoordinator = MockMainCoordinator()) {
        self.onboardingCoordinator = onboardingCoordinator
        self.mainCoordinator = mainCoordinator
    }

    func createOnboardingFlow(root: UINavigationController) -> CoordinatorInterface & OnboardingCoordinatorOutput {
        return onboardingCoordinator
    }

    func createMainFlow(root: TabBarControllerInterface) -> CoordinatorInterface {
        return mainCoordinator
    }

    func createMapFlow(root: UINavigationController) -> CoordinatorInterface {
        calledCreateMapFlow = true
        return LocaticsMapCoordinator(root: root,
                                      coordinatorFactory: CoordinatorFactory(storageManager: MockStorageManager()),
                                      moduleFactory: LocaticsMapModuleFactory(storageManager: MockStorageManager(),
                                                                              locaticStorage: MockLocaticStorage(),
                                                                              locaticVisitStorage: MockLocaticVisitStorage()))
    }

    func createLocaticsFlow(root: UINavigationController) -> CoordinatorInterface {
        calledCreateLocaticsFlow = true
        return LocaticsCoordinator(root: root,
                                   coordinatorFactory: CoordinatorFactory(storageManager: MockStorageManager()),
                                   moduleFactory: LocaticsModuleFactory(storageManager: MockStorageManager(),
                                                                        locaticStorage: MockLocaticStorage()))
    }
}
