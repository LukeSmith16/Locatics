//
//  OnboardingModuleFactory.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol OnboardingModuleFactoryInterface {
    func createOnboardingModule(delegate: OnboardingViewModelCoordinatorDelegate?) -> OnboardingViewController
}

class OnboardingModuleFactory: OnboardingModuleFactoryInterface {
    func createOnboardingModule(delegate: OnboardingViewModelCoordinatorDelegate?) -> OnboardingViewController {
        let onboardingViewController = loadOnboardingStoryboard()
        onboardingViewController.onboardingViewModel = createOnboardingViewModel(delegate: delegate)

        return onboardingViewController
    }
}

private extension OnboardingModuleFactory {
    func loadOnboardingStoryboard() -> OnboardingViewController {
        let onboardingSB = UIStoryboard(name: "OnboardingStoryboard", bundle: Bundle.main)
        guard let onboardingVC = onboardingSB.instantiateInitialViewController() as? OnboardingViewController else {
            fatalError("Could not load onboarding storyboard properly")
        }

        return onboardingVC
    }

    func createOnboardingViewModel(delegate: OnboardingViewModelCoordinatorDelegate?) -> OnboardingViewModelInterface {
        let onboardingViewModel = OnboardingViewModel()
        onboardingViewModel.locationPermissionsManager = LocationPermissionsManager()
        onboardingViewModel.coordinator = delegate

        return onboardingViewModel
    }
}
