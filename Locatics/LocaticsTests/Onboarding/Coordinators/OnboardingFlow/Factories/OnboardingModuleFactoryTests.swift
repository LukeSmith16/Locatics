//
//  OnboardingModuleFactoryTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class OnboardingModuleFactoryTests: XCTestCase {

    var sut: OnboardingModuleFactoryInterface!

    override func setUp() {
        sut = OnboardingModuleFactory()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_createOnboardingModuleInjectsViewModelIntoVC() {
        let onboardingModule = sut.createOnboardingModule(delegate: nil)
        XCTAssertNotNil(onboardingModule.onboardingViewModel)
    }
}
