//
//  LaunchInstructorTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 03/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LaunchInstructorTests: XCTestCase {
    func test_launchInstructorFlowsToMainWhenOnboardingTrue() {
        XCTAssertTrue(LaunchInstructor.configure(userOnboarded: true) == .main)
    }

    func test_launchInstructorFlowsToOnboardingWhenOnboardingFalse() {
        XCTAssertTrue(LaunchInstructor.configure(userOnboarded: false) == .onboarding)
    }
}
