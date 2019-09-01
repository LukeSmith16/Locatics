//
//  OnboardingViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol OnboardingViewModelCoordinatorDelegate: class {
    func goToOnboardingFinished()
}

protocol OnboardingViewModelInterface {
    func handleFinishOnboarding()
}

class OnboardingViewModel: OnboardingViewModelInterface {
    weak var coordinatorDelegate: OnboardingViewModelCoordinatorDelegate?

    func handleFinishOnboarding() {
        coordinatorDelegate?.goToOnboardingFinished()
    }
}
