//
//  OnboardingCoordinator.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol OnboardingCoordinatorOutput {
    var finishedOnboarding: (() -> Void)? { get set }
}

class OnboardingCoordinator: CoordinatorInterface, OnboardingCoordinatorOutput {
    var finishedOnboarding: (() -> Void)?

    private var root: UINavigationController
    private let factory: OnboardingModuleFactoryInterface

    init(root: UINavigationController, factory: OnboardingModuleFactoryInterface) {
        self.root = root
        self.factory = factory
    }

    func start() {
        startOnboarding()
    }
}

private extension OnboardingCoordinator {
    func startOnboarding() {
        let onboardingModule = factory.createOnboardingModule(delegate: self)
        root.pushViewController(onboardingModule, animated: true)
    }
}

extension OnboardingCoordinator: OnboardingViewModelCoordinatorDelegate {
    func goToOnboardingFinished() {
        finishedOnboarding?()
    }
}
