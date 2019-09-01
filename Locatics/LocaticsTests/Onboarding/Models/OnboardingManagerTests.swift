//
//  OnboardingManagerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class OnboardingManagerTests: XCTestCase {

    override func tearDown() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        super.tearDown()
    }

    func test_onboardingDefaultIsFalse() {
        XCTAssertFalse(OnboardingManager.hasOnboarded())
    }

    func test_onboardingDefaultIsTrueWhenSet() {
        OnboardingManager.setOnboarding(true)
        XCTAssertTrue(OnboardingManager.hasOnboarded())
    }
}
