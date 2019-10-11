//
//  ApplicationCoordinator.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

//swiftlint:disable line_length

enum LaunchInstructor {
    case main, onboarding

    static func configure(userOnboarded: Bool) -> LaunchInstructor {
        switch userOnboarded {
        case true:
            return .main
        case false:
            return .onboarding
        }
    }
}

protocol CoordinatorInterface: class {
    func start()
}

class ApplicationCoordinator: CoordinatorInterface {

    private let window: UIWindow!
    let launchInstructor: LaunchInstructor

    private let rootModuleFactory: RootModuleFactoryInterface
    private let coordinatorFactory: CoordinatorFactoryInterface

    private var childCoordinators: [CoordinatorInterface] = []

    init(window: UIWindow,
         launchInstructor: LaunchInstructor,
         coordinatorFactory: CoordinatorFactoryInterface,
         rootModuleFactory: RootModuleFactoryInterface) {
        self.window = window
        self.launchInstructor = launchInstructor
        self.rootModuleFactory = rootModuleFactory
        self.coordinatorFactory = coordinatorFactory
    }

    func start() {
        switch launchInstructor {
        case .main:
            startMainFlow()
        case .onboarding:
            startOnboardingFlow()
        }
    }
}

private extension ApplicationCoordinator {
    func startOnboardingFlow() {
        let rootController = rootModuleFactory.createRootNavigationController()
        window.rootViewController = rootController

        let onboardingCoordinator = coordinatorFactory.createOnboardingFlow(root: rootController)
        onboardingCoordinator.finishedOnboarding = { [weak self] in
            guard let `self` = self else { return }
            self.startMainFlow()
        }

        onboardingCoordinator.start()
    }

    func startMainFlow() {
        let rootTabControllers = [NavigationViewController(), NavigationViewController()]

        guard let rootTabBarController = rootModuleFactory.createTabBarController(with: rootTabControllers) as? TabBarController else {
            fatalError("RootTabBarController should be of type TabBarController")
        }

        let tabBarCoordinator = coordinatorFactory.createMainFlow(root: rootTabBarController)
        tabBarCoordinator.start()

        childCoordinators.append(tabBarCoordinator)
        window.rootViewController = rootTabBarController
    }
}
