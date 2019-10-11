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

    private var mockCoordinatorFactory: MockCoordinatorFactory!
    private var mockOnboardingCoordinator: MockOnboardingCoordinator!
    private var mockMainCoordinator: MockMainCoordinator!
    private var mockRootModuleFactory: MockRootModuleFactory!

    override func setUp() {
        mockOnboardingCoordinator = MockOnboardingCoordinator()
        mockMainCoordinator = MockMainCoordinator()
        mockCoordinatorFactory = MockCoordinatorFactory(onboardingCoordinator: mockOnboardingCoordinator,
                                                        mainCoordinator: mockMainCoordinator)
        mockRootModuleFactory = MockRootModuleFactory()

        window = UIWindow()
    }

    override func tearDown() {
        sut = nil
        window = nil
        mockCoordinatorFactory = nil
        mockOnboardingCoordinator = nil
        mockMainCoordinator = nil
        mockRootModuleFactory = nil
        super.tearDown()
    }

    func test_onboardingFlowGetsCalledWhenLaunchInstructor_isOnboarding() {
        sut = ApplicationCoordinator(window: window,
                                     launchInstructor: .onboarding,
                                     coordinatorFactory: mockCoordinatorFactory,
                                     rootModuleFactory: RootModuleFactory())

        sut?.start()

        XCTAssertTrue(mockOnboardingCoordinator.startWasCalled)
    }

    func test_windowRootControllerIsNotNil_afterStart() {
        sut = ApplicationCoordinator(window: window,
                                     launchInstructor: .onboarding,
                                     coordinatorFactory: mockCoordinatorFactory,
                                     rootModuleFactory: RootModuleFactory())

        sut?.start()

        XCTAssertNotNil(window.rootViewController)
    }

    func test_startOnboardingFlowFinished_startsMainFlow() {
        sut = ApplicationCoordinator(window: window,
                                     launchInstructor: .onboarding,
                                     coordinatorFactory: mockCoordinatorFactory,
                                     rootModuleFactory: RootModuleFactory())

        sut?.start()

        mockOnboardingCoordinator.triggerFinishOnboarding()

        XCTAssertTrue(window.rootViewController is TabBarController)
        XCTAssertTrue(mockMainCoordinator.startWasCalled)
    }

    func test_startMainFlow_passesTwoNavigationViewControllersToCreateTabBarController() {
        sut = ApplicationCoordinator(window: window,
                                     launchInstructor: .main,
                                     coordinatorFactory: mockCoordinatorFactory,
                                     rootModuleFactory: mockRootModuleFactory)
        sut?.start()

        XCTAssertTrue(mockRootModuleFactory.calledCreateTabBarController)

        XCTAssertEqual(mockRootModuleFactory.passedCreateTabBarRootControllers!.count,
                       2)

        XCTAssertTrue(mockRootModuleFactory.passedCreateTabBarRootControllers!.first! is NavigationViewController)
        XCTAssertTrue(mockRootModuleFactory.passedCreateTabBarRootControllers!.last! is NavigationViewController)
    }

    func test_startMainFlowGetsCalledWhenLaunchInstructor_isMain() {
        sut = ApplicationCoordinator(window: window,
                                     launchInstructor: .main,
                                     coordinatorFactory: mockCoordinatorFactory,
                                     rootModuleFactory: RootModuleFactory())

        sut?.start()

        XCTAssertTrue(window.rootViewController is TabBarController)
        XCTAssertTrue(mockMainCoordinator.startWasCalled)

        XCTAssertFalse(mockOnboardingCoordinator.startWasCalled)
    }
}
