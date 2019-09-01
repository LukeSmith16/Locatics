//
//  CoordinatorFactory.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol CoordinatorFactoryInterface: class {
    func createOnboardingCoordinatorFlow() -> CoordinatorInterface & OnboardingCoordinatorOutput
}

final class CoordinatorFactory: CoordinatorFactoryInterface {
    func createOnboardingCoordinatorFlow() -> CoordinatorInterface & OnboardingCoordinatorOutput {
        let onboardingCoordinator = OnboardingCoordinator(root: UINavigationController(),
                                                          factory: OnboardingModuleFactory())
        return onboardingCoordinator
    }
}
