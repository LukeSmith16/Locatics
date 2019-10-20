//
//  MockOnboardingCoordinator.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockOnboardingCoordinator: CoordinatorInterface, OnboardingCoordinatorOutput {
    var finishedOnboarding: (() -> Void)?

    var startWasCalled = false

    func start() {
        startWasCalled = true
    }

    func triggerFinishOnboarding() {
        finishedOnboarding?()
    }
}
