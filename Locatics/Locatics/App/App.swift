//
//  App.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

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
        applicationCoordinator = ApplicationCoordinator(window: window,
                                                        launchInstructor: .configure(userOnboarded: userHasOnboarded),
                                                        coordinatorFactory: CoordinatorFactory(),
                                                        rootModuleFactory: RootModuleFactory())
        applicationCoordinator?.start()
    }
}
