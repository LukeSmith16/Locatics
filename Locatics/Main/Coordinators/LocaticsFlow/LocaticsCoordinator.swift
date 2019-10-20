//
//  LocaticsCoordinator.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class LocaticsCoordinator: CoordinatorInterface {
    private let root: UINavigationController
    private let coordinatorFactory: CoordinatorFactoryInterface
    private let moduleFactory: LocaticsModuleFactoryInterface

    init(root: UINavigationController,
         coordinatorFactory: CoordinatorFactoryInterface,
         moduleFactory: LocaticsModuleFactoryInterface) {
        self.root = root
        self.coordinatorFactory = coordinatorFactory
        self.moduleFactory = moduleFactory
    }

    func start() {
        startLocaticsList()
    }
}

private extension LocaticsCoordinator {
    func startLocaticsList() {
        let locaticsListModule = moduleFactory.createLocaticsListModule()
        root.setViewControllers([locaticsListModule], animated: true)
    }
}
