//
//  OnboardingViewControllerDesignableTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 29/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class OnboardingViewControllerDesignableTests: XCTestCase {
    func test_setupViews() {
        let onboardingStoryboard = UIStoryboard.Storyboard.onboarding
        let identifier = OnboardingStoryboardIdentifier.onboardingWelcomePageViewController

        let onboardingVC = onboardingStoryboard.instantiateViewController(withIdentifier: identifier.rawValue)

        guard let sut = onboardingVC as? OnboardingWelcomePageViewController else {
            XCTFail("OnboardingVC should be instantiated as 'OnboardingWelcomePageViewController'")
            return
        }

        _ = sut.view

        XCTAssertFalse(sut.onboardingImageView.clipsToBounds)
        XCTAssertEqual(sut.onboardingImageView.layer.shadowColor, UIColor.black.cgColor)
        XCTAssertEqual(sut.onboardingImageView.layer.shadowOpacity, 0.20)
        XCTAssertEqual(sut.onboardingImageView.layer.shadowOffset, CGSize(width: 0, height: 0))

        checkKernIsNotNil(for: sut.onboardingTitleLabel.attributedText)
        checkKernIsNotNil(for: sut.onboardingDetailLabel.attributedText)

        XCTAssertEqual(sut.onboardingDetailLabel.textColor,
                       UIColor(colorTheme: .Title_Action).withAlphaComponent(0.85))
    }
}

private extension OnboardingViewControllerDesignableTests {
    func checkKernIsNotNil(for attributedText: NSAttributedString?) {
        XCTAssertNotNil(attributedText)

        var range = NSRange(location: 0, length: attributedText!.length)
        let kern = attributedText!.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: &range)
        XCTAssertNotNil(kern)
    }
}
