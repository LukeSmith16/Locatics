//
//  CoordinatorFactory.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol CoordinatorFactoryInterface: class {
    func createOnboardingFlow(root: UINavigationController) -> CoordinatorInterface & OnboardingCoordinatorOutput
}

final class CoordinatorFactory: CoordinatorFactoryInterface {
    func createOnboardingFlow(root: UINavigationController) -> CoordinatorInterface & OnboardingCoordinatorOutput {
        let onboardingCoordinator = OnboardingCoordinator(root: root,
                                                          factory: OnboardingModuleFactory())
        return onboardingCoordinator
    }
}
