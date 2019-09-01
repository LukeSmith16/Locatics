//
//  OnboardingViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class OnboardingViewModelTests: XCTestCase {

    var expectation: XCTestExpectation?

    var sut: OnboardingViewModel!

    override func setUp() {
        sut = OnboardingViewModel()
        sut.coordinatorDelegate = self
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_handleFinishOnboardingCallsGoToOnboardingFinished() {
        XCTAssertNotNil(sut.coordinatorDelegate)

        expectation = XCTestExpectation(description: "Wait for goToOnboardingFinished to be called")
        sut.handleFinishOnboarding()

        wait(for: [expectation!], timeout: 2)
    }
}

extension OnboardingViewModelTests: OnboardingViewModelCoordinatorDelegate {
    func goToOnboardingFinished() {
        expectation?.fulfill()
    }
}
