//
//  UIStoryboard+ExtensionsTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class UIStoryboardExtensionsTests: XCTestCase {

    func test_storyboardOnboarding_returnsOnboardingStoryboard() {
        let onboardingStoryboard = UIStoryboard.Storyboard.onboarding
        XCTAssertTrue(onboardingStoryboard.instantiateInitialViewController() is OnboardingViewController)
    }

    func test_storyboardMain_returnsMainStoryboard() {
        let mainStoryboard = UIStoryboard.Storyboard.main
        XCTAssertTrue(mainStoryboard.instantiateInitialViewController() is TabBarController)
    }
}
