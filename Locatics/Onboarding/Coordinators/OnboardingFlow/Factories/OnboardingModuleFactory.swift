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
        let onboardingSB = UIStoryboard.Storyboard.onboarding
        guard let onboardingVC = onboardingSB.instantiateInitialViewController() as? OnboardingViewController else {
            fatalError("Could not load onboarding storyboard properly")
        }

        return onboardingVC
    }

    func createOnboardingViewModel(delegate: OnboardingViewModelCoordinatorDelegate?) -> OnboardingViewModelInterface {
        let onboardingViewModel = OnboardingViewModel()
        let onboardingNavigationViewModels = createOnboardingNavigationViewModels(delegate: onboardingViewModel)
        onboardingViewModel.onboardingNavigationViewModels = onboardingNavigationViewModels
        onboardingViewModel.locationPermissionsManager = LocationPermissionsManager()
        onboardingViewModel.coordinator = delegate

        return onboardingViewModel
    }

    func createOnboardingNavigationViewModels(delegate: OnboardingNavigationViewModelViewDelegate) -> [OnboardingNavigationViewModelInterface] {
        let welcomeOnboardingVM = OnboardingNavigationViewModel(onboardingIndex: 0)
        welcomeOnboardingVM.viewDelegate = delegate

        let aboutOnboardingVM = OnboardingNavigationViewModel(onboardingIndex: 1)
        aboutOnboardingVM.viewDelegate = delegate

        let permissionsOnboardingVM = OnboardingNavigationViewModel(onboardingIndex: 2)
        permissionsOnboardingVM.viewDelegate = delegate

        let getStartedOnboardingVM = OnboardingNavigationViewModel(onboardingIndex: 3)
        getStartedOnboardingVM.viewDelegate = delegate

        return [welcomeOnboardingVM, aboutOnboardingVM, permissionsOnboardingVM, getStartedOnboardingVM]
    }
}
