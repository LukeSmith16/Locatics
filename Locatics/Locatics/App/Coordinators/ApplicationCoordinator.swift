//
//  ApplicationCoordinator.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

private var onboardingWasShown = false

enum LaunchInstructor {
    case main, onboarding
}

protocol CoordinatorInterface: class {
    func start()
}

class ApplicationCoordinator: CoordinatorInterface {

    private let launchInstructor: LaunchInstructor
    private let coordinatorFactory: CoordinatorFactoryInterface

    init(launchInstructor: LaunchInstructor, coordinatorFactory: CoordinatorFactoryInterface) {
        self.launchInstructor = launchInstructor
        self.coordinatorFactory = coordinatorFactory
    }

    func start() {
        switch launchInstructor {
        case .main:
            fatalError("Not implemented yet...")
        case .onboarding:
            startOnboardingFlow()
        }
    }
}

private extension ApplicationCoordinator {
    func startOnboardingFlow() {
        let onboardingCoordinator = coordinatorFactory.createOnboardingCoordinatorFlow()
        onboardingCoordinator.start()
    }
}
