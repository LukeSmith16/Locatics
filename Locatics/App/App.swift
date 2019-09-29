//
//  App.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

// swiftlint:disable line_length

protocol AppInterface {
    func start()
}

class App: AppInterface {
    let window: UIWindow!
    var applicationCoordinator: CoordinatorInterface?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        setupApplicationCoordinator()
    }
}

private extension App {
    func setupApplicationCoordinator() {
        let userHasOnboarded = OnboardingManager.hasOnboarded()
        setupStorageManager { [weak self] (storageManager) in
            guard let `self` = self else { fatalError("'App' failed to start") }
            self.applicationCoordinator = ApplicationCoordinator(window: self.window,
                                                                 launchInstructor: .configure(userOnboarded: userHasOnboarded),
                                                                 coordinatorFactory: CoordinatorFactory(storageManager: storageManager),
                                                                 rootModuleFactory: RootModuleFactory())
            self.applicationCoordinator?.start()
        }
    }

    func setupStorageManager(completion: @escaping (StorageManagerInterface) -> Void) {
        createApplicationPersistenceContainer { (container) in
            completion(StorageManager(psc: container))
        }
    }
}
