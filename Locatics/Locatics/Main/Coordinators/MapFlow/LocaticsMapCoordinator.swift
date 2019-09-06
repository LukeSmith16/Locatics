//
//  LocaticsMapCoordinator.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class LocaticsMapCoordinator: CoordinatorInterface {
    private let root: UINavigationController
    private let coordinatorFactory: CoordinatorFactoryInterface
    private let moduleFactory: LocaticsMapModuleFactoryInterface

    init(root: UINavigationController,
         coordinatorFactory: CoordinatorFactoryInterface,
         moduleFactory: LocaticsMapModuleFactoryInterface) {
        self.root = root
        self.coordinatorFactory = coordinatorFactory
        self.moduleFactory = moduleFactory
    }

    func start() {
        startLocaticsMap()
    }
}

private extension LocaticsMapCoordinator {
    func startLocaticsMap() {
        let locaticsMapModule = moduleFactory.createLocaticsMapModule()
        root.setViewControllers([locaticsMapModule], animated: true)
    }
}
