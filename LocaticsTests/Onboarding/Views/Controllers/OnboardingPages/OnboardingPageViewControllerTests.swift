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

    private var mockOnboardingNavigationViewModel: MockOnboardingNavigationViewModel!

    override func setUp() {
        let onboardingVC = createOnboardingPageVC(with: .onboardingWelcomePageViewController)
        sut = onboardingVC as? OnboardingWelcomePageViewController

        mockOnboardingNavigationViewModel = MockOnboardingNavigationViewModel()
        sut.onboardingNavigationViewModel = mockOnboardingNavigationViewModel
    }

    override func tearDown() {
        sut = nil
        mockOnboardingNavigationViewModel = nil
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

    func test_skipTapped_callsViewModelSkipTapped() {
        sut.skipTapped(UIButton())

        XCTAssertTrue(mockOnboardingNavigationViewModel.calledSkipTapped)
    }

    func test_nextTapped_callsViewModelNextTapped() {
        sut.nextTapped(UIButton())

        XCTAssertTrue(mockOnboardingNavigationViewModel.calledNextTapped)
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
