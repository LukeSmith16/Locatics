//
//  TabBarCoordinator.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class TabBarCoordinator: CoordinatorInterface {

    private let tabBarController: TabBarControllerInterface
    private let coordinatorFactory: CoordinatorFactoryInterface

    init(tabBarController: TabBarControllerInterface, coordinatorFactory: CoordinatorFactoryInterface) {
        self.tabBarController = tabBarController
        self.coordinatorFactory = coordinatorFactory
    }

    func start() {
        tabBarController.onMapFlowSelect = runMapFlow()
        tabBarController.onLocaticsFlowSelect = runLocaticsFlow()
    }
}

private extension TabBarCoordinator {
    func runMapFlow() -> ((UINavigationController) -> Void) {
        return { [unowned self] navController in
            let locaticsMapCoordinator = self.coordinatorFactory.createMapFlow(root: navController)
            locaticsMapCoordinator.start()
        }
    }

    func runLocaticsFlow() -> ((UINavigationController) -> Void) {
        return { [unowned self] navController in
            let locaticsCoordinator = self.coordinatorFactory.createLocaticsFlow(root: navController)
            locaticsCoordinator.start()
        }
    }
}
