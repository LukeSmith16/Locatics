//
//  ApplicationCoordinatorTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class ApplicationCoordinatorTests: XCTestCase {

    var sut: CoordinatorInterface?

    fileprivate var mockCoordinatorFactory: MockCoordinatorFactory!

    fileprivate var mockOnboardingCoordinator: MockOnboardingCoordinator!

    override func setUp() {
        mockOnboardingCoordinator = MockOnboardingCoordinator()
        mockCoordinatorFactory = MockCoordinatorFactory(onboardingCoordinator: mockOnboardingCoordinator)
    }

    override func tearDown() {
        sut = nil
        mockCoordinatorFactory = nil
        mockOnboardingCoordinator = nil
        super.tearDown()
    }

    func test_onboardingFlowGetsCalledWhenLaunchInstructorIsOnboarding() {
        sut = ApplicationCoordinator(launchInstructor: .onboarding, coordinatorFactory: mockCoordinatorFactory)

        sut?.start()

        XCTAssertTrue(mockOnboardingCoordinator.startWasCalled)
    }
}

private extension ApplicationCoordinatorTests {
    class MockCoordinatorFactory: CoordinatorFactoryInterface {
        let onboardingCoordinator: MockOnboardingCoordinator

        init(onboardingCoordinator: MockOnboardingCoordinator) {
            self.onboardingCoordinator = onboardingCoordinator
        }

        func createOnboardingCoordinatorFlow() -> CoordinatorInterface & OnboardingCoordinatorOutput {
            return onboardingCoordinator
        }
    }

    class MockOnboardingCoordinator: CoordinatorInterface, OnboardingCoordinatorOutput {
        var finishedOnboarding: (() -> Void)?

        var startWasCalled = false

        func start() {
            startWasCalled = true
        }
    }
}
