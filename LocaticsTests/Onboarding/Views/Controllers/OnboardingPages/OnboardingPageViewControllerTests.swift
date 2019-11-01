//
//  OnboardingWelcomePageViewControllerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 29/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class OnboardingPageViewControllerTests: XCTestCase {

    var sut: OnboardingWelcomePageViewController!

    override func setUp() {
        let onboardingVC = createOnboardingPageVC(with: .onboardingWelcomePageViewController)
        sut = onboardingVC as? OnboardingWelcomePageViewController
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_view_isNotNil() {
        XCTAssertNotNil(sut.view)
    }

    func test_onboardingImageView_isNotNil() {
        XCTAssertNotNil(sut.onboardingImageView)
    }

    func test_onboardingTitleLabel_isNotNil() {
        XCTAssertNotNil(sut.onboardingTitleLabel)
    }

    func test_onboardingDetailLabel_isNotNil() {
        XCTAssertNotNil(sut.onboardingDetailLabel)
    }
}

private extension OnboardingPageViewControllerTests {
    func createOnboardingPageVC(with identifier: OnboardingStoryboardIdentifier) -> UIViewController {
        let onboardingStoryboard = UIStoryboard.Storyboard.onboarding
        let onboardingVC = onboardingStoryboard.instantiateViewController(withIdentifier: identifier.rawValue)
        _ = onboardingVC.view

        return onboardingVC
    }
}
