//
//  MockOnboardingNavigationViewModelViewDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 29/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockOnboardingNavigationViewModelViewDelegate: OnboardingNavigationViewModelViewDelegate {
    var calledNextWasTapped = false
    var calledSkipWasTapped = false

    var nextWasTappedPassedIndex: Int?

    func nextWasTapped(atIndex: Int) {
        calledNextWasTapped = true
        nextWasTappedPassedIndex = atIndex
    }

    func skipWasTapped() {
        calledSkipWasTapped = true
    }
}
