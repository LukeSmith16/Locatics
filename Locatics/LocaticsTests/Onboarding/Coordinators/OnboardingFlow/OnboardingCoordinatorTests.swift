//
//  OnboardingCoordinatorTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class OnboardingCoordinatorTests: XCTestCase {

    var root: UINavigationController!
    var sut: OnboardingCoordinator!

    override func setUp() {
        root = UINavigationController()
        sut = OnboardingCoordinator(root: root, factory: OnboardingModuleFactory())
    }

    override func tearDown() {
        root = nil
        sut = nil
        super.tearDown()
    }

    func test_startAddsOnboardingVCToStack() {
        XCTAssertEqual(root.viewControllers.count, 0)

        sut.start()

        XCTAssertEqual(root.viewControllers.count, 1)
        XCTAssertTrue(root.viewControllers.first! is OnboardingViewController)
    }

    func test_goToOnboardingFinishedCallesFinishedOnboarding() {
        sut = OnboardingCoordinator(root: root, factory: OnboardingModuleFactory())

        var calledFinishedOnboarding = false
        sut.finishedOnboarding = {
            calledFinishedOnboarding = true
        }

        sut.goToOnboardingFinished()

        XCTAssertTrue(calledFinishedOnboarding)
    }

}
