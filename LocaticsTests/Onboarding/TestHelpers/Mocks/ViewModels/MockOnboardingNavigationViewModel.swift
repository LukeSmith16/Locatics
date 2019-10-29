//
//  MockOnboardingNavigationViewModel.swift
//  LocaticsTests
//
//  Created by Luke Smith on 29/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockOnboardingNavigationViewModel: OnboardingNavigationViewModelInterface {
    var calledNextTapped = false
    var calledSkipTapped = false

    func nextTapped() {
        calledNextTapped = true
    }

    func skipTapped() {
        calledSkipTapped = true
    }
}
