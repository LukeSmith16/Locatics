//
//  OnboardingNavigationViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 28/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol OnboardingNavigationViewModelInterface {
    func nextTapped()
    func skipTapped()
}

protocol OnboardingNavigationViewModelViewDelegate: class {
    func nextWasTapped(atIndex: Int)
    func skipWasTapped()
}

class OnboardingNavigationViewModel: OnboardingNavigationViewModelInterface {
    weak var viewDelegate: OnboardingNavigationViewModelViewDelegate?

    private let onboardingIndex: Int

    init(onboardingIndex: Int) {
        self.onboardingIndex = onboardingIndex
    }

    func nextTapped() {
        viewDelegate?.nextWasTapped(atIndex: onboardingIndex)
    }

    func skipTapped() {
        viewDelegate?.skipWasTapped()
    }
}
