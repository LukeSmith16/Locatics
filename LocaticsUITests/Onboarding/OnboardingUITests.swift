//
//  OnboardingUITests.swift
//  LocaticsUITests
//
//  Created by Luke Smith on 05/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class OnboardingUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()

        /// To reset the state for onboarding.
        app.launchArguments.append("--uitesting")
    }

    func testOnboarding() {}
}

extension XCUIApplication {
    var isDisplayingOnboarding: Bool {
        return otherElements["onboardingView"].exists
    }
}
