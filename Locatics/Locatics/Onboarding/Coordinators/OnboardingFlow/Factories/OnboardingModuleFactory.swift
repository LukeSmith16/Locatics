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
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.onboardingViewModel = createOnboardingViewModel(delegate: delegate)

        return onboardingViewController
    }
}

private extension OnboardingModuleFactory {
    func createOnboardingViewModel(delegate: OnboardingViewModelCoordinatorDelegate?) -> OnboardingViewModelInterface {
        let onboardingViewModel = OnboardingViewModel()
        onboardingViewModel.coordinatorDelegate = delegate

        return onboardingViewModel
    }
}
