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

    var window: UIWindow!
    var sut: CoordinatorInterface?

    fileprivate var mockCoordinatorFactory: MockCoordinatorFactory!
    fileprivate var mockOnboardingCoordinator: MockOnboardingCoordinator!

    override func setUp() {
        mockOnboardingCoordinator = MockOnboardingCoordinator()
        mockCoordinatorFactory = MockCoordinatorFactory(onboardingCoordinator: mockOnboardingCoordinator)
        window = UIWindow()
    }

    override func tearDown() {
        sut = nil
        window = nil
        mockCoordinatorFactory = nil
        mockOnboardingCoordinator = nil
        super.tearDown()
    }

    func test_onboardingFlowGetsCalledWhenLaunchInstructorIsOnboarding() {
        sut = ApplicationCoordinator(window: window,
                                     launchInstructor: .onboarding,
                                     coordinatorFactory: mockCoordinatorFactory,
                                     rootModuleFactory: RootModuleFactory())

        sut?.start()

        XCTAssertTrue(mockOnboardingCoordinator.startWasCalled)
    }

    func test_windowRootControllerIsNotNilAfterStart() {
        sut = ApplicationCoordinator(window: window,
                                     launchInstructor: .onboarding,
                                     coordinatorFactory: mockCoordinatorFactory,
                                     rootModuleFactory: RootModuleFactory())

        sut?.start()

        XCTAssertNotNil(window.rootViewController)
    }
}

private extension ApplicationCoordinatorTests {
    class MockCoordinatorFactory: CoordinatorFactoryInterface {

        let onboardingCoordinator: MockOnboardingCoordinator

        init(onboardingCoordinator: MockOnboardingCoordinator) {
            self.onboardingCoordinator = onboardingCoordinator
        }

        func createOnboardingCoordinatorFlow(root: UINavigationController) -> CoordinatorInterface & OnboardingCoordinatorOutput {
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
